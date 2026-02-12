import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
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
                } else {
                  return widgetListNotification(snapshot.data!, isDark);
                }
              },
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
          key: Key(data[i].id.toString()),
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
          child: Container(
            decoration: _containerDecoration(isDark),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // The "Status" side bar
                    Container(width: 6, color: greenColor),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        );
      },
    );
  }
}
