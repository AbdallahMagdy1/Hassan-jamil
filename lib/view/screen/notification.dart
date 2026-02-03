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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: themeModeValue == 'dark' ? Colors.white : darkColor,
          ),
        ),
        title: widgetText(
          context,
          'notifications'.tr,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: Future.value(notificationData()),
            builder:
                (
                  BuildContext context,
                  AsyncSnapshot<List<NotificationClass>> snapshot,
                ) {
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.data!.isEmpty) {
                    return SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              widgetText(
                                context,
                                'thereAreNoNotifications'.tr,
                                color: greyDarkColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return widgetListNotification(snapshot.data);
                  }
                },
          ),
        ),
      ),
    );
  }

  Column widgetListNotification(data) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
    return Column(
      children: [
        for (int i = 0; i < data.length; i++)
          Slidable(
            key: Key(data[i].id.toString()),
            endActionPane: ActionPane(
              // A motion is a widget used to control how the pane animates.
              motion: const ScrollMotion(),

              // All actions are defined in the children parameter.
              children: [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  onPressed: (BuildContext context) async {
                    notificationDelete(i);
                    setState(() {});
                  },
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: Get.height * .02),
                  width: Get.width * .9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 11,
                        spreadRadius: -8,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: Get.width * .06),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              color: greenColor,
                              height: Get.height * .025,
                              width: Get.width * .015,
                            ),
                            SizedBox(width: Get.width * .025),
                            navwidgetText(
                              context,
                              language == "en"
                                  ? data[i].titleEn
                                  : data[i].titleAr,
                              fontWeight: FontWeight.bold,
                              fontSize: Get.width * .035,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: Get.width * .04,
                            right: Get.width * .04,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: Get.width * .02),
                              widgetText(
                                context,
                                language == "en"
                                    ? data[i].bodyEn
                                    : data[i].bodyAr,
                                fontSize: Get.width * .030,
                              ),
                              SizedBox(height: Get.width * .02),
                              Row(
                                children: [
                                  widgetText(
                                    context,
                                    dateFormat.format(
                                      DateTime.parse(data[i].date),
                                    ),
                                    color: greyColor2,
                                    fontSize: Get.width * .030,
                                  ),
                                ],
                              ),
                              SizedBox(height: Get.width * .02),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Row navwidgetText(
    context,
    String text, {
    color,
    fontSize,
    fontWeight,
    textDirection,
  }) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: fontSize ?? Get.width * .05,
            fontWeight: fontWeight ?? FontWeight.normal,
          ),
          textDirection: textDirection,
        ),
      ],
    );
  }
}
