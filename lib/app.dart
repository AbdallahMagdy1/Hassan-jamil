import 'dart:io';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hj_app/controller/locale_controller.dart';
import 'package:hj_app/controller/maintenance_tracking_controller.dart';
import 'package:hj_app/controller/themeController.dart';
import 'package:hj_app/initialBinding.dart';
import 'package:hj_app/main.dart';
import 'package:hj_app/model/notification.dart';
import 'package:hj_app/translation.dart';
import 'package:hj_app/view/screen/globalWebView.dart';
import 'package:hj_app/view/screen/mainView.dart';
import 'package:hj_app/view/screen/maintenance_tracking_screen.dart';
import 'package:hj_app/view/screen/splash.dart';
import 'package:hj_app/view/screen/notification.dart';
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

    void handleNotificationClick(
      RemoteMessage message, {
      bool wait = false,
    }) async {
      if (wait) {
        await Future.delayed(const Duration(milliseconds: 1500));
      }

      // 1. Check for explicit 'route' metadata first
      String? route = message.data['route'] ?? message.data['Route'];
      if (route != null && route.isNotEmpty) {
        debugPrint("🚀 Navigating to route: $route");
        if (route.startsWith('http')) {
          Get.to(() => GlobalWebView(route));
          return;
        }

        // Handle internal app sections if mapped
        String lowerRoute = route.toLowerCase();
        if (lowerRoute == 'store') {
          Get.offAll(() => MainView(navigatorTo: isLogin == null ? 0 : 1));
          return;
        } else if (lowerRoute == 'cart') {
          Get.offAll(() => const MainView(navigatorTo: 2));
          return;
        } else if (lowerRoute == 'favorite' && isLogin != null) {
          Get.offAll(() => const MainView(navigatorTo: 3));
          return;
        } else if (lowerRoute == 'search') {
          Get.offAll(() => MainView(navigatorTo: isLogin == null ? 1 : 4));
          return;
        } else if (lowerRoute == 'notification' ||
            lowerRoute == 'notifications') {
          Get.to(() => const NotificationPage());
          return;
        }
      }

      // Check for 'screen' metadata (maintenance_tracking pattern)
      String? screen = message.data['screen'] ?? message.data['Screen'];
      if (screen != null && screen.isNotEmpty) {
        if (screen.toLowerCase() == 'maintenance_tracking') {
          final bool isClosed = message.data['isClosed'] == '1';
          final bool isCanceled = message.data['isCanceled'] == '1';

          // Always navigate to tracking screen
          Get.to(() => const MaintenanceTrackingScreen());

          if ((isClosed || isCanceled) &&
              Get.isRegistered<MaintenanceTrackingController>()) {
            // Delay slightly so the screen has a chance to mount
            await Future.delayed(const Duration(milliseconds: 500));
            Get.find<MaintenanceTrackingController>()
                .showCompletionDialogIfNeeded(canceled: isCanceled);
          }
          return;
        }
      }

      // 2. Fallback to offer-based logic
      String? offerType =
          message.data['offerType'] ?? message.data['OfferType'];
      String? slug =
          message.data['slugEn'] ??
          message.data['slugAr'] ??
          message.data['SlugEn'] ??
          message.data['SlugAr'];

      if (offerType != null && offerType != "0" && slug != null) {
        String lang = language;
        int type = int.tryParse(offerType) ?? 0;
        String? path;

        if (type == 2) {
          path = "/$lang/offerCarOverview/$slug";
        } else if (type == 4) {
          path = "/$lang/offerparts/$slug";
        } else if (type == 3) {
          path = "/$lang/offerMaintenanceServices/$slug";
        }

        if (path != null) {
          Get.to(() => GlobalWebView("https://app.hassanjameelapp.com$path"));
          return;
        }
      }

      // Default fallback: Go to Notification History
      Get.to(() => const NotificationPage());
    }

    // Initialize local notifications for foreground clicks
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    widget.flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          try {
            Map<String, dynamic> data = jsonDecode(response.payload!);
            handleNotificationClick(RemoteMessage(data: data));
          } catch (e) {
            debugPrint("Error handling local notification click: $e");
          }
        }
      },
    );

    // 1. Initial Message (Terminated State)
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        handleNotificationClick(message, wait: true);
      }
    });

    // 2. ForeGround Message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      final String? screen = message.data['screen'] ?? message.data['Screen'];
      final bool isMaintenanceMsg =
          screen != null && screen.toLowerCase() == 'maintenance_tracking';

      // Only store to notification history for non-maintenance messages.
      // Maintenance tracking messages are transient operational updates — storing
      // them would show duplicate entries in the Notification page.
      if (!isMaintenanceMsg) {
        String? img =
            message.data['imageUrl'] ??
            message.data['image'] ??
            message.data['ImageUrl'] ??
            message.data['Image'] ??
            (Platform.isAndroid
                ? message.notification?.android?.imageUrl
                : message.notification?.apple?.imageUrl);

        notificationAdd(
          NotificationClass(
            id: null,
            titleEn:
                message.data['titleEn'] ??
                message.data['TitleEn'] ??
                message.notification?.title ??
                '',
            titleAr:
                message.data['titleAr'] ??
                message.data['TitleAr'] ??
                message.notification?.title ??
                '',
            bodyEn:
                message.data['bodyEn'] ??
                message.data['BodyEn'] ??
                message.notification?.body ??
                '',
            bodyAr:
                message.data['bodyAr'] ??
                message.data['BodyAr'] ??
                message.notification?.body ??
                '',
            route: message.data['route'] ?? message.data['Route'] ?? '',
            imageUrl: img,
            offerType: message.data['offerType'] ?? message.data['OfferType'],
            slugAr: message.data['slugAr'] ?? message.data['SlugAr'],
            slugEn: message.data['slugEn'] ?? message.data['SlugEn'],
            date: DateTime.now().toString(),
          ),
        );
      }

      if (notification != null && android != null) {
        widget.flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          language == 'ar'
              ? (message.data['titleAr'] ?? notification.title)
              : (message.data['titleEn'] ?? notification.title),
          language == 'ar'
              ? (message.data['bodyAr'] ?? notification.body)
              : (message.data['bodyEn'] ?? notification.body),
          NotificationDetails(
            android: AndroidNotificationDetails(
              widget.channel.id,
              widget.channel.name,
              channelDescription: widget.channel.description,
              color: Get.isDarkMode
                  ? Colors.black45
                  : Colors.white, // Matches the app's primary green theme
              playSound: true,
              icon: '@mipmap/launcher_icon',
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });

    // 3. Message Opened App (Background State)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationClick(message);
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
