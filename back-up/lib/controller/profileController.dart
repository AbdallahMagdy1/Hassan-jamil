import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hj_app/controller/verificationController.dart';
import 'package:hj_app/view/screen/globalWebView.dart';
import 'package:hj_app/view/screen/splash.dart';
import '../global/enumMethod.dart';
import '../global/globalUI.dart';
import '../global/globalUrl.dart';
import '../global/queryModel.dart';
import '../model/getUserAccountTypes.dart';
import '../view/screen/profileDetails.dart';

class ProfileController extends GetxController {
  RxInt idGender = 1.obs;
  RxBool isProgress = false.obs;
  RxBool isProgressImage = false.obs;
  RxBool isProgressChangeProfileDetails = false.obs;
  RxInt optionTap = 0.obs;
  TextEditingController controllerFistName = TextEditingController();
  TextEditingController controllerMiddleName = TextEditingController();
  TextEditingController controllerGrandFatherName = TextEditingController();
  TextEditingController controllerLastName = TextEditingController();
  TextEditingController controllerIdentityNumber = TextEditingController();
  TextEditingController controllerPhoneNumber = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();

  TextEditingController controllerCurrentPassword = TextEditingController();
  TextEditingController controllerNewPassword = TextEditingController();
  TextEditingController controllerReNewPassword = TextEditingController();

  List<GetUserAccountTypes> listUserAccountTypes = <GetUserAccountTypes>[].obs;
  List<GetUserAccountTypes> userAccountTypesTheChosen =
      <GetUserAccountTypes>[].obs;
  var imageProfileBase64;
  var imageidentityBase64;
  RxBool validateFirstName = false.obs;
  RxBool validateMiddleName = false.obs;
  RxBool validateGrandFatherName = false.obs;
  RxBool validateIDNumber = false.obs;
  RxBool validateEmail = false.obs;
  RxBool validateTheAddress = false.obs;
  RxBool validateLastName = false.obs;
  RxBool validateChangePassword = false.obs;
  RxBool validatePhoneNumber = true.obs;
  var phoneNumber;
  var isLogin = readGetStorage(loginKey);

  @override
  void onInit() {
    if (readGetStorage(listUserAccountTypesKey) != null) {
      listUserAccountTypes = GetUserAccountTypes.fromJsonList(
        readGetStorage(listUserAccountTypesKey),
      );
    } else {
      if (isLogin == null) {
        return;
      }
      VerificationControl verificationControl = VerificationControl();
      verificationControl.getUserAccountTypes2(Get.context, isLogin['Phone']);
    }

    if (isLogin == null) {
      return;
    }

    controllerFistName.text =
        (language == "ar" ? isLogin['FirstNameAr'] : isLogin['FirstNameEn']) ??
        '';
    controllerMiddleName.text =
        (language == "ar"
            ? isLogin['MiddleNameAr']
            : isLogin['MiddleNameEn']) ??
        '';
    controllerLastName.text =
        (language == "ar" ? isLogin['LastNameAr'] : isLogin['LastNameEn']) ??
        '';
    controllerIdentityNumber.text = isLogin['IdentityNumber'] ?? '';
    controllerEmail.text = isLogin['Email'] ?? '';
    controllerAddress.text = isLogin['Address'] ?? '';

    controllerFistName.text = language == "ar"
        ? (isLogin['FirstNameAr'] != null
              ? isLogin['FirstNameAr'] + ' '
              : isLogin['FirstNameEn'] ?? '')
        : (isLogin['FirstNameEn'] ?? isLogin['FirstNameAr'] ?? '');
    controllerMiddleName.text = language == "ar"
        ? (isLogin['MiddleNameAr'] != null
              ? isLogin['MiddleNameAr'] + ' '
              : isLogin['MiddleNameEn'] ?? '')
        : (isLogin['MiddleNameEn'] ?? isLogin['MiddleNameAr'] ?? '');
    controllerGrandFatherName.text = language == "ar"
        ? (isLogin['GrandFatherNameAr'] != null
              ? isLogin['GrandFatherNameAr'] + ' '
              : isLogin['GrandFatherNameEn'] ?? '')
        : (isLogin['GrandFatherNameEn'] ?? isLogin['GrandFatherNameAr'] ?? '');
    controllerLastName.text = language == "ar"
        ? (isLogin['LastNameAr'] != null
              ? isLogin['LastNameAr'] + ' '
              : isLogin['LastNameEn'] ?? '')
        : (isLogin['LastNameEn'] ?? isLogin['LastNameAr'] ?? '');
    controllerIdentityNumber.text = isLogin['IdentityNumber'] ?? '';
    controllerEmail.text = isLogin['Email'] ?? '';
    controllerAddress.text = isLogin['Address'] ?? '';
    imageProfileBase64 = isLogin['Logo'];
    imageidentityBase64 = isLogin['IdentityImage'] ?? '';
    super.onInit();
  }

  Future<void> updateProfile({
    firstName,
    middleName,
    grandFatherName,
    lastName,
    email,
    identificationNumber,
    identityImage,
    logo,
    address,
  }) async {
    isProgress.value = true;
    var data;
    if (language == "ar") {
      data = await myRequest(
        url: update,
        method: HttpMethod.put,
        body: {
          "Object": "web_users",
          "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
          "Values": {
            "FirstNameAr": '$firstName',
            "MiddleNameAr": '$middleName',
            "GrandFatherNameAr": '$grandFatherName',
            "LastNameAr": '$lastName',
            "IdentityNumber": '$identificationNumber',
            "Email": '$email',
            "logo": imageProfileBase64,
            "Address": address,
            "IdentityImage": identityImage,
          },
          "ObjectSettings": {"MetaData": false},
        },
      );
    } else {
      data = await myRequest(
        url: update,
        method: HttpMethod.put,
        body: {
          "Object": "web_users",
          "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
          "Values": {
            "FirstNameEn": '$firstName',
            "MiddleNameEn": '$middleName',
            "GrandFatherNameEN": '$grandFatherName',
            "LastNameEn": '$lastName',
            "IdentityNumber": '$identificationNumber',
            "Email": '$email',
            "logo": imageProfileBase64,
            "Address": address,
            "IdentityImage": identityImage,
          },
          "ObjectSettings": {"MetaData": false},
        },
      );
    }

    if (data['MessageNo'] == '202100000000008') {
      var data2 = await myRequest(
        url: details,
        method: HttpMethod.post,
        body: {
          "object": "web_users",
          "option": "column",
          "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
          "objectsettings": {"metadata": false},
        },
      );
      if (data2['ApiObjectData'].isNotEmpty) {
        writeGetStorage(loginKey, data2['ApiObjectData'][0]);
        isLogin = readGetStorage(loginKey);

        Future.delayed(const Duration(seconds: 2), () {
          isProgress.value = false;
          Get.to(const profileDetails());
        });
      }
    } else {
      isProgress.value = false;
    }
  }

  Future<void> updateProfilePersonally() async {
    isProgress.value = true;
    var data = await myRequest(
      url: update,
      method: HttpMethod.put,
      body: {
        "Object": "web_users",
        "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
        "Values": {
          "FirstNameAr": controllerFistName.text,
          "MiddleNameAr": controllerMiddleName.text,
          "LastNameAr": controllerLastName.text,
          "Address": controllerAddress.text,
          "IdentityNumber": controllerIdentityNumber.text,
          "CustGroupID": '${userAccountTypesValue ?? isLogin['CustGroupID']}',
        },
        "ObjectSettings": {"MetaData": false},
      },
    );
    if (data['MessageNo'] == '202100000000008') {
      var data2 = await myRequest(
        url: details,
        method: HttpMethod.post,
        body: {
          "object": "web_users",
          "option": "column",
          "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
          "objectsettings": {"metadata": false},
        },
      );
      if (data2['ApiObjectData'].isNotEmpty) {
        writeGetStorage(loginKey, data2['ApiObjectData'][0]);
        isLogin = readGetStorage(loginKey);

        Future.delayed(const Duration(seconds: 2), () {
          isProgress.value = false;
          controllerCurrentPassword.clear();
          controllerNewPassword.clear();
          controllerReNewPassword.clear();
          Get.to(const profileDetails());
          optionTap.value = 0;
        });
      }
    } else {
      isProgress.value = false;
    }
  }

  Future<void> updatePassword() async {
    isProgress.value = true;
    var passwordAfterMd5 = textToMd5(controllerNewPassword.text);
    var data = await myRequest(
      url: update,
      method: HttpMethod.put,
      body: {
        "Object": "web_users",
        "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
        "Values": {"Password": passwordAfterMd5},
        "ObjectSettings": {"MetaData": false},
      },
    );
    if (data['MessageNo'] == '202100000000008') {
      var data2 = await myRequest(
        url: details,
        method: HttpMethod.post,
        body: {
          "object": "web_users",
          "option": "column",
          "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
          "objectsettings": {"metadata": false},
        },
      );
      if (data2['ApiObjectData'].isNotEmpty) {
        writeGetStorage(loginKey, data2['ApiObjectData'][0]);
        isLogin = readGetStorage(loginKey);

        Future.delayed(const Duration(seconds: 2), () {
          isProgress.value = false;
          controllerCurrentPassword.clear();
          controllerNewPassword.clear();
          controllerReNewPassword.clear();
          Get.to(const profileDetails());
          optionTap.value = 2;
        });
      }
    } else {
      isProgress.value = false;
    }
  }

  Future<void> updatePasswordContactInformation() async {
    isProgress.value = true;
    var data = await myRequest(
      url: update,
      method: HttpMethod.put,
      body: {
        "Object": "web_users",
        "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
        "Values": {
          "Phone": phoneNumber != null ? '$phoneNumber' : '${isLogin['Phone']}',
          "Email": controllerEmail.text,
        },
        "ObjectSettings": {"MetaData": false},
      },
    );
    if (data['MessageNo'] == '202100000000008') {
      var data2 = await myRequest(
        url: details,
        method: HttpMethod.post,
        body: {
          "object": "web_users",
          "option": "column",
          "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
          "objectsettings": {"metadata": false},
        },
      );
      if (data2['ApiObjectData'].isNotEmpty) {
        writeGetStorage(loginKey, data2['ApiObjectData'][0]);
        isLogin = readGetStorage(loginKey);

        Future.delayed(const Duration(seconds: 2), () {
          isProgress.value = false;
          controllerCurrentPassword.clear();
          controllerNewPassword.clear();
          controllerReNewPassword.clear();
          Get.to(const profileDetails());
          optionTap.value = 1;
        });
      }
    } else {
      isProgress.value = false;
    }
  }

  Future<void> updateLogo() async {
    isProgressImage.value = true;
    var data = await myRequest(
      url: update,
      method: HttpMethod.put,
      body: {
        "Object": "web_users",
        "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
        "Values": {"logo": imageProfileBase64},
        "ObjectSettings": {"MetaData": false},
      },
    );
    if (data['MessageNo'] == '202100000000008') {
      var data2 = await myRequest(
        url: details,
        method: HttpMethod.post,
        body: {
          "object": "web_users",
          "option": "column",
          "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
          "objectsettings": {"metadata": false},
        },
      );
      if (data2['ApiObjectData'].isNotEmpty) {
        writeGetStorage(loginKey, data2['ApiObjectData'][0]);
        isLogin = readGetStorage(loginKey);
        isProgressImage.value = false;
      }
    } else {
      isProgressImage.value = false;
    }
  }

  Future<bool> userFound({
    required String access,
    required String accessType,
  }) async {
    isProgress.value = true;
    if (accessType == 'phonenumber') {
      access = '+966${access.trim().replaceFirst('+966', '')}';
    }
    var data = await myRequest(
      otherBaseUrl: administrationUrl,
      url: UserFound,
      method: HttpMethod.post,
      body: {"Access": access, "AccessType": accessType},
    );

    if (data != false) {
      return true;
    }

    return false;
  }

  void deleteMyAccountFunction(
    String email,
    String phone,
    String identity, {
    bool isRedirect = true,
    bool justChecking = false,
  }) async {
    if (!justChecking) {
      await Get.to(GlobalWebView('$webUrl$language/delete-account'));
    }
    bool isFound = false;
    if (email.isNotEmpty) {
      isFound = isFound || await userFound(access: email, accessType: 'email');
    }
    if (phone.isNotEmpty) {
      isFound =
          isFound || await userFound(access: phone, accessType: 'phonenumber');
    }
    if (identity.isNotEmpty) {
      isFound =
          isFound ||
          await userFound(access: identity, accessType: 'IdentityNo');
    }

    if (!isFound) {
      Fluttertoast.showToast(msg: 'accountDeleted'.tr);
      removeGetStorage(loginKey);
      if (isRedirect) {
        Get.offAll(() => Splash(version: '1.0.0'));
      }
    }
  }
}
