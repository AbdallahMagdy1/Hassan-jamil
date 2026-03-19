import 'package:get/get.dart';
import '../../global/globalUI.dart';

class NotificationController extends GetxController {
  var notificationCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    updateCount();
  }

  void updateCount() {
    notificationCount.value = notificationData().length;
  }
}
