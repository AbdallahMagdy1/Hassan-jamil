import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hj_app/controller/locale_controller.dart';
import 'package:hj_app/controller/themeController.dart';
import 'package:hj_app/initialBinding.dart';
import 'package:hj_app/main.dart';
import 'package:hj_app/model/notification.dart';
import 'package:hj_app/translation.dart';
import 'package:hj_app/view/screen/mainView.dart';
import 'package:hj_app/view/screen/splash.dart';
import 'global/globalUI.dart';

class MyApp extends StatefulWidget {
  final String version;
  final AndroidNotificationChannel channel;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  const MyApp({
    super.key,
    required this.channel,
    required this.flutterLocalNotificationsPlugin,
    required this.version,
  });

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isShowLoginPageAfterInstall;
  var isLogin = readGetStorage(loginKey);

  @override
  void initState() {
    isShowLoginPageAfterInstall = readGetStorage(isShowLoginPage);

    getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        notificationAdd(
          NotificationClass(
            id: null,
            titleEn: message.data['titleEn'] ?? '',
            titleAr: message.data['titleAr'] ?? '',
            bodyEn: message.data['bodyEn'] ?? '',
            bodyAr: message.data['bodyAr'] ?? '',
            route: message.data['route'] ?? '',
            date: DateTime.now().toString(),
          ),
        );
        widget.flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          language == 'ar' ? message.data['titleAr'] : message.data['titleEn'],
          (language == 'ar' ? message.data['bodyAr'] : message.data['bodyEn']),
          NotificationDetails(
            android: AndroidNotificationDetails(
              widget.channel.id,
              widget.channel.name,
              channelDescription: widget.channel.description,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/launcher_icon',
            ),
          ),
        );
      }
    });

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final localeController = Get.find<LocaleController>();

    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hassan Jameel Motors',
        theme: themeController.lightTheme,
        darkTheme: themeController.darkTheme,
        themeMode: ThemeMode.system,
        translations: Translation(),
        locale: localeController.locale.value,
        fallbackLocale: const Locale('en'),
        initialBinding: InitialBinding(),
        home: isLogin != null ? MainView() : Splash(version: widget.version),
      );
    });
  }
}
