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

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  await GetStorage.init();

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

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );

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
}
