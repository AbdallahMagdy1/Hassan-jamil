import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/maintenance_tracking_controller.dart';
import '../../global/globalUI.dart';
import '../../grpc/maintenance_order.pb.dart';

class MaintenanceTrackingScreen extends StatelessWidget {
  const MaintenanceTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MaintenanceTrackingController>();
    final bool isDark = themeModeValue == 'dark';

    return Scaffold(
      backgroundColor: isDark ? darkColor : greyColor5,
      appBar: AppBar(
        backgroundColor: isDark ? darkColor : Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            size: 18,
          ),
        ),
        title: Text(
          language == 'ar' ? 'تتبع مركبتك' : 'Track Your Vehicle',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(
            () => _ConnectionBadge(
              state: ctrl.connectionState.value,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // SliverToBoxAdapter(
          //   child: Obx(
          //     () => _ConnectionStatusBar(state: ctrl.connectionState.value),
          //   ),
          // ),
          Obx(() {
            if (ctrl.updates.isEmpty) {
              return SliverFillRemaining(
                child: _EmptyTrackingState(isDark: isDark),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _EnhancedOrderCard(
                    update: ctrl.updates[index],
                    isDark: isDark,
                  ),
                  childCount: ctrl.updates.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ConnectionBadge extends StatelessWidget {
  final GrpcConnectionState state;
  final bool isDark;
  const _ConnectionBadge({required this.state, required this.isDark});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (state) {
      case GrpcConnectionState.connected:
        color = greenColor;
        label = language == 'ar' ? 'متصل' : 'LIVE';
        break;
      case GrpcConnectionState.connecting:
        color = Colors.amber;
        label = language == 'ar' ? 'اتصال' : 'LINKING';
        break;
      default:
        color = redColor;
        label = language == 'ar' ? 'منقطع' : 'LOST';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// class _ConnectionStatusBar extends StatelessWidget {
//   final GrpcConnectionState state;
//   const _ConnectionStatusBar({required this.state});

//   @override
//   Widget build(BuildContext context) {
//     if (state == GrpcConnectionState.connected) return const SizedBox.shrink();

//     return Container(
//       width: double.infinity,
//       color: state == GrpcConnectionState.error ? redColor : Colors.amber,
//       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
//       child: Text(
//         state == GrpcConnectionState.error
//             ? (language == 'ar'
//                   ? 'عذراً، انقطع الاتصال بالخادم. جارٍ المحاولة…'
//                   : 'Connection lost. Retrying…')
//             : (language == 'ar'
//                   ? 'جارٍ تأسيس اتصال آمن بمحطة الصيانة…'
//                   : 'Securing connection to maintenance station…'),
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }

class _EnhancedOrderCard extends StatelessWidget {
  final MaintenanceOrderUpdate update;
  final bool isDark;
  const _EnhancedOrderCard({required this.update, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final statusColor = MaintenanceTrackingController.statusColor(
      update.orderStatusId,
    );
    final statusText = MaintenanceTrackingController.statusLabel(
      update.orderStatusId,
      language,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isDark ? buttonDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header Section ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _StatusIcon(statusColor: statusColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        update.plateNo.isNotEmpty
                            ? update.plateNo
                            : '#${update.maintenanceOrderId}',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : blackColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        language == 'ar'
                            ? update.descriptionAr
                            : update.descriptionEn,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? greyDarkColor : greyColor3,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(statusText: statusText, statusColor: statusColor),
              ],
            ),
          ),

          // ── Timeline Section ────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withOpacity(0.15) : greyColor6,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                _TimelineRow(
                  label: language == 'ar' ? 'تاريخ الدخول' : 'Check-in Date',
                  value: _formatDate(update.dateIn),
                  icon: 'assets/icons/check_in.svg',
                  color: greenColor,
                  isFirst: true,
                  isActive: true,
                ),
                _TimelineRow(
                  label: language == 'ar' ? 'فحص المركبة' : 'Inspection',
                  value: _formatDate(update.dateCompleteInspection),
                  icon: 'assets/icons/inspection.svg',
                  color: greenColor,
                  isActive: update.dateCompleteInspection.isNotEmpty,
                  isLoading:
                      update.dateIn.isNotEmpty &&
                      update.dateCompleteInspection.isEmpty,
                ),
                _TimelineRow(
                  label: language == 'ar'
                      ? 'اعمال الصيانة'
                      : 'Maintenance Works',
                  value: update.orderStatusId >= 5
                      ? (language == 'ar' ? 'مكتمل' : 'Completed')
                      : (language == 'ar' ? 'جارٍ العمل' : 'In Progress'),
                  icon: 'assets/icons/maintenance_work.svg',
                  color: greenColor,
                  isActive: update.orderStatusId >= 2,
                  isLoading:
                      update.dateCompleteInspection.isNotEmpty &&
                      update.orderStatusId < 5,
                ),
                _TimelineRow(
                  label: language == 'ar' ? 'استلام المركبة' : 'Delivery',
                  value: update.orderStatusId == 6
                      ? (language == 'ar' ? 'تم التسليم' : 'Delivered')
                      : (language == 'ar' ? 'بالانتظار' : 'Pending'),
                  icon: 'assets/icons/delivered.svg',
                  color: greenColor,
                  isLast: true,
                  isActive: update.orderStatusId >= 6,
                  isLoading: update.orderStatusId == 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String raw) {
    if (raw.isEmpty) return language == 'ar' ? 'بالانتظار' : 'Pending';
    try {
      final dt = DateTime.parse(raw);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (_) {
      return raw;
    }
  }
}

class _StatusIcon extends StatelessWidget {
  final Color statusColor;
  const _StatusIcon({required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(Icons.car_repair_rounded, color: statusColor, size: 24),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String statusText;
  final Color statusColor;
  const _StatusBadge({required this.statusText, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        statusText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color color;
  final bool isFirst;
  final bool isLast;
  final bool isActive;
  final bool isLoading;

  const _TimelineRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.isFirst = false,
    this.isLast = false,
    this.isActive = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAr = language == 'ar';
    return SizedBox(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visual line and dots
          Column(
            children: [
              Container(
                width: 2,
                height: 10,
                color: isFirst
                    ? Colors.transparent
                    : (isActive ? color : Colors.grey.withOpacity(0.2)),
              ),
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: isActive ? color : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive ? color : Colors.grey.withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(2),
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isActive ? Colors.white : color,
                          ),
                        ),
                      )
                    : (isActive
                          ? const Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 8,
                              ),
                            )
                          : null),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: isLast
                      ? Colors.transparent
                      : (isActive ? color : Colors.grey.withOpacity(0.2)),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isActive ? color : Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isActive
                        ? (themeModeValue == 'dark'
                              ? Colors.white70
                              : Colors.black87)
                        : Colors.grey.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            icon,
            width: 20,
            height: 20,
            color: isActive
                ? Color(0xff23cc4f)
                : greyDarkColor.withOpacity(0.9),
          ),
        ],
      ),
    );
  }
}

class _EmptyTrackingState extends StatelessWidget {
  final bool isDark;
  const _EmptyTrackingState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : greenColor).withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.track_changes_rounded,
                  size: 64,
                  color: (isDark ? Colors.white : greenColor).withOpacity(0.1),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              language == 'ar' ? 'لا يوجد تتبع نشط' : 'No Active Tracking',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              language == 'ar'
                  ? 'ستظهر هنا تفاصيل صيانة مركبتك بمجرد استلامها في المحطة.'
                  : 'Vehicle maintenance updates will appear here in real-time once received.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white54 : Colors.black54,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
