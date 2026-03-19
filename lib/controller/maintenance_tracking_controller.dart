import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grpc/grpc.dart';
import 'package:hj_app/view/screen/maintenance_tracking_screen.dart';
import '../grpc/maintenance_order.pb.dart';
import '../grpc/maintenance_order.pbgrpc.dart';
import '../global/globalUI.dart';
import '../model/notification.dart';

enum GrpcConnectionState { disconnected, connecting, connected, error }

/// Controls the gRPC real-time maintenance tracking stream.
///
/// Key design decisions:
/// - Only connects when a user is signed in (has a CustID).
/// - Only shows ACTIVE (non-terminal) orders.  Closed/canceled orders are
///   delivered once as a final update, then removed from displayed data and
///   from local storage so they never appear again on next launch.
/// - On app resume, reconnects only if there are still active orders.
/// - When the gRPC server closes the stream after a terminal update (server-
///   initiated close), the controller does NOT schedule a reconnect.
/// - Exponential-backoff reconnect for genuine connection failures.
class MaintenanceTrackingController extends GetxController
    with WidgetsBindingObserver {
  // ── Observable state ──────────────────────────────────────────────────────
  final connectionState = GrpcConnectionState.disconnected.obs;

  /// Active (non-terminal) maintenance orders for the current user.
  final updates = <MaintenanceOrderUpdate>[].obs;

  final errorMessage = ''.obs;
  final showFab = false.obs;
  final isTrackingFinished = false.obs;

  // ── gRPC internals ────────────────────────────────────────────────────────
  ClientChannel? _channel;
  MaintenanceOrderServiceClient? _stub;
  StreamSubscription<MaintenanceOrderUpdate>? _subscription;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;

  /// True when the server closed the stream intentionally (terminal state).
  /// In this case we must NOT reschedule a reconnect.
  bool _serverClosedIntentionally = false;

  String _currentCustId = '';
  static const String _storageKey = 'maintenance_updates_v3';
  static const String _stateKey = 'maintenance_navigation_state';

  // ── Configuration ─────────────────────────────────────────────────────────
  static const String _grpcHost = 'appmb.hassanjameelapp.com';
  static const int _grpcPort = 443;
  static const bool _useTls = true;
  static const int _maxReconnects = 9999;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _updateCurrentCustId();

    // Load only active orders from previous sessions.
    // Closed/canceled orders are never persisted.
    _loadActiveFromStorage();

    // First-boot gRPC connect — only if the user is already logged in.
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_currentCustId.isNotEmpty) {
        connect();
        _restoreNavigationState();
      }
    });

    // Reactive login/logout listener.
    GetStorage().listenKey(loginKey, (val) {
      debugPrint(
        '[gRPC] Auth change detected: ${val != null ? "LOGGED IN" : "LOGGED OUT"}',
      );
      _updateCurrentCustId();
      if (val != null) {
        _loadActiveFromStorage();
        connect();
      } else {
        // User signed out — disconnect immediately and clear ALL data.
        _doDisconnect();
        _clearAllData();
      }
    });

    // Sync FAB visibility with active-order state.
    ever(updates, (_) => _syncFabState());
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _reconnectTimer?.cancel();
    _doDisconnect();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint('[gRPC] App resumed. Checking connection status…');
      _updateCurrentCustId();

      if (_currentCustId.isNotEmpty) {
        // Only trigger a new connection if we are disconnected or in error state.
        // Don't call reconnect() (which forces disconnect) if we are already connected.
        if (connectionState.value == GrpcConnectionState.disconnected ||
            connectionState.value == GrpcConnectionState.error) {
          connect();
        } else {
          debugPrint('[gRPC] Still connected, skipping redundant reconnect.');
        }
      } else {
        _doDisconnect();
      }
    }
  }

  // ── Public API ────────────────────────────────────────────────────────────

  /// Trigger a fresh reconnect (e.g. from a "Retry" button).
  Future<void> reconnect() async {
    _reconnectTimer?.cancel();
    _reconnectAttempts = 0;
    _serverClosedIntentionally = false;
    await _doDisconnect(keepAttempts: false);
    await connect();
  }

  /// Called by the FAB when the user taps on it.
  void onFabPressed() {
    if (isTrackingFinished.value) {
      _showCompletionDialog(canceled: false);
    } else {
      Get.to(() => const MaintenanceTrackingScreen());
    }
  }

  /// Shows success/completion dialog.  Called from navigation (FCM tap) or FAB.
  void showCompletionDialogIfNeeded({bool canceled = false}) {
    if (isTrackingFinished.value || canceled) {
      _showCompletionDialog(canceled: canceled);
    } else {
      Get.to(() => const MaintenanceTrackingScreen());
    }
  }

  /// Navigate to tracking screen, showing the success dialog on top if the
  /// latest order is terminal.
  void navigateToTracking({bool showSuccess = false, bool canceled = false}) {
    Get.to(() => const MaintenanceTrackingScreen());
    if (showSuccess || isTrackingFinished.value) {
      Future.delayed(const Duration(milliseconds: 400), () {
        _showCompletionDialog(canceled: canceled);
      });
    }
  }

  // ── gRPC connection ───────────────────────────────────────────────────────

  Future<void> connect() async {
    // Guard: do not connect unless signed in
    _updateCurrentCustId();
    if (_currentCustId.isEmpty) {
      debugPrint('[gRPC] Skip connect: not signed in.');
      connectionState.value = GrpcConnectionState.disconnected;
      return;
    }

    // Guard: do not double-connect
    if (connectionState.value == GrpcConnectionState.connecting) return;

    // Guard: do not reconnect after server-intentional close
    if (_serverClosedIntentionally) {
      debugPrint(
        '[gRPC] Skip connect: stream closed intentionally (no active order).',
      );
      return;
    }

    connectionState.value = GrpcConnectionState.connecting;
    errorMessage.value = '';

    try {
      debugPrint(
        '[gRPC] Connecting to $_grpcHost:$_grpcPort  CustId="$_currentCustId"',
      );

      _channel = ClientChannel(
        _grpcHost,
        port: _grpcPort,
        options: ChannelOptions(
          credentials: _useTls
              ? const ChannelCredentials.secure()
              : const ChannelCredentials.insecure(),
          idleTimeout: const Duration(minutes: 10),
          keepAlive: const ClientKeepAliveOptions(
            pingInterval: Duration(seconds: 30),
            timeout: Duration(seconds: 15),
            permitWithoutCalls: true,
          ),
        ),
      );

      _stub = MaintenanceOrderServiceClient(_channel!);

      final stream = _stub!.streamMaintenanceUpdates(
        StreamRequest(customerId: _currentCustId),
      );

      _subscription = stream.listen(
        _onUpdate,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );

      connectionState.value = GrpcConnectionState.connected;
      _reconnectAttempts = 0;
      debugPrint('[gRPC] ✅ Streaming started for CustId="$_currentCustId".');
    } catch (e) {
      debugPrint('[gRPC] ❌ Connection failed: $e');
      errorMessage.value = e.toString();
      connectionState.value = GrpcConnectionState.error;
      _scheduleReconnect();
    }
  }

  // ── Private stream handlers ───────────────────────────────────────────────

  void _onUpdate(MaintenanceOrderUpdate update) {
    debugPrint(
      '[gRPC] ✉ Order=${update.maintenanceOrderId}  '
      'Status=${update.orderStatusId}  '
      'Closed=${update.isClosed}  Canceled=${update.isCanceled}  '
      'CustId="${update.custId}"',
    );

    // Client-side security: ignore messages not for the current user
    if (_currentCustId.isNotEmpty &&
        update.custId.isNotEmpty &&
        update.custId != _currentCustId) {
      debugPrint(
        '[gRPC] ⚠️ Ignoring update for different CustId: ${update.custId}',
      );
      return;
    }

    // ── Handle terminal state ─────────────────────────────────────────────
    if (update.isTerminal) {
      debugPrint(
        '[gRPC] Received terminal update for ${update.maintenanceOrderId}',
      );
      // Show the final status once in the UI, then remove from visible list
      // and clear storage so it won't reappear.
      isTrackingFinished.value =
          !update.isCanceled; // "finished" = completed, not canceled
      showFab.value = true; // Show FAB to trigger success/cancel dialog

      // Update or remove from the observable list
      _upsertUpdate(update);

      // Schedule cleanup and save AFTER user has a chance to see final state
      // (The FAB remains until they press it or logout)
      _saveToStorage();
      _saveNavigationState('completed', data: {'canceled': update.isCanceled});

      // ── Garantee Delivery & Persistance ──────────────────────────────────────
      _persistAsNotification(update);
      _confirmDelivery(update);
      return;
    }

    // ── Active order update ─────────────────────────────────────────────────
    isTrackingFinished.value = false;
    showFab.value = true;
    _upsertUpdate(update);
    _saveToStorage();
    _saveNavigationState('tracking');

    // ── Garantee Delivery & Persistance ──────────────────────────────────────
    _persistAsNotification(update);
    _confirmDelivery(update);

    // ── In-App Themed Notification ───────────────────────────────────────────
    _showInAppNotification(update);
  }

  void _showInAppNotification(MaintenanceOrderUpdate update) {
    bool isDark = themeModeValue == 'dark';
    String title = language == 'ar'
        ? 'تحديث صيانة مركبتك'
        : 'Maintenance Update';
    String body = language == 'ar'
        ? 'تحديث جديد لحالة المركبة ${update.plateNo}: ${statusLabel(update.orderStatusId, "ar")}'
        : 'Status update for ${update.plateNo}: ${statusLabel(update.orderStatusId, "en")}';

    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isDark ? const Color(0xFF2C2C2E) : Colors.white,
      colorText: isDark ? Colors.white : blackColor,
      icon: Icon(
        Icons.build_circle_rounded,
        color: statusColor(update.orderStatusId),
      ),
      mainButton: TextButton(
        onPressed: () {
          Get.back(); // close snackbar
          navigateToTracking();
        },
        child: Text(
          language == 'ar' ? 'فتح' : 'Open',
          style: TextStyle(color: greenColor, fontWeight: FontWeight.bold),
        ),
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 5),
    );
  }

  void _confirmDelivery(MaintenanceOrderUpdate update) async {
    if (_stub == null) return;
    try {
      final ack = AckRequest()
        ..customerId = _currentCustId
        ..maintenanceOrderId = update.maintenanceOrderId
        ..orderStatusId = update.orderStatusId;

      await _stub!.acknowledgeUpdate(ack);
      debugPrint('[gRPC] ✅ ACK sent for ${update.maintenanceOrderId}');
    } catch (e) {
      debugPrint('[gRPC] ❌ ACK failed: $e');
    }
  }

  void _persistAsNotification(MaintenanceOrderUpdate update) {
    // Add to global notification list (persists to key_notifications)
    try {
      final title = language == 'ar'
          ? 'تحديث صيانة مركبتك'
          : 'Maintenance Update';
      final body = language == 'ar'
          ? 'تحديث جديد لحالة المركبة ${update.plateNo}: ${statusLabel(update.orderStatusId, "ar")}'
          : 'Status update for ${update.plateNo}: ${statusLabel(update.orderStatusId, "en")}';

      // Avoid duplicates based on body match
      final currentNotifs = notificationData();
      bool exists = currentNotifs.any((n) => n.bodyAr == body);

      if (!exists) {
        // Generate a numeric ID for the notification
        final int generatedId =
            update.maintenanceOrderId.hashCode ^ update.orderStatusId;

        notificationAdd(
          NotificationClass(
            id: generatedId,
            titleAr: title,
            titleEn: title,
            bodyAr: body,
            bodyEn: body,
            date: DateTime.now().toString(),
            route: 'maintenance_tracking',
          ),
        );
      }
    } catch (e) {
      debugPrint('[gRPC] Error saving notification: $e');
    }
  }

  void _saveNavigationState(String state, {Map<String, dynamic>? data}) {
    writeGetStorage(_stateKey, {
      'state': state, // 'tracking' or 'completed'
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void _restoreNavigationState() {
    final saved = readGetStorage(_stateKey);
    if (saved == null) return;

    final state = saved['state'];
    final timestamp = DateTime.tryParse(saved['timestamp'] ?? '');

    // Don't restore if it's too old (e.g. > 24h)
    if (timestamp == null ||
        DateTime.now().difference(timestamp).inHours > 24) {
      removeGetStorage(_stateKey);
      return;
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (state == 'completed') {
        final canceled = saved['data']?['canceled'] ?? false;
        _showCompletionDialog(canceled: canceled);
      } else if (state == 'tracking' && hasActiveData()) {
        Get.to(() => const MaintenanceTrackingScreen());
      }
    });
  }

  void _onError(dynamic error) {
    debugPrint('[gRPC] ❌ Stream error: $error');
    errorMessage.value = error.toString();
    connectionState.value = GrpcConnectionState.error;
    if (!_serverClosedIntentionally) {
      _scheduleReconnect();
    }
  }

  void _onDone() {
    debugPrint('[gRPC] Stream done (server closed). Auto-reconnecting...');
    if (connectionState.value != GrpcConnectionState.disconnected) {
      // Unexpected close — attempt reconnect.
      connectionState.value = GrpcConnectionState.error;
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (connectionState.value == GrpcConnectionState.disconnected) return;
    if (_reconnectAttempts >= _maxReconnects) {
      errorMessage.value = 'Unable to reach the tracking service.';
      return;
    }
    _reconnectAttempts++;
    final delay = _reconnectAttempts <= 3
        ? const Duration(seconds: 1)
        : Duration(seconds: (2 << _reconnectAttempts.clamp(0, 5)).clamp(2, 60));
    debugPrint('[gRPC] Retry #$_reconnectAttempts in ${delay.inSeconds}s …');
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () async {
      await _doDisconnect(keepAttempts: true);
      await connect();
    });
  }

  Future<void> _doDisconnect({bool keepAttempts = false}) async {
    _reconnectTimer?.cancel();
    await _subscription?.cancel();
    _subscription = null;
    try {
      await _channel?.shutdown();
    } catch (_) {}
    _channel = null;
    _stub = null;
    if (!keepAttempts) {
      _reconnectAttempts = 0;
      connectionState.value = GrpcConnectionState.disconnected;
    }
  }

  // ── Data management ───────────────────────────────────────────────────────

  /// Insert or update an order in the observable list (most recent first).
  void _upsertUpdate(MaintenanceOrderUpdate update) {
    final idx = updates.indexWhere(
      (e) => e.maintenanceOrderId == update.maintenanceOrderId,
    );
    if (idx != -1) {
      updates[idx] = update;
    } else {
      updates.insert(0, update);
    }
    if (updates.length > 50) updates.removeLast();
  }

  /// Remove any orders that have reached a terminal state from the visible list.
  void _removeTerminalOrders() {
    updates.removeWhere((u) => u.isTerminal);
  }

  void _syncFabState() {
    if (updates.isEmpty) {
      if (!isTrackingFinished.value) {
        showFab.value = false;
      }
      // If isTrackingFinished is true we keep the FAB visible so the user can
      // tap it to see the success dialog one more time.
      return;
    }
    final latest = updates.first;
    showFab.value = latest.orderStatusId < 6; // Active order → show FAB
    if (latest.isTerminal) {
      isTrackingFinished.value = true;
    }
  }

  /// Returns true if there is at least one active (non-terminal) order in memory.
  bool hasActiveData() => updates.any((u) => !u.isTerminal);

  void _updateCurrentCustId() {
    final loginData = readGetStorage(loginKey);
    _currentCustId =
        loginData?['CustID']?.toString() ??
        loginData?['custId']?.toString() ??
        '';
  }

  /// Loads only active (non-terminal) orders from storage.
  /// Terminal orders are intentionally skipped so they never resurface.
  void _loadActiveFromStorage() {
    if (_currentCustId.isEmpty) return;
    try {
      final List<dynamic>? stored = readGetStorage(_storageKey);
      if (stored == null || stored.isEmpty) return;

      final items = stored
          .map((json) {
            try {
              return MaintenanceOrderUpdate.fromJson(json as String);
            } catch (_) {
              return null;
            }
          })
          .whereType<MaintenanceOrderUpdate>()
          // Only load orders belonging to this user AND that are NOT terminal.
          .where((u) => u.custId == _currentCustId && !u.isTerminal)
          .toList();

      updates.assignAll(items);
      _syncFabState();
    } catch (e) {
      debugPrint('[gRPC] Error loading from storage: $e');
    }
  }

  void _saveToStorage() {
    try {
      // Only persist active orders — never persist terminal ones.
      final activeOnly = updates.where((u) => !u.isTerminal).toList();
      final jsonList = activeOnly.map((e) => e.writeToJson()).toList();
      writeGetStorage(_storageKey, jsonList);
    } catch (e) {
      debugPrint('[gRPC] Error saving to storage: $e');
    }
  }

  /// Wipes all data from storage and memory. Called on logout.
  void _clearAllData() {
    updates.clear();
    showFab.value = false;
    isTrackingFinished.value = false;
    _serverClosedIntentionally = false;
    writeGetStorage(_storageKey, <dynamic>[]);
    debugPrint('[gRPC] All maintenance data cleared (logout).');
  }

  // ── Success / Completion dialogs ─────────────────────────────────────────

  void _showCompletionDialog({required bool canceled}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: (canceled ? redColor : greenColor).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    canceled
                        ? Icons.cancel_rounded
                        : Icons.check_circle_rounded,
                    color: canceled ? redColor : greenColor,
                    size: 52,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                canceled
                    ? (language == 'ar' ? 'تم إلغاء الطلب' : 'Order Canceled')
                    : (language == 'ar' ? 'تمت المهمة بنجاح!' : 'Completed!'),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: themeModeValue == 'dark' ? Colors.white : blackColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                canceled
                    ? (language == 'ar'
                          ? 'تم إلغاء طلب الصيانة الخاص بك. إذا كان لديك أي استفسار يرجى التواصل معنا.'
                          : 'Your maintenance order has been canceled. Please contact us if you have any questions.')
                    : (language == 'ar'
                          ? 'تم الانتهاء من صيانة مركبتك واستلامها بنجاح. شكراً لثقتكم بنا.'
                          : 'Your vehicle maintenance is finished and delivered successfully. Thank you for choosing us.'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: themeModeValue == 'dark'
                      ? Colors.white70
                      : Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    showFab.value = false;
                    isTrackingFinished.value = false;
                    _removeTerminalOrders(); // Clear only finished ones
                    _saveToStorage();
                    _syncFabState();
                    removeGetStorage(_stateKey); // Clear the persisted state
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canceled ? redColor : greenColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    language == 'ar' ? 'إغلاق' : 'Close',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // ── Utility ───────────────────────────────────────────────────────────────

  static String statusLabel(int id, String lang) {
    final labels = {
      1: (ar: 'قيد الانتظار', en: 'Pending'),
      2: (ar: 'جارٍ التنفيذ', en: 'In Progress'),
      3: (ar: 'انتظار قطع الغيار', en: 'Awaiting Parts'),
      4: (ar: 'جاهز للفحص', en: 'Ready for Inspection'),
      5: (ar: 'مكتمل', en: 'Completed'),
      6: (ar: 'تم التسليم', en: 'Delivered'),
      7: (ar: 'ملغي', en: 'Canceled'),
    };
    final entry = labels[id];
    if (entry == null) return lang == 'ar' ? 'الحالة $id' : 'Status $id';
    return lang == 'ar' ? entry.ar : entry.en;
  }

  static Color statusColor(int id) {
    switch (id) {
      case 1:
        return greyDarkColor;
      case 2:
        return blueColor;
      case 3:
        return redColor;
      case 4:
        return const Color(0xFF8B5CF6);
      case 5:
        return greenColor;
      case 6:
        return greyColor2;
      case 7:
        return redColor; // Canceled
      default:
        return greyColor3;
    }
  }
}
