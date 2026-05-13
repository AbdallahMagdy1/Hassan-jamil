import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hj_app/app.dart';
import 'package:hj_app/controller/locale_controller.dart';
import 'package:hj_app/controller/themeController.dart';
import 'package:hj_app/model/notification.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'global/globalUI.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'global/enumMethod.dart';
import 'global/queryModel.dart';
import 'global/globalUrl.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
String? fcmToken;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background Message notification: ${message.notification}");
  print("Background Message notification: ${message.notification?.body}");

  String? img =
      message.data['imageUrl'] ??
      message.data['image'] ??
      message.data['ImageUrl'] ??
      message.data['Image'];

  notificationAdd(
    NotificationClass(
      id: null,
      titleEn: message.data['titleEn'] ?? message.notification?.title ?? '',
      titleAr: message.data['titleAr'] ?? message.notification?.title ?? '',
      bodyEn: message.data['bodyEn'] ?? message.notification?.body ?? '',
      bodyAr: message.data['bodyAr'] ?? message.notification?.body ?? '',
      route: message.data['route'] ?? '',
      imageUrl: img,
      offerType: message.data['offerType'] ?? message.data['OfferType'],
      slugAr: message.data['slugAr'] ?? message.data['SlugAr'],
      slugEn: message.data['slugEn'] ?? message.data['SlugEn'],
      date: DateTime.now().toString(),
    ),
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // App Tracking Transparency Request
  try {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 1000));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  } catch (e) {
    debugPrint("AppTrackingTransparency error: $e");
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // // Foreground Message Listener
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   debugPrint(
  //     "🔔 Foreground Message received: ${message.notification?.title}",
  //   );
  //   debugPrint("📦 Message Data: ${message.data}");

  //   // Manual sync/add to history if needed
  //   String? img =
  //       message.data['imageUrl'] ??
  //       message.data['image'] ??
  //       message.data['ImageUrl'] ??
  //       message.data['Image'];

  //   notificationAdd(
  //     NotificationClass(
  //       id: null,
  //       titleEn: message.data['titleEn'] ?? message.notification?.title ?? '',
  //       titleAr: message.data['titleAr'] ?? message.notification?.title ?? '',
  //       bodyEn: message.data['bodyEn'] ?? message.notification?.body ?? '',
  //       bodyAr: message.data['bodyAr'] ?? message.notification?.body ?? '',
  //       route: message.data['route'] ?? '',
  //       imageUrl: img,
  //       offerType: message.data['offerType'] ?? message.data['OfferType'],
  //       slugAr: message.data['slugAr'] ?? message.data['SlugAr'],
  //       slugEn: message.data['slugEn'] ?? message.data['SlugEn'],
  //       date: DateTime.now().toString(),
  //     ),
  //   );
  // });

  // Listen for Token Refresh
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    fcmToken = newToken;
    syncFcmToken();
  });

  // Initial Sync on Startup
  FirebaseMessaging.instance.getToken().then((token) {
    if (token != null) {
      fcmToken = token;
      syncFcmToken();
    }
  });

  // ByteData data =
  //     await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  // SecurityContext.defaultContext
  //     .setTrustedCertificatesBytes(data.buffer.asUint8List());

  Get.put(ThemeController());
  Get.put(LocaleController());
  // Get.put<JournifyBridgeController>(
  //   JournifyBridgeController(
  //     writeKey: "wk_test_38WNzjTQOQoj3KUruAm4QmOB7n1",
  //     allowedHosts: {"localhost:3000"},
  //   )..addPlugins(),
  //   permanent: true,
  // );
  // Initialize language and theme BEFORE runApp so that the first build
  // observes the correct values (prevents builds that run before
  // InitialBinding-based initialization).
  try {
    getLanguage();
    await getThemeStatus();

    await GoogleFonts.pendingFonts([
      GoogleFonts.getFont('Roboto'),
      GoogleFonts.getFont('Almarai'),
    ]);
  } catch (e) {
    debugPrint('Pre-runApp init error: $e');
  }

  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.manual,
  //   overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  // );

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;

  // Lock orientation to portrait modes (phone and tablet vertical only)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MyApp(
      channel: channel,
      version: version,
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    ),
  );
}

Future<void> getToken() async {
  fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint("🔑 FCM Token Initialized: $fcmToken");
  FirebaseMessaging.instance.subscribeToTopic("all");
  debugPrint("📡 Subscribed to 'all' topic.");
}

/// Syncs the FCM Token with the backend using the 'update' API style.
Future<void> syncFcmToken([Map<String, dynamic>? targetUserData]) async {
  try {
    String? currentToken = fcmToken;
    if (currentToken == null) {
      currentToken = await FirebaseMessaging.instance.getToken();
      if (currentToken == null) {
        debugPrint("⚠️ FCM Token is null. Sync aborted.");
        return;
      }
      fcmToken = currentToken;
    }

    debugPrint("📱 Current FCM Token: $currentToken");

    final storage = GetStorage();
    String? lastSyncedToken = storage.read('lastSyncedFcmToken');

    if (lastSyncedToken == currentToken) {
      debugPrint("ℹ️ Token is not expired/refreshed (same as last sync).");
    } else {
      debugPrint("🆕 Token is new or refreshed.");
    }

    var userData = targetUserData ?? readGetStorage(loginKey);

    if (userData == null) {
      debugPrint(
        "ℹ️ syncFcmToken skipped: No data found for key '$loginKey' in storage.",
      );
      return;
    }

    String? filter;
    if (userData['Email'] != null) {
      filter = "where Email = '${userData['Email']}'";
    } else if (userData['Phone'] != null) {
      filter = "where Phone = '${userData['Phone']}'";
    } else if (userData['IdentityNumber'] != null) {
      filter = "where IdentityNumber = '${userData['IdentityNumber']}'";
    }

    if (filter != null) {
      var response = await myRequest(
        url: 'api/Pages/Updateweb_users',
        method: HttpMethod.post,
        body: {
          "Filters": filter,
          "Values": {'Token': currentToken},
        },
      );

      if (response != null && response != false) {
        debugPrint("✅ FCM Token UPDATED on server for $filter");
        await storage.write('lastSyncedFcmToken', currentToken);
      } else {
        debugPrint("❌ Failed to update FCM Token on server for $filter");
      }
    } else {
      debugPrint("⚠️ No valid user identification field found for FCM sync.");
    }
  } catch (e) {
    debugPrint("❌ Error Syncing FCM Token: $e");
  }
}
