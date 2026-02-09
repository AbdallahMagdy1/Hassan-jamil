import 'package:get/get.dart';
import 'package:hj_app/global/queryModel.dart';
import 'package:hj_app/view/Login/registrationPage.dart';
import 'package:hj_app/view/Login/resetPassword.dart';

import '../global/enumMethod.dart';
import '../global/globalUI.dart';
import '../global/globalUrl.dart';
import '../main.dart';
import '../model/getUserAccountTypes.dart';
import '../model/getUserAccountTypes.dart';
import '../view/screen/mainView.dart';
import 'journify_controller.dart';

class VerificationControl extends GetxController {
  final JournifyBridgeController journifyController =
      Get.find<JournifyBridgeController>();
  RxBool phoneNumberLength = false.obs;
  RxBool isProgress = false.obs;
  RxBool validation = false.obs;
  RxString textErrorLogin = ''.obs;
  RxBool canResend = false.obs;

  List<GetUserAccountTypes> listUserAccountTypes = <GetUserAccountTypes>[].obs;
  var isLogin = readGetStorage(loginKey);

  Future<void> checkVerification(context, phoneNumber) async {
    isProgress.value = true;
    var data = await myRequest(
      url: details,
      method: HttpMethod.post,
      body: {
        "object": "web_users",
        "option": "column",
        "filters": "where Phone = '+966$phoneNumber'",
        "objectsettings": {"metadata": false},
      },
    );

    if (data['ApiObjectData'].isNotEmpty) {
      isProgress.value = false;
      validation.value = false;
      writeGetStorage(loginKey, data['ApiObjectData'][0]);
      // Journify - Track Login
      journifyController.trackLogin(method: 'phone_otp');
      Get.offAll(MainView());
    }
    if (data['ApiObjectData'].isEmpty) {
      isProgress.value = false;
      validation.value = false;
      textErrorLogin.value = 'anUnexpectedErrorOccurred'.tr;
    }
  }

  Future<void> checkVerificationForForgetPassword(
    context,
    phoneNumber,
    verificationCode,
  ) async {
    isProgress.value = true;
    var data = await myRequest(
      url: details,
      method: HttpMethod.post,
      body: {
        "object": "web_users",
        "option": "column",
        "filters": "where Phone = '+966$phoneNumber'",
        "objectsettings": {"metadata": false},
      },
    );

    if (data['ApiObjectData'].isNotEmpty) {
      isProgress.value = false;
      validation.value = false;
      writeGetStorage(loginKey, data['ApiObjectData'][0]);
      validation.value = false;
      Get.to(ResetPassword(phone: phoneNumber));
    }
    if (data['ApiObjectData'].isEmpty) {
      isProgress.value = false;
      validation.value = false;
      textErrorLogin.value = 'anUnexpectedErrorOccurred'.tr;
    }
  }

  Future<void> checkVerificationCodeInRegister(
    context,
    phoneNumber,
    md5Hash,
    verificationCode,
  ) async {
    isProgress.value = false;
    validation.value = false;
    Get.to(RegistrationPage(phoneNumber: phoneNumber));
  }

  Future<void> updatePassWordAcrossEmail(context, phoneNumber, password) async {
    var passwordAfterMd5 = textToMd5(password);
    isProgress.value = true;
    var data = await myRequest(
      url: update,
      method: HttpMethod.put,
      body: {
        "Object": "web_users",
        "filters": "where Phone = '+966$phoneNumber'",
        "Values": {'Password': passwordAfterMd5, 'Token': '$fcmToken'},
        "ObjectSettings": {"MetaData": false},
      },
    );
    isProgress.value = false;

    if (data['MessageNo'] == '202100000000008') {
      Get.offAll(MainView(navigatorTo: (isLogin != null) ? 0 : 1));
    }
  }

  Future<void> getUserAccountTypes2(context, phoneNumber) async {
    await myRequest(
      url: update,
      method: HttpMethod.put,
      body: {
        "Object": "web_users",
        "filters": "where  Phone = '+966$phoneNumber' ",
        "Values": {'Token': '$fcmToken'},
        "ObjectSettings": {"MetaData": false},
      },
    );
    var data = await myRequest(
      url: func,
      method: HttpMethod.post,
      body: {"name": SiteGetUserAccountTypes},
    );
    if (data.isNotEmpty) {
      listUserAccountTypes = GetUserAccountTypes.fromJsonList(data);
      writeGetStorage(listUserAccountTypesKey, data);
    }
  }
}
