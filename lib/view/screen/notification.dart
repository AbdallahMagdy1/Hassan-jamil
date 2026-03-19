import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hj_app/controller/notification_controller.dart';
import 'package:hj_app/controller/maintenance_tracking_controller.dart';
import 'package:hj_app/view/screen/globalWebView.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../global/globalUI.dart';
import '../../model/notification.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<StatefulWidget> createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  BoxDecoration _containerDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: BorderRadius.circular(24.0),
      border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.2)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = themeModeValue == 'dark';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? darkColor : Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: isDark ? Colors.white : darkColor,
            size: 18,
          ),
        ),
        title: widgetText(
          context,
          'notifications'.tr,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: Future.value(notificationData()),
          builder:
              (
                BuildContext context,
                AsyncSnapshot<List<NotificationClass>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  // Filter notifications from the last 7 days
                  final sevenDaysAgo = DateTime.now().subtract(
                    const Duration(days: 7),
                  );
                  final filteredData =
                      snapshot.data?.where((noti) {
                        try {
                          return DateTime.parse(
                            noti.date,
                          ).isAfter(sevenDaysAgo);
                        } catch (_) {
                          return true; // Fallback if date is malformed
                        }
                      }).toList() ??
                      [];

                  if (filteredData.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none_rounded,
                            size: 64,
                            color: greyColor2.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          widgetText(
                            context,
                            'thereAreNoNotifications'.tr,
                            color: greyDarkColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    );
                  }
                  return Obx(() {
                    if (Get.isRegistered<NotificationController>()) {
                      Get.find<NotificationController>()
                          .notificationCount
                          .value;
                    }
                    return widgetListNotification(filteredData, isDark);
                  });
                }
              },
        ),
      ),
    );
  }

  String _mapImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) return "";

    // 1. Normalize slashes
    String path = url.trim().replaceAll("\\", "/");

    // 2. If it's a full URL from one of our domains, extract just the path
    if (path.startsWith("http")) {
      if (path.contains("hassanjameelapp.com") ||
          path.contains("hassanjameel.com.sa") ||
          path.contains("127.0.0.1") ||
          path.contains("localhost")) {
        try {
          Uri uri = Uri.parse(path);
          path = uri.path;
        } catch (e) {
          // Fallback: search for assets/UrlImages
          if (path.contains("assets/UrlImages/")) {
            path = "/assets/UrlImages/" + path.split("assets/UrlImages/").last;
          }
        }
      } else {
        // External image (Firebase, etc.) - return as is
        return path;
      }
    }

    // 3. Clean up the path (remove leading/multiple slashes)
    while (path.startsWith("/")) {
      path = path.substring(1);
    }

    // 4. Ensure it starts with assets/ if it's a known resource path
    if (path.contains("UrlImages") && !path.startsWith("assets/")) {
      path = "assets/$path";
    }

    // 5. Construct final URL
    String host = "https://appmb.hassanjameelapp.com";
    String finalUrl = "$host/$path";
    return finalUrl;
  }

  void _showNotificationDetail(NotificationClass noti, bool isDark) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: widgetText(
                        context,
                        language == "en" ? noti.titleEn : noti.titleAr,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
                const Divider(height: 24),
                if (noti.imageUrl != null && noti.imageUrl!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: _mapImageUrl(noti.imageUrl?.trim()),
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        memCacheWidth: 800,
                        placeholder: (context, url) => const SizedBox(
                          height: 250,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 250,
                          color: isDark ? Colors.white10 : Colors.black12,
                          child: Icon(
                            Icons.notifications_active_outlined,
                            size: 64,
                            color: greenColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                widgetText(
                  context,
                  language == "en" ? noti.bodyEn : noti.bodyAr,
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                const SizedBox(height: 20),
                if (noti.offerType != null && noti.offerType != "0")
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Get.back(); // Close dialog
                          String lang = language;
                          String slug = (noti.slugEn ?? noti.slugAr) ?? "";
                          int type = int.tryParse(noti.offerType ?? "0") ?? 0;

                          String? path;
                          if (type == 2) {
                            path = "/$lang/offerCarOverview/$slug";
                          } else if (type == 4) {
                            path = "/$lang/offerparts/$slug";
                          } else if (type == 3) {
                            path = "/$lang/offerMaintenanceServices/$slug";
                          }

                          if (path != null) {
                            String baseUrl = "https://app.hassanjameelapp.com";
                            Get.to(() => GlobalWebView(baseUrl + path!));
                          }
                        },
                        child: widgetText(
                          context,
                          'viewOffer'.tr,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: greyColor2),
                    const SizedBox(width: 4),
                    widgetText(
                      context,
                      DateFormat(
                        "yyyy-MM-dd HH:mm",
                      ).format(DateTime.parse(noti.date)),
                      color: greyColor2,
                      fontSize: 12,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetListNotification(List<NotificationClass> data, bool isDark) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: Get.width * .05, vertical: 20),
      itemCount: data.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, i) {
        return Slidable(
          key: Key(data[i].id.toString() + i.toString()),
          endActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const ScrollMotion(),
            children: [
              CustomSlidableAction(
                onPressed: (BuildContext context) async {
                  notificationDelete(i);
                  setState(() {});
                },
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                borderRadius: BorderRadius.circular(24),
                child: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              if (data[i].route == 'maintenance_tracking') {
                final controller = Get.find<MaintenanceTrackingController>();
                // The route indicates this is a gRPC maintenance update.
                // We let the dedicated controller handle showing the tracking page
                // or the completion dialog based on its internal state.
                controller.navigateToTracking();
              } else {
                _showNotificationDetail(data[i], isDark);
              }
            },
            borderRadius: BorderRadius.circular(24),
            child: Container(
              decoration: _containerDecoration(isDark),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(width: 6, color: greenColor),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: widgetText(
                                      context,
                                      language == "en"
                                          ? data[i].titleEn
                                          : data[i].titleAr,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  if (data[i].imageUrl != null &&
                                      data[i].imageUrl!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: _mapImageUrl(
                                            data[i].imageUrl?.trim(),
                                          ),
                                          width: 60,
                                          height: 60,
                                          memCacheWidth: 150,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                                width: 60,
                                                height: 60,
                                                color: Colors.grey[100],
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                                Icons
                                                    .notifications_active_outlined,
                                                size: 20,
                                                color: greenColor,
                                              ),
                                        ),
                                      ),
                                    )
                                  else
                                    Icon(
                                      Icons.notifications_active_outlined,
                                      size: 16,
                                      color: greenColor,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              widgetText(
                                context,
                                language == "en"
                                    ? data[i].bodyEn
                                    : data[i].bodyAr,
                                fontSize: 13.0,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 12,
                                    color: greyColor2,
                                  ),
                                  const SizedBox(width: 4),
                                  widgetText(
                                    context,
                                    dateFormat.format(
                                      DateTime.parse(data[i].date),
                                    ),
                                    color: greyColor2,
                                    fontSize: 11.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
