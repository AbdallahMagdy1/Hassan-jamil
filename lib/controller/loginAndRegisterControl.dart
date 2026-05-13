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
    try {
      var data = await myRequest(
        otherBaseUrl: administrationUrl,
        url: getUserPhone,
        method: HttpMethod.post,
        body: {
          "Access": "+966${phoneNumber.trim()}",
          "AccessType": "phonenumber",
        },
      );

      if (data == false) {
        validation.value = false;
        textErrorLogin.value = lastRequestNetworkFailed
            ? 'CHECK_INTERNET'.tr
            : 'phoneNumberNotFound';
        return;
      }

      var data2 = await myRequest(
        url: 'api/Pages/Site_SendSmsCodeFormAppFunction',
        method: HttpMethod.post,
        body: {"to": "$data"},
      );
      if (data2 is! List || data2.isEmpty || data2[0]?['Code'] == null) {
        validation.value = false;
        textErrorLogin.value = 'somethingWentWrong'.tr;
        debugPrint(
          '❌ Site_SendSmsCodeFormAppFunction returned unexpected: $data2',
        );
        return;
      }

      await myRequest(
        url: 'api/Pages/Updateweb_users',
        method: HttpMethod.post,
        body: {
          "Filters": "where Phone = '+966${phoneNumber.trim()}'",
          "Values": {'ValidationKey': '${data2[0]['Code']}'},
        },
      );
      validation.value = false;
      if (goback) {
        Get.back();
      }
      Get.to(
        Verification(
          data2[0]['phone'].toString().replaceAll('+', ''),
          verificationCodeFromFunction: int.parse(data2[0]['Code'].toString()),
          isFromSplashScreen: isFromSplashScreen,
        ),
      );
    } catch (e, st) {
      debugPrint('❌ sendLoginAcrossPhoneNumber error: $e\n$st');
      validation.value = false;
      textErrorLogin.value = 'somethingWentWrong'.tr;
    } finally {
      isProgress.value = false;
    }
  }

  Future<void> sendLoginAcrossIdentityNo(identityNo, isFromSplashScreen) async {
    isProgress.value = true;
    try {
      var data = await myRequest(
        otherBaseUrl: administrationUrl,
        url: getUserPhone,
        method: HttpMethod.post,
        body: {"Access": "$identityNo", "AccessType": "IdentityNo"},
      );

      if (data == false) {
        validation.value = false;
        textErrorLogin.value = lastRequestNetworkFailed
            ? 'CHECK_INTERNET'.tr
            : 'theIDNumberNotFound';
        return;
      }

      var data2 = await myRequest(
        url: 'api/Pages/Site_SendSmsCodeFormAppFunction',
        method: HttpMethod.post,
        body: {"to": "+966$data"},
      );
      if (data2 is! List || data2.isEmpty || data2[0]?['Code'] == null) {
        validation.value = false;
        textErrorLogin.value = 'somethingWentWrong'.tr;
        debugPrint(
          '❌ Site_SendSmsCodeFormAppFunction returned unexpected: $data2',
        );
        return;
      }
      validation.value = false;
      Get.to(
        Verification(
          data2[0]['phone'],
          verificationCodeFromFunction: int.parse(data2[0]['Code'].toString()),
          isFromSplashScreen: isFromSplashScreen,
        ),
      );
    } catch (e, st) {
      debugPrint('❌ sendLoginAcrossIdentityNo error: $e\n$st');
      validation.value = false;
      textErrorLogin.value = 'somethingWentWrong'.tr;
    } finally {
      isProgress.value = false;
    }
  }

  Future<void> forgotPassword(phoneNumber, isFromSplashScreen) async {
    isForgotPassword.value = true;
    try {
      var data = await myRequest(
        otherBaseUrl: administrationUrl,
        url: sendSms,
        method: HttpMethod.post,
        body: {
          "Access": "+966${phoneNumber.trim()}",
          "AccessType": "PhoneNumber",
        },
      );
      if (data != true) {
        validation.value = false;
        textErrorLogin.value = lastRequestNetworkFailed
            ? 'CHECK_INTERNET'.tr
            : 'phoneNumberNotFound';
        return;
      }
      var data2 = await myRequest(
        url: 'api/Pages/Site_SendSmsCodeFormAppFunction',
        method: HttpMethod.post,
        body: {"to": "+966${phoneNumber.trim()}"},
      );
      if (data2 is! List || data2.isEmpty || data2[0]?['Code'] == null) {
        validation.value = false;
        textErrorLogin.value = 'somethingWentWrong'.tr;
        debugPrint(
          '❌ Site_SendSmsCodeFormAppFunction returned unexpected: $data2',
        );
        return;
      }
      await myRequest(
        url: 'api/Pages/Updateweb_users',
        method: HttpMethod.post,
        body: {
          "Filters": "where Phone = '+966${phoneNumber.trim()}'",
          "Values": {'ValidationKey': '${data2[0]['Code']}'},
        },
      );

      Get.to(
        Verification(
          phoneNumber.toString(),
          verificationCodeFromFunction: int.parse(data2[0]['Code'].toString()),
          isFromSplashScreen: isFromSplashScreen,
          isForgetPassWord: true,
          acrossEmail: false,
        ),
      );
    } catch (e, st) {
      debugPrint('❌ forgotPassword error: $e\n$st');
      validation.value = false;
      textErrorLogin.value = 'somethingWentWrong'.tr;
    } finally {
      isForgotPassword.value = false;
    }
  }

  Future<void> checkEmailIsFound(email, isFromSplashScreen) async {
    isProgress.value = true;
    try {
      var data = await myRequest(
        url: 'api/Pages/Detailsweb_users',
        method: HttpMethod.post,
        body: {
          "Option": "column",
          "Filters": "where Email = '$email'",
          "ObjectSettings": {"MetaData": false},
        },
      );
      final rows = (data is Map) ? data['ApiObjectData'] : null;
      if (rows is List && rows.isNotEmpty) {
        validation.value = false;
        Get.to(
          LoginPassWordScreen(
            isFromSplashScreen: isFromSplashScreen,
            email: email,
            phone: rows[0]['Phone'],
            acrossEmail: true,
          ),
        );
      } else {
        validation.value = false;
        textErrorLogin.value = 'pleaseEnterValidEmail';
      }
    } catch (e, st) {
      debugPrint('❌ checkEmailIsFound error: $e\n$st');
      validation.value = false;
      textErrorLogin.value = 'somethingWentWrong'.tr;
    } finally {
      isProgress.value = false;
    }
  }

  Future<void> checkIdentificationNumberIsFound(
    identificationNumber,
    isFromSplashScreen,
  ) async {
    isProgress.value = true;
    try {
      var data = await myRequest(
        url: 'api/Pages/Detailsweb_users',
        method: HttpMethod.post,
        body: {
          "Option": "column",
          "Filters": "where IdentityNumber = '$identificationNumber'",
          "ObjectSettings": {"MetaData": false},
        },
      );
      final rows = (data is Map) ? data['ApiObjectData'] : null;
      if (rows is List && rows.isNotEmpty) {
        validation.value = false;
        Get.to(
          LoginPassWordScreen(
            isFromSplashScreen: isFromSplashScreen,
            identificationNumber: identificationNumber,
            phone: rows[0]['Phone'],
            acrossIdentificationNumber: true,
          ),
        );
      } else {
        validation.value = false;
        textErrorLogin.value = 'PleaseEnterAValidIDNumber';
      }
    } catch (e, st) {
      debugPrint('❌ checkIdentificationNumberIsFound error: $e\n$st');
      validation.value = false;
      textErrorLogin.value = 'somethingWentWrong'.tr;
    } finally {
      isProgress.value = false;
    }
  }

  Future<void> checkEmailAndPassWordIsCorrect(
    email,
    password,
    isFromSplashScreen,
  ) async {
    isProgress.value = true;
    try {
      var passwordAfterMd5 = textToMd5(password);

      var data = await myRequest(
        url: 'api/Pages/Detailsweb_users',
        method: HttpMethod.post,
        body: {
          "Option": "column",
          "Filters": "where Email = '$email'and Password ='$passwordAfterMd5'",
          "ObjectSettings": {"MetaData": false},
        },
      );
      final rows = (data is Map) ? data['ApiObjectData'] : null;
      if (rows is List && rows.isNotEmpty) {
        writeGetStorage(loginKey, rows[0]);
        validation.value = false;
        getUserAccountTypes2();
        await myRequest(
          url: 'api/Pages/Updateweb_users',
          method: HttpMethod.post,
          body: {
            "Filters": "where  Email = '$email' ",
            "Values": {'Token': '$fcmToken'},
          },
        );
        Get.offAll(MainView());
      } else {
        validation.value = false;
        isPassWordNotCorrect.value = true;
      }
    } catch (e, st) {
      debugPrint('❌ checkEmailAndPassWordIsCorrect error: $e\n$st');
      validation.value = false;
      textErrorLogin.value = 'somethingWentWrong'.tr;
    } finally {
      isProgress.value = false;
    }
  }

  Future<void> checkIdentificationNumberAndPassWordIsCorrect(
    identificationNumber,
    password,
    isFromSplashScreen,
  ) async {
    isProgress.value = true;
    try {
      var passwordAfterMd5 = textToMd5(password);
      var data = await myRequest(
        url: 'api/Pages/Detailsweb_users',
        method: HttpMethod.post,
        body: {
          "Option": "column",
          "Filters":
              "where IdentityNumber = '$identificationNumber'and Password ='$passwordAfterMd5'",
          "ObjectSettings": {"MetaData": false},
        },
      );
      final rows = (data is Map) ? data['ApiObjectData'] : null;
      if (rows is List && rows.isNotEmpty) {
        writeGetStorage(loginKey, rows[0]);
        validation.value = false;
        await myRequest(
          url: 'api/Pages/Updateweb_users',
          method: HttpMethod.post,
          body: {
            "Filters": "where  IdentityNumber = '$identificationNumber' ",
            "Values": {'Token': '$fcmToken'},
          },
        );
        getUserAccountTypes2();
        Get.offAll(MainView());
      } else {
        validation.value = false;
        isPassWordNotCorrect.value = true;
      }
    } catch (e, st) {
      debugPrint(
        '❌ checkIdentificationNumberAndPassWordIsCorrect error: $e\n$st',
      );
      validation.value = false;
      textErrorLogin.value = 'somethingWentWrong'.tr;
    } finally {
      isProgress.value = false;
    }
  }

  Future<void> RegisterAcrossPhoneNumber(
    phoneNumber,
    isFromSplashScreen,
  ) async {
    isProgress.value = true;
    try {
      var data = await myRequest(
        otherBaseUrl: administrationUrl,
        url: sendFreeSms,
        method: HttpMethod.post,
        returnHeader: true,
        body: {"phonenumber": "+966$phoneNumber"},
      );

      if (data is! List || data.isEmpty) {
        validation.value = false;
        textErrorLogin.value = 'somethingWentWrong'.tr;
        return;
      }
      if (data[0] == false) {
        validation.value = false;
        textErrorLogin.value = (data.length >= 2 && data[1] is Map)
            ? (language == 'en'
                  ? data[1]['EnDescription']
                  : data[1]['ArDescription'])
            : 'somethingWentWrong'.tr;
        return;
      }

      var data2 = await myRequest(
        url: 'api/Pages/Site_SendSmsCodeFormAppFunction',
        method: HttpMethod.post,
        body: {"to": "+966${phoneNumber.trim()}"},
      );
      if (data2 is! List || data2.isEmpty || data2[0]?['Code'] == null) {
        validation.value = false;
        textErrorLogin.value = 'somethingWentWrong'.tr;
        debugPrint(
          '❌ Site_SendSmsCodeFormAppFunction returned unexpected: $data2',
        );
        return;
      }
      validation.value = false;
      var subStringKey = data[1].substring(10);
      var varSemicolon = subStringKey.indexOf(';');
      var md5Hash = subStringKey.toString().substring(0, varSemicolon);

      Get.to(
        VerificationRegistration(
          phoneNumber,
          md5Hash,
          verificationCodeFromFunction: int.tryParse(
            data2[0]['Code'].toString(),
          ),
          isFromSplashScreen: isFromSplashScreen,
        ),
      );
    } catch (e, st) {
      debugPrint('❌ RegisterAcrossPhoneNumber error: $e\n$st');
      validation.value = false;
      textErrorLogin.value = 'somethingWentWrong'.tr;
    } finally {
      isProgress.value = false;
    }
  }

  Future<void> RegisterAcrossEmail(email) async {
    isProgress.value = true;
    try {
      var data = await myRequest(
        method: HttpMethod.post,
        url: 'api/Pages/Detailsweb_users',
        body: {
          "Option": "column",
          "Fields": "Email",
          "Filters": "where Email = '$email'",
          "ObjectSettings": {"MetaData": false},
        },
      );
      final rows = (data is Map) ? data['ApiObjectData'] : null;
      if (rows is List && rows.isEmpty) {
        Get.to(
          RegistrationPage(emial: email, password: passwordController.text),
        );
      } else if (rows is List && rows.isNotEmpty) {
        validation.value = false;
        textErrorLogin.value = 'emailAlreadyExists'.tr;
      } else {
        validation.value = false;
        textErrorLogin.value = 'somethingWentWrong'.tr;
      }
    } catch (e, st) {
      debugPrint('❌ RegisterAcrossEmail error: $e\n$st');
      validation.value = false;
      textErrorLogin.value = 'somethingWentWrong'.tr;
    } finally {
      isProgress.value = false;
    }
  }

  Future<void> RegisterAcrossIdentificationNumber(identificationNumber) async {
    isProgress.value = true;
    try {
      var data = await myRequest(
        method: HttpMethod.post,
        url: 'api/Pages/Detailsweb_users',
        body: {
          "Option": "column",
          "Fields": "Email",
          "Filters": "where IdentityNumber = '$identificationNumber'",
          "ObjectSettings": {"MetaData": false},
        },
      );
      final rows = (data is Map) ? data['ApiObjectData'] : null;
      if (rows is List && rows.isEmpty) {
        Get.to(
          RegistrationPage(
            IdentityNumber: identificationNumber,
            password: passwordController.text,
          ),
        );
      } else if (rows is List && rows.isNotEmpty) {
        validation.value = false;
        textErrorLogin.value = 'iDNumberAlreadyExists'.tr;
      } else {
        validation.value = false;
        textErrorLogin.value = 'somethingWentWrong'.tr;
      }
    } catch (e, st) {
      debugPrint('❌ RegisterAcrossIdentificationNumber error: $e\n$st');
      validation.value = false;
      textErrorLogin.value = 'somethingWentWrong'.tr;
    } finally {
      isProgress.value = false;
    }
  }

  Future<void> getUserAccountTypes(
    hintText,
    bool isFromSplashScree, {
    VideoPlayerController? vc,
  }) async {
    isProgressCreateAccount.value = true;
    try {
      var data = await myRequest(
        url: 'api/Pages/$SiteGetUserAccountTypes',
        method: HttpMethod.post,
        body: {},
      );
      if (data is List && data.isNotEmpty) {
        validation.value = false;
        listUserAccountTypes = GetUserAccountTypes.fromJsonList(data);
        if (vc != null) vc.pause();
        await Get.to(optionRegister());
        if (vc != null) vc.play();
        return;
      }
      validation.value = false;
      textErrorLogin.value = 'somethingWentWrong'.tr;
    } catch (e, st) {
      debugPrint('❌ getUserAccountTypes error: $e\n$st');
      validation.value = false;
      textErrorLogin.value = 'somethingWentWrong'.tr;
    } finally {
      isProgressCreateAccount.value = false;
    }
  }

  Future<void> getUserAccountTypes2() async {
    try {
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
    isProgress.value = true;
    try {
      var passwordAfterMd5 = textToMd5(password);
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

      if (data is List && data.isNotEmpty && data[0] == true) {
        validation.value = false;
        await myRequest(
          url: 'api/Pages/Updateweb_users',
          method: HttpMethod.post,
          body: {
            "Filters": "where  IdentityNumber = '$identificationNumber' ",
            "Values": {'Token': '$fcmToken'},
          },
        );
        Get.offAll(
          MainView(lastPageNavigator: LoginUserName(isFromSplashScreen: false)),
        );
      } else {
        validation.value = false;
        textErrorLogin.value =
            (data is List && data.length >= 2 && data[1] is Map)
            ? (language == 'en'
                  ? data[1]['EnDescription']
                  : data[1]['ArDescription'])
            : 'somethingWentWrong'.tr;
      }
    } catch (e, st) {
      debugPrint('❌ sendRegistrationPage error: $e\n$st');
      validation.value = false;
      textErrorLogin.value = 'somethingWentWrong'.tr;
    } finally {
      isProgress.value = false;
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
