import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hj_app/global/queryModel.dart';
import 'package:hj_app/main.dart';
import 'package:hj_app/view/Login/optionRegister.dart';
import 'package:hj_app/view/Login/registrationPage.dart';
import 'package:video_player/video_player.dart';
import '../global/enumMethod.dart';
import '../global/globalUI.dart';
import '../global/globalUrl.dart';
import '../model/getUserAccountTypes.dart';
import '../view/Login/loginPassWordScreen.dart';
import '../view/Login/loginUserNameScreen.dart';
import '../view/Login/verification.dart';
import '../view/Login/verificationRegistration.dart';
import '../view/screen/mainView.dart';

class LoginAndRegisterControl extends GetxController {
  RxBool validation = false.obs;
  RxBool isProgress = false.obs;
  RxBool isForgotPassword = false.obs;
  RxBool isPassWordNotCorrect = false.obs;
  RxBool isProgressCreateAccount = false.obs;
  RxBool showIdentification = false.obs;
  RxBool showCommercialRegistrationNo = false.obs;
  String? pickerImage;
  Uint8List? profileImage;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController controllerPhoneNumber = TextEditingController();
  TextEditingController identificationNumberController =
      TextEditingController();
  TextEditingController commercialRegistrationNoController =
      TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxBool checkbox = false.obs;
  RxBool checkboxIsFalse = false.obs;
  RxBool isRegistrationFieldsFull = false.obs;
  var imageIdentificationNumber;
  var imageIdentificationNumberBase64;
  var imageCommercialRegistrationNo;
  var imageCommercialRegistrationNoBase64;
  RxString textErrorLogin = ''.obs;
  List<GetUserAccountTypes> listUserAccountTypes = <GetUserAccountTypes>[].obs;
  List<GetUserAccountTypes> userAccountTypesTheChosen =
      <GetUserAccountTypes>[].obs;
  RxString privacyBaseInfo = ''.obs;

  Future<void> getPrivacyPolicy() async {
    var data = await myRequest(
      url: 'privacy/index',
      method: HttpMethod.get,
      body: {},
      otherBaseUrl: 'https://appmb.hassanjameelapp.com/$language/api/',
    );

    if (data != null && data['baseInfo'].isNotEmpty) {
      for (var element in data['baseInfo']) {
        privacyBaseInfo.value +=
            '${element['intro']}\n${element['explaination']}\n\n';
      }
    }
  }

  Future<void> sendLoginAcrossPhoneNumber(
    phoneNumber,
    isFromSplashScreen, {
    bool goback = false,
  }) async {
    isProgress.value = true;
    var data = await myRequest(
      otherBaseUrl: administrationUrl,
      url: getUserPhone,
      method: HttpMethod.post,
      body: {
        "Access": "+966${phoneNumber.trim()}",
        "AccessType": "phonenumber",
      },
    );

    if (data != false) {
      var data2 = await myRequest(
        url: func,
        method: HttpMethod.post,
        body: {
          "Name": "Site_SendSmsCodeFormAppFunction",
          "Values": {"to": "$data"},
        },
      );
      await myRequest(
        url: update,
        method: HttpMethod.put,
        body: {
          "Object": "web_users",
          "Filters": "where Phone = '+966${phoneNumber.trim()}'",
          "Values": {'ValidationKey': '${data2[0]['Code']}'},
          "ObjectSettings": {"MetaData": false},
        },
      );
      validation.value = false;
      isProgress.value = false;
      /*  if (phoneNumber.trim() == '536992950') {
        VerificationControl verificationControl = VerificationControl();
        verificationControl.checkVerification(phoneNumber.trim());
      } else {*/
      if (goback) {
        Get.back();
      }
      Get.to(
        Verification(
          data2[0]['phone'].toString().replaceAll('+', ''),
          verificationCodeFromFunction: int.parse(data2[0]['Code']),
          isFromSplashScreen: isFromSplashScreen,
        ),
      );
      // }
    }
    if (data == false) {
      isProgress.value = false;
      validation.value = false;
      // bottomSheetError(`text: 'phoneNumberNotFound'.tr);
      textErrorLogin.value = 'phoneNumberNotFound';
    }
  }

  Future<void> sendLoginAcrossIdentityNo(identityNo, isFromSplashScreen) async {
    isProgress.value = true;
    var data = await myRequest(
      otherBaseUrl: administrationUrl,
      url: getUserPhone,
      method: HttpMethod.post,
      body: {"Access": "$identityNo", "AccessType": "IdentityNo"},
    );

    if (data != false) {
      var data2 = await myRequest(
        url: func,
        method: HttpMethod.post,
        body: {
          "Name": "Site_SendSmsCodeFormAppFunction",
          "Values": {"to": "+966$data"},
        },
      );
      validation.value = false;
      isProgress.value = false;
      Get.to(
        Verification(
          data2[0]['phone'],
          verificationCodeFromFunction: int.parse(data2[0]['Code']),
          isFromSplashScreen: isFromSplashScreen,
        ),
      );
    }
    if (data == false) {
      isProgress.value = false;
      validation.value = false;
      // bottomSheetError(text: 'phoneNumberNotFound'.tr);
      textErrorLogin.value = 'theIDNumberNotFound';
    }
  }

  Future<void> forgotPassword(phoneNumber, isFromSplashScreen) async {
    isForgotPassword.value = true;
    var data = await myRequest(
      otherBaseUrl: administrationUrl,
      url: sendSms,
      method: HttpMethod.post,
      body: {
        "Access": "+966${phoneNumber.trim()}",
        "AccessType": "PhoneNumber",
      },
    );
    if (data == true) {
      var data2 = await myRequest(
        url: func,
        method: HttpMethod.post,
        body: {
          "Name": "Site_SendSmsCodeFormAppFunction",
          "Values": {"to": "+966${phoneNumber.trim()}"},
        },
      );
      await myRequest(
        url: update,
        method: HttpMethod.put,
        body: {
          "Object": "web_users",
          "Filters": "where Phone = '+966${phoneNumber.trim()}'",
          "Values": {'ValidationKey': '${data2[0]['Code']}'},
          "ObjectSettings": {"MetaData": false},
        },
      );
      isForgotPassword.value = false;

      Get.to(
        Verification(
          phoneNumber.toString(),
          verificationCodeFromFunction: int.parse(data2[0]['Code']),
          isFromSplashScreen: isFromSplashScreen,
          isForgetPassWord: true,
          acrossEmail: false,
        ),
      );
    }
    if (data == false) {
      isForgotPassword.value = false;
      validation.value = false;
      textErrorLogin.value = 'phoneNumberNotFound';
      // bottomSheetError(text: 'phoneNumberNotFound'.tr);
    }
  }

  Future<void> checkEmailIsFound(email, isFromSplashScreen) async {
    isProgress.value = true;
    var data = await myRequest(
      url: details,
      method: HttpMethod.post,
      body: {
        "object": "web_users",
        "option": "column",
        "filters": "where Email = '$email'",
        "objectsettings": {"metadata": false},
      },
    );

    if (data['ApiObjectData'].isNotEmpty) {
      isProgress.value = false;
      validation.value = false;
      Get.to(
        LoginPassWordScreen(
          isFromSplashScreen: isFromSplashScreen,
          email: email,
          phone: data['ApiObjectData'][0]['Phone'],
          acrossEmail: true,
        ),
      );
    }
    if (data['ApiObjectData'].isEmpty) {
      isProgress.value = false;
      validation.value = false;
      // bottomSheetError(text: 'pleaseEnterAValidEmail'.tr);
      textErrorLogin.value = 'pleaseEnterValidEmail';
    }
  }

  Future<void> checkIdentificationNumberIsFound(
    identificationNumber,
    isFromSplashScreen,
  ) async {
    isProgress.value = true;
    var data = await myRequest(
      url: details,
      method: HttpMethod.post,
      body: {
        "object": "web_users",
        "option": "column",
        "filters": "where IdentityNumber = '$identificationNumber'",
        "objectsettings": {"metadata": false},
      },
    );

    if (data['ApiObjectData'].isNotEmpty) {
      isProgress.value = false;
      validation.value = false;
      Get.to(
        LoginPassWordScreen(
          isFromSplashScreen: isFromSplashScreen,
          identificationNumber: identificationNumber,
          phone: data['ApiObjectData'][0]['Phone'],
          acrossIdentificationNumber: true,
        ),
      );
    }
    if (data['ApiObjectData'].isEmpty) {
      isProgress.value = false;
      validation.value = false;
      // bottomSheetError(text: 'PleaseEnterAValidIDNumber'.tr);
      textErrorLogin.value = 'PleaseEnterAValidIDNumber';
    }
  }

  Future<void> checkEmailAndPassWordIsCorrect(
    email,
    password,
    isFromSplashScreen,
  ) async {
    isProgress.value = true;
    var passwordAfterMd5 = textToMd5(password);

    var data = await myRequest(
      url: details,
      method: HttpMethod.post,
      body: {
        "object": "web_users",
        "option": "column",
        "filters": "where Email = '$email'and Password ='$passwordAfterMd5'",
        "objectsettings": {"metadata": false},
      },
    );

    if (data['ApiObjectData'].isNotEmpty) {
      writeGetStorage(loginKey, data['ApiObjectData'][0]);
      isProgress.value = false;
      validation.value = false;
      getUserAccountTypes2();
      await myRequest(
        url: update,
        method: HttpMethod.put,
        body: {
          "Object": "web_users",
          "filters": "where  Email = '$email' ",
          "Values": {'Token': '$fcmToken'},
          "ObjectSettings": {"MetaData": false},
        },
      );
      Get.offAll(MainView());
    }
    if (data['ApiObjectData'].isEmpty) {
      isProgress.value = false;
      validation.value = false;
      isPassWordNotCorrect.value = true;
      // bottomSheetError(text: 'PleaseEnterAValidPassword'.tr);
    }
  }

  Future<void> checkIdentificationNumberAndPassWordIsCorrect(
    identificationNumber,
    password,
    isFromSplashScreen,
  ) async {
    var passwordAfterMd5 = textToMd5(password);
    isProgress.value = true;
    var data = await myRequest(
      url: details,
      method: HttpMethod.post,
      body: {
        "object": "web_users",
        "option": "column",
        "filters":
            "where IdentityNumber = '$identificationNumber'and Password ='$passwordAfterMd5'",
        "objectsettings": {"metadata": false},
      },
    );

    if (data['ApiObjectData'].isNotEmpty) {
      writeGetStorage(loginKey, data['ApiObjectData'][0]);
      isProgress.value = false;
      validation.value = false;
      await myRequest(
        url: update,
        method: HttpMethod.put,
        body: {
          "Object": "web_users",
          "filters": "where  IdentityNumber = '$identificationNumber' ",
          "Values": {'Token': '$fcmToken'},
          "ObjectSettings": {"MetaData": false},
        },
      );
      getUserAccountTypes2();
      Get.offAll(MainView());
    }
    if (data['ApiObjectData'].isEmpty) {
      isProgress.value = false;
      validation.value = false;
      isPassWordNotCorrect.value = true;

      // bottomSheetError(text: 'PleaseEnterAValidPassword'.tr);
    }
  }

  Future<void> RegisterAcrossPhoneNumber(
    phoneNumber,
    isFromSplashScreen,
  ) async {
    isProgress.value = true;
    var data = await myRequest(
      otherBaseUrl: administrationUrl,
      url: sendFreeSms,
      method: HttpMethod.post,
      returnHeader: true,
      body: {"phonenumber": "+966$phoneNumber"},
    );

    if (data[0] == true) {
      var data2 = await myRequest(
        url: func,
        method: HttpMethod.post,
        body: {
          "Name": "Site_SendSmsCodeFormAppFunction",
          "Values": {"to": "+966${phoneNumber.trim()}"},
        },
      );
      isProgress.value = false;
      validation.value = false;
      var subStringKey = data[1].substring(10);

      var varSemicolon = subStringKey.indexOf(';');

      var md5Hash = subStringKey.toString().substring(0, varSemicolon);

      Get.to(
        VerificationRegistration(
          phoneNumber,
          md5Hash,
          verificationCodeFromFunction: int.parse(data2[0]['Code']),
          isFromSplashScreen: isFromSplashScreen,
        ),
      );
    }
    if (data[0] == false) {
      isProgress.value = false;
      isProgress.value = false;
      validation.value = false;
      /* bottomSheetError(
          text: language == 'en'
              ? data[1]['EnDescription']
              : data[1]['ArDescription']);*/
      textErrorLogin.value = (language == 'en'
          ? data[1]['EnDescription']
          : data[1]['ArDescription']);
    }
  }

  Future<void> RegisterAcrossEmail(email) async {
    isProgress.value = true;
    var data = await myRequest(
      method: HttpMethod.post,
      url: details,
      body: {
        "object": "web_users",
        "option": "column",
        "Fields": "Email",
        "filters": "where Email = '$email'",
        "objectsettings": {"metadata": false},
      },
    );

    if (data['ApiObjectData'].isEmpty) {
      isProgress.value = false;
      Get.to(RegistrationPage(emial: email, password: passwordController.text));
    } else if (data['ApiObjectData'].isNotEmpty) {
      isProgress.value = false;
      validation.value = false;
      // bottomSheetError(text: 'emailAlreadyExists'.tr);
      textErrorLogin.value = 'emailAlreadyExists'.tr;
    }
  }

  Future<void> RegisterAcrossIdentificationNumber(identificationNumber) async {
    isProgress.value = true;
    var data = await myRequest(
      method: HttpMethod.post,
      url: details,
      body: {
        "object": "web_users",
        "option": "column",
        "Fields": "Email",
        "filters": "where IdentityNumber = '$identificationNumber'",
        "objectsettings": {"metadata": false},
      },
    );

    if (data['ApiObjectData'].isEmpty) {
      isProgress.value = false;
      Get.to(
        RegistrationPage(
          IdentityNumber: identificationNumber,
          password: passwordController.text,
        ),
      );
    } else if (data['ApiObjectData'].isNotEmpty) {
      isProgress.value = false;
      validation.value = false;
      // bottomSheetError(text: 'iDNumberAlreadyExists'.tr);
      textErrorLogin.value = 'iDNumberAlreadyExists'.tr;
    }
  }

  Future<void> getUserAccountTypes(
    hintText,
    bool isFromSplashScree, {
    VideoPlayerController? vc,
  }) async {
    isProgressCreateAccount.value = true;
    var data = await myRequest(
      url: func,
      method: HttpMethod.post,
      body: {"name": SiteGetUserAccountTypes},
    );

    if (data is bool && data == false) {
      isProgressCreateAccount.value = false;
      validation.value = false;
      textErrorLogin.value = 'somethingWentWrong'.tr;
      return;
    }

    if (data.isNotEmpty) {
      isProgressCreateAccount.value = false;
      validation.value = false;
      listUserAccountTypes = GetUserAccountTypes.fromJsonList(data);
      if (vc != null) {
        vc.pause();
      }
      await Get.to(optionRegister());
      if (vc != null) {
        vc.play();
      }
      return;
    }

    isProgressCreateAccount.value = false;
    validation.value = false;
  }

  Future<void> getUserAccountTypes2() async {
    var data = await myRequest(
      url: func,
      method: HttpMethod.post,
      body: {"name": SiteGetUserAccountTypes},
    );
    if (data is bool && data == false) {
      isProgressCreateAccount.value = false;
      validation.value = false;
      return;
    }
    if (data.isNotEmpty) {
      listUserAccountTypes = GetUserAccountTypes.fromJsonList(data);
      writeGetStorage(listUserAccountTypesKey, data);
    }
  }

  void getUserAccountTypeDropDownOnChange(id) {
    List<GetUserAccountTypes> data = listUserAccountTypes
        .where((element) => element.id == id)
        .toList();
    if (data[0].needIdentity) {
      showIdentification.value = true;
      showCommercialRegistrationNo.value = false;
    }
    if (!data[0].needIdentity) {
      showIdentification.value = false;
      showCommercialRegistrationNo.value = true;
    }
  }

  Future<void> sendRegistrationPage({
    firstName,
    middleName,
    lastName,
    password,
    identificationNumber,
    commercialRegistrationNo,
    phone,
    email,
    IdentityImage,
    TradeNoImage,
  }) async {
    var passwordAfterMd5 = textToMd5(password);
    isProgress.value = true;
    var data = await myRequest(
      otherBaseUrl: administrationUrl,
      url: signup,
      returnHeader: true,
      method: HttpMethod.post,
      body: {
        "ArFirstName": language == "ar" ? firstName : null,
        "ArMiddlename": language == "ar" ? middleName : null,
        "ArLastname": language == "ar" ? lastName : null,
        "EnFirstName": language == "en" ? firstName : null,
        "EnMiddlename": language == "en" ? middleName : null,
        "EnLastname": language == "en" ? lastName : null,
        "Phone": "+966${phone.toString().trim()}",
        "Password": passwordAfterMd5,
        "Email": email,
        "Identity": identificationNumber.isNotEmpty
            ? identificationNumber
            : null,
        "IdentityImage": IdentityImage,
        "TradeNo": commercialRegistrationNo.isNotEmpty
            ? commercialRegistrationNo
            : null,
        "TradeNoImage": TradeNoImage,
        "CustGroupID": userAccountTypesTheChosen[0].id,
        "IsClient": userAccountTypesTheChosen[0].needIdentity,
      },
    );

    if (data[0] == true) {
      isProgress.value = false;
      isProgress.value = false;
      validation.value = false;
      await myRequest(
        url: update,
        method: HttpMethod.put,
        body: {
          "Object": "web_users",
          "filters": "where  IdentityNumber = '$identificationNumber' ",
          "Values": {'Token': '$fcmToken'},
          "ObjectSettings": {"MetaData": false},
        },
      );
      Get.offAll(
        MainView(lastPageNavigator: LoginUserName(isFromSplashScreen: false)),
      );
    } else {
      isProgress.value = false;
      isProgress.value = false;
      validation.value = false;
      textErrorLogin.value = (language == 'en'
          ? data[1]['EnDescription']
          : data[1]['ArDescription']);
    }
  }

  void checkRegistrationFieldsFull({
    String firstName = '',
    String middleName = '',
    String lastName = '',
    String password = '',
    String confirmPassword = '',
    String identificationNumber = '',
    String commercialRegistrationNo = '',
  }) {
    if (firstName.isNotEmpty &&
        middleName.isNotEmpty &&
        lastName.isNotEmpty &&
        (identificationNumber.isNotEmpty ||
            commercialRegistrationNo.isNotEmpty)) {
      isRegistrationFieldsFull.value = true;
    } else {
      isRegistrationFieldsFull.value = false;
    }
  }
  @override
  void onClose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    controllerPhoneNumber.dispose();
    identificationNumberController.dispose();
    commercialRegistrationNoController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
