import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hj_app/global/queryModel.dart';
import 'package:video_player/video_player.dart';
import '../global/enumMethod.dart';
import '../global/globalUI.dart';
import '../global/globalUrl.dart';
import '../main.dart';
import '../model/getUserAccountTypes.dart';
import '../view/Login/registrationPage.dart';
import '../view/Login/verificationRegistration.dart';
import '../view/Login/optionRegister.dart';
import '../view/Login/loginUserNameScreen.dart';
import '../view/screen/mainView.dart';

class RegisterControl extends GetxController {
  RxBool isProgress = false.obs;
  RxBool validation = false.obs;
  RxBool isProgressCreateAccount = false.obs;
  RxBool showIdentification = false.obs;
  RxBool showCommercialRegistrationNo = false.obs;
  RxBool checkbox = false.obs;
  RxBool checkboxIsFalse = false.obs;
  RxBool isRegistrationFieldsFull = false.obs;
  RxString textErrorLogin = ''.obs;

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

  var imageIdentificationNumber;
  var imageIdentificationNumberBase64;
  var imageCommercialRegistrationNo;
  var imageCommercialRegistrationNoBase64;

  List<GetUserAccountTypes> listUserAccountTypes = <GetUserAccountTypes>[].obs;
  List<GetUserAccountTypes> userAccountTypesTheChosen =
      <GetUserAccountTypes>[].obs;
  RxString privacyBaseInfo = ''.obs;

  Future<void> getPrivacyPolicy() async {
    var data = await myRequest(
      url: 'privacy/index',
      method: HttpMethod.get,
      body: {},
      otherBaseUrl: 'https://appmb.hassanjameelapp.com/api/',
    );

    if (data != null && data['baseInfo'].isNotEmpty) {
      privacyBaseInfo.value = '';
      for (var element in data['baseInfo']) {
        privacyBaseInfo.value +=
            '${element['intro']}\n${element['explaination']}\n\n';
      }
    }
  }

  Future<void> registerAcrossPhoneNumber(
    phoneNumber,
    isFromSplashScreen, {
    bool isResend = false,
  }) async {
    try {
      isProgress.value = true;
      textErrorLogin.value = '';
      var data = await myRequest(
        otherBaseUrl: administrationUrl,
        url: sendFreeSms,
        method: HttpMethod.post,
        returnHeader: true,
        body: {"phonenumber": "+966$phoneNumber"},
      );

      if (data != null && data is List && data.length >= 2 && data[0] == true) {
        var data2 = await myRequest(
          url: func,
          method: HttpMethod.post,
          body: {
            "Name": "Site_SendSmsCodeFormAppFunction",
            "Values": {"to": "+966${phoneNumber.trim()}"},
          },
        );

        if (data2 != null &&
            data2 is List &&
            data2.isNotEmpty &&
            data2[0]['Code'] != null) {
          validation.value = false;
          String md5Hash = '';
          try {
            String cookie = data[1].toString();
            if (cookie.length > 10) {
              var sub = cookie.substring(10);
              var semi = sub.indexOf(';');
              md5Hash = (semi != -1) ? sub.substring(0, semi) : sub;
            }
          } catch (e) {
            debugPrint("⚠️ Error parsing md5Hash: $e");
          }

          if (isResend) {
            Get.back(); // Close the current verification screen to open the new one
          }
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
        } else {
          textErrorLogin.value = 'somethingWentWrong'.tr;
        }
      } else {
        validation.value = false;
        if (data != null && data is List && data.length >= 2) {
          textErrorLogin.value =
              (language == 'en'
                  ? data[1]['EnDescription']
                  : data[1]['ArDescription']) ??
              'somethingWentWrong'.tr;
        } else {
          textErrorLogin.value = 'somethingWentWrong'.tr;
        }
      }
    } catch (e) {
      debugPrint("❌ registerAcrossPhoneNumber error: $e");
      textErrorLogin.value = 'somethingWentWrong'.tr;
    } finally {
      isProgress.value = false;
    }
  }

  Future<void> registerAcrossEmail(email) async {
    try {
      isProgress.value = true;
      textErrorLogin.value = '';
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

      if (data != null && data is Map && data['ApiObjectData'] != null) {
        if (data['ApiObjectData'].isEmpty) {
          Get.to(
            RegistrationPage(emial: email, password: passwordController.text),
          );
        } else {
          validation.value = false;
          textErrorLogin.value = 'emailAlreadyExists'.tr;
        }
      } else {
        textErrorLogin.value = 'somethingWentWrong'.tr;
      }
    } catch (e) {
      debugPrint("❌ registerAcrossEmail error: $e");
      textErrorLogin.value = 'somethingWentWrong'.tr;
    } finally {
      isProgress.value = false;
    }
  }

  Future<void> registerAcrossIdentificationNumber(identificationNumber) async {
    try {
      isProgress.value = true;
      textErrorLogin.value = '';
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

      if (data != null && data is Map && data['ApiObjectData'] != null) {
        if (data['ApiObjectData'].isEmpty) {
          Get.to(
            RegistrationPage(
              IdentityNumber: identificationNumber,
              password: passwordController.text,
            ),
          );
        } else {
          validation.value = false;
          textErrorLogin.value = 'iDNumberAlreadyExists'.tr;
        }
      } else {
        textErrorLogin.value = 'somethingWentWrong'.tr;
      }
    } catch (e) {
      debugPrint("❌ registerAcrossIdentificationNumber error: $e");
      textErrorLogin.value = 'somethingWentWrong'.tr;
    } finally {
      isProgress.value = false;
    }
  }

  Future<void> getUserAccountTypes(
    hintText,
    bool isFromSplashScreen, {
    VideoPlayerController? vc,
  }) async {
    try {
      isProgressCreateAccount.value = true;
      textErrorLogin.value = '';
      var data = await myRequest(
        url: func,
        method: HttpMethod.post,
        body: {"name": SiteGetUserAccountTypes},
      );

      if (data != null && data is List && data.isNotEmpty) {
        validation.value = false;
        listUserAccountTypes = GetUserAccountTypes.fromJsonList(data);
        if (vc != null) {
          vc.pause();
        }
        await Get.to(optionRegister());
        if (vc != null) {
          vc.play();
        }
      } else {
        validation.value = false;
        textErrorLogin.value = 'somethingWentWrong'.tr;
      }
    } catch (e) {
      debugPrint("❌ getUserAccountTypes error: $e");
      textErrorLogin.value = 'somethingWentWrong'.tr;
    } finally {
      isProgressCreateAccount.value = false;
    }
  }

  void getUserAccountTypeDropDownOnChange(id) {
    List<GetUserAccountTypes> data = listUserAccountTypes
        .where((element) => element.id == id)
        .toList();
    if (data[0].needIdentity) {
      showIdentification.value = true;
      showCommercialRegistrationNo.value = false;
    } else {
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
    try {
      isProgress.value = true;
      textErrorLogin.value = '';
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

      if (data != null && data is List && data.length >= 2 && data[0] == true) {
        validation.value = false;
        await myRequest(
          url: update,
          method: HttpMethod.put,
          body: {
            "Object": "web_users",
            "filters": "where Phone = '+966${phone.toString().trim()}' ",
            "Values": {'Token': '$fcmToken'},
            "ObjectSettings": {"MetaData": false},
          },
        );
        Get.offAll(
          MainView(lastPageNavigator: LoginUserName(isFromSplashScreen: false)),
        );
      } else {
        validation.value = false;
        if (data != null && data is List && data.length >= 2) {
          textErrorLogin.value =
              (language == 'en'
                  ? data[1]['EnDescription']
                  : data[1]['ArDescription']) ??
              'somethingWentWrong'.tr;
        } else {
          textErrorLogin.value = 'somethingWentWrong'.tr;
        }
      }
    } catch (e) {
      debugPrint("❌ sendRegistrationPage error: $e");
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
