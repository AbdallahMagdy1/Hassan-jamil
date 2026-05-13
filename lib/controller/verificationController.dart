import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hj_app/global/queryModel.dart';
import 'package:hj_app/view/Login/registrationPage.dart';
import 'package:hj_app/view/Login/resetPassword.dart';

import '../global/enumMethod.dart';
import '../global/globalUI.dart';
import '../global/globalUrl.dart';
import '../main.dart';
import '../model/getUserAccountTypes.dart';
import '../view/screen/mainView.dart';

class VerificationControl extends GetxController {
  RxBool phoneNumberLength = false.obs;
  RxBool isProgress = false.obs;
  RxBool validation = false.obs;
  RxString textErrorLogin = ''.obs;
  RxBool canResend = false.obs;

  List<GetUserAccountTypes> listUserAccountTypes = <GetUserAccountTypes>[].obs;
  var isLogin = readGetStorage(loginKey);

  Future<void> checkVerification(context, phoneNumber) async {
    isProgress.value = true;
    try {
      var data = await myRequest(
        url: 'api/Pages/Detailsweb_users',
        method: HttpMethod.post,
        body: {
          "Option": "column",
          "Filters": "where Phone = '+966$phoneNumber'",
          "ObjectSettings": {"MetaData": false},
        },
      );
      final rows = (data is Map) ? data['ApiObjectData'] : null;
      if (rows is List && rows.isNotEmpty) {
        validation.value = false;
        writeGetStorage(loginKey, rows[0]);
        Get.offAll(MainView());
      } else {
        validation.value = false;
        textErrorLogin.value = 'anUnexpectedErrorOccurred'.tr;
      }
    } catch (e, st) {
      debugPrint('❌ checkVerification error: $e\n$st');
      validation.value = false;
      textErrorLogin.value = 'anUnexpectedErrorOccurred'.tr;
    } finally {
      isProgress.value = false;
    }
  }

  Future<void> checkVerificationForForgetPassword(
    context,
    phoneNumber,
    verificationCode,
  ) async {
    isProgress.value = true;
    try {
      var data = await myRequest(
        url: 'api/Pages/Detailsweb_users',
        method: HttpMethod.post,
        body: {
          "Option": "column",
          "Filters": "where Phone = '+966$phoneNumber'",
          "ObjectSettings": {"MetaData": false},
        },
      );
      final rows = (data is Map) ? data['ApiObjectData'] : null;
      if (rows is List && rows.isNotEmpty) {
        validation.value = false;
        writeGetStorage(loginKey, rows[0]);
        Get.to(ResetPassword(phone: phoneNumber));
      } else {
        validation.value = false;
        textErrorLogin.value = 'anUnexpectedErrorOccurred'.tr;
      }
    } catch (e, st) {
      debugPrint('❌ checkVerificationForForgetPassword error: $e\n$st');
      validation.value = false;
      textErrorLogin.value = 'anUnexpectedErrorOccurred'.tr;
    } finally {
      isProgress.value = false;
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
    isProgress.value = true;
    try {
      var passwordAfterMd5 = textToMd5(password);
      var data = await myRequest(
        url: 'api/Pages/Updateweb_users',
        method: HttpMethod.post,
        body: {
          "Filters": "where Phone = '+966$phoneNumber'",
          "Values": {'Password': passwordAfterMd5, 'Token': '$fcmToken'},
        },
      );

      if (data is Map &&
          (data['MessageNo'] == '202100000000008' ||
              data['MessageNo'] == 202100000000008)) {
        Get.offAll(MainView(navigatorTo: (isLogin != null) ? 0 : 1));
      } else {
        textErrorLogin.value = 'anUnexpectedErrorOccurred'.tr;
      }
    } catch (e, st) {
      debugPrint('❌ updatePassWordAcrossEmail error: $e\n$st');
      textErrorLogin.value = 'anUnexpectedErrorOccurred'.tr;
    } finally {
      isProgress.value = false;
    }
  }

  Future<void> getUserAccountTypes2(context, phoneNumber) async {
    try {
      await myRequest(
        url: 'api/Pages/Updateweb_users',
        method: HttpMethod.post,
        body: {
          "Filters": "where  Phone = '+966$phoneNumber' ",
          "Values": {'Token': '$fcmToken'},
        },
      );
      var data = await myRequest(
        url: 'api/Pages/$SiteGetUserAccountTypes',
        method: HttpMethod.post,
        body: {},
      );
      if (data is List && data.isNotEmpty) {
        listUserAccountTypes = GetUserAccountTypes.fromJsonList(data);
        writeGetStorage(listUserAccountTypesKey, data);
      }
    } catch (e, st) {
      debugPrint('❌ getUserAccountTypes2 error: $e\n$st');
    }
  }
}
