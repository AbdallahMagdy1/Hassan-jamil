import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hj_app/controller/journify_controller.dart';
import 'package:hj_app/controller/locale_controller.dart';
import 'package:hj_app/controller/loginAndRegisterControl.dart';
import 'package:hj_app/controller/registerControl.dart';
import 'package:hj_app/controller/profileController.dart';
import 'package:hj_app/controller/notification_controller.dart';
import 'package:hj_app/controller/maintenance_tracking_controller.dart';
import 'package:hj_app/controller/verificationController.dart';
import 'global/globalUI.dart';

class InitialBinding extends Bindings {
  var isLogin = readGetStorage(loginKey);
  ProfileController profileController = Get.put(ProfileController());
  NotificationController notificationController = Get.put(
    NotificationController(),
  );

  @override
  void dependencies() {
    // Schedule language & theme initialization after first frame to avoid
    // platform-specific race conditions (observed on some iOS devices).

    Get.put<JournifyBridgeController>(
      JournifyBridgeController(
        writeKey: "wk_38WNzjTQOQoj3KUruAm4QmOB7n1",
        allowedHosts: {"app.hassanjameelapp.com"},
      )..addPlugins(),
      permanent: true,
    );

    // ── Login / Registration controllers ─────────────────────────────────────
    // Registered as permanent singletons so Get.find() works from any page.
    // Using permanent: true means they are never destroyed on route changes,
    // which is what we want — the _isBusy guard inside each controller
    // prevents request stacking safely.
    Get.put<LoginAndRegisterControl>(
      LoginAndRegisterControl(),
      permanent: true,
    );
    Get.put<RegisterControl>(RegisterControl(), permanent: true);
    Get.put<VerificationControl>(VerificationControl(), permanent: true);

    // Permanent singleton: must survive route pops so gRPC stream and auth
    // listeners stay alive for the entire app session.
    Get.put<MaintenanceTrackingController>(
      MaintenanceTrackingController(),
      permanent: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // Ensure controllers are registered before calling functions that
        // depend on them.
        if (Get.isRegistered<LocaleController>()) {
          getLanguage();
        }

        // Theme relies on Get.mediaQuery; guard with a try/catch to avoid
        // crashing if the platform returns unexpected values on iOS.
        await getThemeStatus();

        //todo: delete account function
        //check if account is deleted
        /*if (isLogin != null) {
          debugPrint('Check if account is deleted => ${isLogin.toString()}');
          profileController.deleteMyAccountFunction(
            isLogin['Email'],
            isLogin['Phone'],
            isLogin['IdentityNumber'],
            isRedirect: true,
            justChecking: true,
          );
        }*/
      } catch (e, st) {
        // If something goes wrong, keep the app alive and log the error.
        debugPrint('InitialBinding init error: $e\n$st');
      }
    });
  }
}
