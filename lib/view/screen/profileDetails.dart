import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/profileController.dart';
import '../../global/globalUI.dart';

class profileDetails extends StatefulWidget {
  const profileDetails({super.key});

  @override
  State<StatefulWidget> createState() => _profileDetailsState();
}

class _profileDetailsState extends State<profileDetails> {
  var controller = Get.put(ProfileController());
  var isLogin = readGetStorage(loginKey);

  @override
  void initState() {
    super.initState();

    controller.controllerPhoneNumber.text = isLogin['Phone'] ?? '';
  }

  bool validateUserAccountType = false;
  bool validateTheCommercialRegistrationNo = false;
  bool validateIdentificationNumber = false;
  var passwordAfterMd5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: themeModeValue == 'dark' ? Colors.white : darkColor,
          ),
        ),
        title: widgetText(
          context,
          'profilePersonally'.tr,
          color: themeModeValue == 'light' ? darkColor : Colors.white,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Use the available width to choose responsive sizes for tablets/iPad
            final contentWidth = constraints.maxWidth;
            final isLarge = contentWidth >= 700;
            final horizontalPadding = contentWidth * 0.05;
            final avatarSize = isLarge ? 160.0 : contentWidth * 0.2;

            return Container(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: themeModeValue == 'light'
                            ? Colors.white
                            : buttonDarkColor,
                        border: Border(
                          bottom: BorderSide(
                            width: Get.width * .005,
                            color: const Color(
                              0xffE1E6E2,
                            ).withAlpha((255 * .30).toInt()),
                          ),
                        ),
                        boxShadow: [
                          themeModeValue == 'light'
                              ? const BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 15,
                                  spreadRadius: -10,
                                )
                              : const BoxShadow(color: Colors.transparent),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: Get.height * .02,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: InkWell(
                                    onTap: () {
                                      // Get.to(profileDetails());
                                      showDialogUploadImageFromGalleryOrCameraForLogo();
                                    },
                                    child: Column(
                                      children: [
                                        controller.imageProfileBase64 != null
                                            ? Container(
                                                width: avatarSize,
                                                height: avatarSize,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: MemoryImage(
                                                      base64.decode(
                                                        controller
                                                            .imageProfileBase64,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: avatarSize,
                                                height: avatarSize,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(
                                                      pngCharacter,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      language == "ar"
                                          ? Row(
                                              children: [
                                                widgetText(
                                                  context,
                                                  isLogin['FirstNameAr'] ??
                                                      isLogin['FirstNameEn'],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                widgetText(
                                                  context,
                                                  (isLogin['LastNameAr'] ??
                                                      isLogin['LastNameEn'] ??
                                                      ''),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                widgetText(
                                                  context,
                                                  isLogin['FirstNameEn'] ??
                                                      isLogin['FirstNameAr'],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                widgetText(
                                                  context,
                                                  (isLogin['LastNameEn'] ??
                                                      isLogin['LastNameAr'] ??
                                                      ''),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ],
                                            ),
                                      SizedBox(height: avatarSize * 0.12),
                                      widgetText(
                                        context,
                                        controller.listUserAccountTypes
                                                .where(
                                                  (element) =>
                                                      element.id ==
                                                      isLogin['CustGroupID'],
                                                )
                                                .toList()
                                                .isNotEmpty
                                            ? (language == 'ar'
                                                  ? controller
                                                        .listUserAccountTypes
                                                        .where(
                                                          (element) =>
                                                              element.id ==
                                                              isLogin['CustGroupID'],
                                                        )
                                                        .toList()[0]
                                                        .descriptionAr
                                                  : controller
                                                        .listUserAccountTypes
                                                        .where(
                                                          (element) =>
                                                              element.id ==
                                                              isLogin['CustGroupID'],
                                                        )
                                                        .toList()[0]
                                                        .descriptionEn)
                                            : 'clientType'.tr,
                                        fontSize: contentWidth * 0.035,
                                      ),
                                      SizedBox(height: contentWidth * 0.01),
                                      widgetText(
                                        context,
                                        isLogin['Address'] ?? '',
                                        fontSize: contentWidth * .028,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        // adaptive height for tabs
                        height: isLarge ? Get.height * 0.12 : Get.height * 0.1,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              InkWell(
                                child: _widgetTab(
                                  'profilePersonally',
                                  0,
                                  activeColor:
                                      controller.optionTap.value == 0 ||
                                          controller.optionTap.value == 3
                                      ? true
                                      : false,
                                ),
                                onTap: () {
                                  userAccountTypesValue = null;
                                },
                              ),
                              SizedBox(width: contentWidth * .03),
                              _widgetTab(
                                'contactInformation',
                                1,
                                activeColor:
                                    controller.optionTap.value == 1 ||
                                        controller.optionTap.value == 4
                                    ? true
                                    : false,
                              ),
                              SizedBox(width: contentWidth * .03),
                              _widgetTab(
                                'confidentialityAndSecurity',
                                2,
                                activeColor:
                                    controller.optionTap.value == 2 ||
                                        controller.optionTap.value == 5
                                    ? true
                                    : false,
                              ),
                              SizedBox(width: contentWidth * .03),
                              _widgetTab(
                                'deleteAnAccount',
                                -1,
                                activeColor: controller.optionTap.value == -1
                                    ? true
                                    : false,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.optionTap.value == 0,
                        child: Column(
                          children: [
                            widgetTextForm(
                              context,
                              initialValue: language == "ar"
                                  ? isLogin['FirstNameAr']
                                  : isLogin['FirstNameEn'],
                              readOnly: true,
                              hintText: 'firstName'.tr,
                            ),
                            widgetTextForm(
                              context,
                              initialValue: language == "ar"
                                  ? isLogin['MiddleNameAr']
                                  : isLogin['MiddleNameEn'],
                              readOnly: true,
                              hintText: 'middleName'.tr,
                            ),
                            widgetTextForm(
                              context,
                              initialValue: language == "ar"
                                  ? isLogin['LastNameAr']
                                  : isLogin['LastNameEn'],
                              readOnly: true,
                              hintText: 'lastName'.tr,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RadioGroup(
                                  onChanged: (value) {},
                                  groupValue: controller.idGender.value,
                                  child: Radio(
                                    value: 1,
                                    activeColor: greenColor,
                                  ),
                                ),
                                widgetText(
                                  context,
                                  'male'.tr,
                                  fontSize: Get.width * .035,
                                ),
                                RadioGroup(
                                  groupValue: controller.idGender.value,
                                  onChanged: (value) {},
                                  child: Radio(
                                    value: 2,
                                    activeColor: greenColor,
                                  ),
                                ),
                                widgetText(
                                  context,
                                  'female'.tr,
                                  fontSize: Get.width * .035,
                                ),
                              ],
                            ),
                            widgetTextForm(
                              context,
                              initialValue: isLogin['Address'] ?? '',
                              readOnly: true,
                              hintText: 'theAddress'.tr,
                            ),
                            widgetTextForm(
                              context,
                              initialValue: isLogin['IdentityNumber'] ?? '',
                              readOnly: true,
                              hintText: 'identityData'.tr,
                            ),
                            widgetDropdownGetUserAccountTypes(
                              context,
                              controller.listUserAccountTypes,
                              language,
                              hint:
                                  controller.listUserAccountTypes
                                      .where(
                                        (element) =>
                                            element.id ==
                                            isLogin['CustGroupID'],
                                      )
                                      .toList()
                                      .isNotEmpty
                                  ? (language == 'ar'
                                        ? controller.listUserAccountTypes
                                              .where(
                                                (element) =>
                                                    element.id ==
                                                    isLogin['CustGroupID'],
                                              )
                                              .toList()[0]
                                              .descriptionAr
                                        : controller.listUserAccountTypes
                                              .where(
                                                (element) =>
                                                    element.id ==
                                                    isLogin['CustGroupID'],
                                              )
                                              .toList()[0]
                                              .descriptionEn)
                                  : 'userAccountType'.tr,
                              errorColor: validateUserAccountType,
                            ),
                            SizedBox(height: Get.height * .015),
                            widgetButton(
                              context,
                              'edit'.tr,
                              colorText: Colors.white,
                              colorButton: greenColor,
                              fontSize: contentWidth * .035,
                              fontWeight: FontWeight.bold,
                              width: contentWidth * .9,
                              onTap: () {
                                controller.optionTap.value = 3;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.optionTap.value == 3,
                        child: Column(
                          children: [
                            widgetTextForm(
                              context,
                              controller: controller.controllerFistName,
                              errorText: controller.validateFirstName.value
                                  ? ('firstNameIsRequired'.tr)
                                  : null,
                              onChanged: (v) {
                                if (v.toString().isEmpty) {
                                  controller.validateFirstName.value = true;
                                } else {
                                  controller.validateFirstName.value = false;
                                }
                                setState(() {});
                              },
                              hintText: 'firstName'.tr,
                            ),
                            widgetTextForm(
                              context,
                              controller: controller.controllerMiddleName,
                              errorText: controller.validateMiddleName.value
                                  ? ('theSecondNameIsRequired'.tr)
                                  : null,
                              onChanged: (v) {
                                if (v.toString().isEmpty) {
                                  controller.validateMiddleName.value = true;
                                } else {
                                  controller.validateMiddleName.value = false;
                                }
                                setState(() {});
                              },
                              hintText: 'middleName'.tr,
                            ),
                            widgetTextForm(
                              context,
                              controller: controller.controllerLastName,
                              errorText: controller.validateLastName.value
                                  ? ('lastNameIsRequired'.tr)
                                  : null,
                              onChanged: (v) {
                                if (v.toString().isEmpty) {
                                  controller.validateLastName.value = true;
                                } else {
                                  controller.validateLastName.value = false;
                                }
                              },
                              hintText: 'lastName'.tr,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                RadioGroup(
                                  onChanged: (value) {},
                                  groupValue: controller.idGender.value,
                                  child: Radio(
                                    value: 1,
                                    activeColor: greenColor,
                                  ),
                                ),
                                widgetText(
                                  context,
                                  'male'.tr,
                                  fontSize: Get.width * .035,
                                ),
                                RadioGroup(
                                  onChanged: (value) {},
                                  groupValue: controller.idGender.value,
                                  child: Radio(
                                    value: 2,
                                    activeColor: greenColor,
                                  ),
                                ),
                                widgetText(
                                  context,
                                  'female'.tr,
                                  fontSize: Get.width * .035,
                                ),
                              ],
                            ),
                            widgetTextForm(
                              context,
                              controller: controller.controllerAddress,
                              errorText: controller.validateTheAddress.value
                                  ? ('addressIsRequired'.tr)
                                  : null,
                              onChanged: (v) {
                                if (v.toString().isEmpty) {
                                  controller.validateTheAddress.value = true;
                                } else {
                                  controller.validateTheAddress.value = false;
                                }
                              },
                              hintText: 'theAddress'.tr,
                            ),
                            widgetTextForm(
                              context,
                              controller: controller.controllerIdentityNumber,
                              hintText: 'identityData'.tr,
                              errorText: controller.validateIDNumber.value
                                  ? ('identityDataIsRequired'.tr)
                                  : null,
                              onChanged: (v) {
                                if (v.toString().isEmpty) {
                                  controller.validateIDNumber.value = true;
                                } else {
                                  controller.validateIDNumber.value = false;
                                }
                              },
                            ),
                            widgetDropdownGetUserAccountTypes(
                              context,
                              controller.listUserAccountTypes,
                              language,
                              hint:
                                  controller.listUserAccountTypes
                                      .where(
                                        (element) =>
                                            element.id ==
                                            isLogin['CustGroupID'],
                                      )
                                      .toList()
                                      .isNotEmpty
                                  ? (language == 'ar'
                                        ? controller.listUserAccountTypes
                                              .where(
                                                (element) =>
                                                    element.id ==
                                                    isLogin['CustGroupID'],
                                              )
                                              .toList()[0]
                                              .descriptionAr
                                        : controller.listUserAccountTypes
                                              .where(
                                                (element) =>
                                                    element.id ==
                                                    isLogin['CustGroupID'],
                                              )
                                              .toList()[0]
                                              .descriptionEn)
                                  : 'userAccountType'.tr,
                              onChanged: (value) {
                                validateUserAccountType = false;
                                controller.userAccountTypesTheChosen =
                                    controller.listUserAccountTypes
                                        .where((element) => element.id == value)
                                        .toList();
                                userAccountTypesValue = value.toString();
                                validateUserAccountType = false;
                                validateTheCommercialRegistrationNo = false;
                                validateIdentificationNumber = false;
                                setState(() {});
                              },
                              errorColor: validateUserAccountType,
                            ),
                            SizedBox(height: Get.height * .015),
                            widgetButton(
                              context,
                              'save'.tr,
                              colorText: Colors.white,
                              colorButton: greenColor,
                              fontSize: Get.width * .035,
                              fontWeight: FontWeight.bold,
                              width: Get.width * .9,
                              isProgress: controller.isProgress.value,
                              onTap: () {
                                if (controller
                                    .controllerFistName
                                    .text
                                    .isEmpty) {
                                  controller.validateFirstName.value = true;
                                  setState(() {});
                                }
                                if (controller
                                    .controllerLastName
                                    .text
                                    .isEmpty) {
                                  controller.validateLastName.value = true;
                                  setState(() {});
                                } else if (controller
                                    .controllerAddress
                                    .text
                                    .isEmpty) {
                                  controller.validateTheAddress.value = true;
                                  setState(() {});
                                } else if (controller
                                    .controllerIdentityNumber
                                    .text
                                    .isEmpty) {
                                  controller.validateIDNumber.value = true;
                                  setState(() {});
                                } else {
                                  controller.updateProfilePersonally();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.optionTap.value == 1,
                        child: Column(
                          children: [
                            widgetPhoneNumber(context),
                            widgetTextForm(
                              context,
                              readOnly: true,
                              initialValue: isLogin['Email'] ?? '',
                              textDirection: TextDirection.ltr,
                              hintText: 'email'.tr,
                            ),
                            widgetButton(
                              context,
                              'edit'.tr,
                              colorText: Colors.white,
                              colorButton: greenColor,
                              fontSize: Get.width * .035,
                              fontWeight: FontWeight.bold,
                              width: Get.width * .9,
                              onTap: () {
                                controller.optionTap.value = 4;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.optionTap.value == 4,
                        child: Column(
                          children: [
                            widgetPhoneNumber(context, isEnabled: true),
                            widgetTextForm(
                              context,
                              controller: controller.controllerEmail,
                              textDirection: TextDirection.ltr,
                              hintText: 'email'.tr,
                            ),
                            widgetButton(
                              context,
                              'save'.tr,
                              colorText: Colors.white,
                              colorButton:
                                  controller.validatePhoneNumber.value ==
                                          true &&
                                      controller.controllerEmail.text
                                          .toString()
                                          .isEmail
                                  ? greenColor
                                  : null,
                              fontSize: Get.width * .035,
                              fontWeight: FontWeight.bold,
                              width: Get.width * .9,
                              isProgress: controller.isProgress.value,
                              onTap: () {
                                if (controller.validatePhoneNumber.value ==
                                        true &&
                                    controller.controllerEmail.text
                                        .toString()
                                        .isEmail) {
                                  controller.updatePasswordContactInformation();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.optionTap.value == 2,
                        child: Column(
                          children: [
                            widgetTextForm(
                              context,
                              initialValue: isLogin['Password'],
                              obscureText: true,
                              readOnly: true,
                              hintText: 'currentPassword'.tr,
                            ),
                            widgetButton(
                              context,
                              'edit'.tr,
                              colorText: Colors.white,
                              colorButton: greenColor,
                              fontSize: Get.width * .035,
                              fontWeight: FontWeight.bold,
                              width: Get.width * .9,
                              onTap: () {
                                controller.optionTap.value = 5;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.optionTap.value == 5,
                        child: Column(
                          children: [
                            widgetTextForm(
                              context,
                              obscureText: true,
                              controller: controller.controllerCurrentPassword,
                              errorText:
                                  (isLogin['Password'] != passwordAfterMd5)
                                  ? 'pleaseEnterTheCurrentPassword'.tr
                                  : null,
                              hintText: 'currentPassword'.tr,
                              onChanged: (v) {
                                passwordAfterMd5 = textToMd5(v);
                                if (isLogin['Password'] == passwordAfterMd5 &&
                                    controller.controllerReNewPassword.value ==
                                        controller
                                            .controllerNewPassword
                                            .value) {
                                  controller.validateChangePassword.value =
                                      true;
                                } else {
                                  controller.validateChangePassword.value =
                                      false;
                                }
                                setState(() {});
                              },
                            ),
                            widgetTextForm(
                              context,
                              obscureText: true,
                              hintText: 'newPassword'.tr,
                              controller: controller.controllerNewPassword,
                              onChanged: (v) {
                                if (isLogin['Password'] == passwordAfterMd5 &&
                                    controller.controllerReNewPassword.value ==
                                        controller
                                            .controllerNewPassword
                                            .value) {
                                  controller.validateChangePassword.value =
                                      true;
                                } else {
                                  controller.validateChangePassword.value =
                                      false;
                                }
                                setState(() {});
                              },
                            ),
                            widgetTextForm(
                              context,
                              obscureText: true,
                              hintText: 'retypePassword'.tr,
                              controller: controller.controllerReNewPassword,
                              errorText:
                                  controller.controllerReNewPassword.value !=
                                      controller.controllerNewPassword.value
                                  ? 'thePasswordIsNotIdentical'.tr
                                  : null,
                              onChanged: (v) {
                                if (isLogin['Password'] == passwordAfterMd5 &&
                                    controller.controllerReNewPassword.value ==
                                        controller
                                            .controllerNewPassword
                                            .value) {
                                  controller.validateChangePassword.value =
                                      true;
                                } else {
                                  controller.validateChangePassword.value =
                                      false;
                                }
                                setState(() {});
                              },
                            ),
                            widgetButton(
                              context,
                              'changing'.tr,
                              colorText: Colors.white,
                              colorButton:
                                  controller
                                          .controllerReNewPassword
                                          .value
                                          .text
                                          .isNotEmpty &&
                                      controller.validateChangePassword.value
                                  ? greenColor
                                  : null,
                              fontSize: Get.width * .035,
                              fontWeight: FontWeight.bold,
                              width: Get.width * .9,
                              isProgress: controller.isProgress.value,
                              onTap: () {
                                if (controller.isProgress.value != true &&
                                    isLogin['Password'] == passwordAfterMd5 &&
                                    controller.controllerReNewPassword.value ==
                                        controller
                                            .controllerNewPassword
                                            .value &&
                                    controller
                                        .controllerReNewPassword
                                        .value
                                        .text
                                        .isNotEmpty) {
                                  controller.updatePassword();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Container widgetPhoneNumber(context, {isEnabled = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: Get.height * .015),
      decoration: BoxDecoration(
        color: themeModeValue == 'light' ? Colors.white : buttonDarkColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: themeModeValue == 'light' ? greyColor : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: themeModeValue == 'light'
                ? Colors.grey.withAlpha((255 * 0.3).toInt())
                : Colors.transparent,
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: TextField(
            controller: controller.controllerPhoneNumber,
            readOnly: !isEnabled,
            onChanged: (number) {
              controller.phoneNumber = number;
              controller.validatePhoneNumber.value = number.isNotEmpty;
            },
            style: TextStyle(
              color: themeModeValue == 'dark' ? Colors.white : darkColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              errorText: controller.validatePhoneNumber.value
                  ? null
                  : 'phoneNumberInvalid'.tr,
              hintText: 'mobileNumber'.tr,
            ),
          ),
        ),
      ),
    );
  }

  Future showDialogUploadImageFromGalleryOrCameraForIdentificationNumber() {
    return Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        contentPadding: const EdgeInsets.only(top: 10.0),
        content: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: Get.height * .02),
              SizedBox(height: Get.height * .01),
              Container(
                width: Get.width * .6,
                height: Get.width * .6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: MemoryImage(base64.decode(isLogin['IdentityImage'])),
                  ),
                ),
              ),
              SizedBox(height: Get.height * .01),
              SizedBox(height: Get.height * .05),
            ],
          ),
        ),
      ),
    );
  }

  Future showDialogUploadImageFromGalleryOrCameraForLogo() {
    return Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        contentPadding: const EdgeInsets.only(top: 10.0),
        content: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: Get.height * .02),
              SizedBox(height: Get.height * .01),
              /*      Stack(children: [
                  isLogin['Logo'] != null
                      ? Container(
                          width: Get.width * .6,
                          height: Get.width * .6,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: MemoryImage(
                                  base64.decode(isLogin['Logo']),
                                ),
                              )))
                      : Container(
                          width: Get.width * .6,
                          height: Get.width * .6,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                  pngCharacter,
                                ),
                              )),
                        ),

                ]),*/
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  controller.imageProfileBase64 == null
                      ? Container(
                          width: Get.width * .4,
                          height: Get.width * .4,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(pngCharacter),
                            ),
                          ),
                        )
                      : Container(
                          width: Get.width * .4,
                          height: Get.width * .4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: MemoryImage(
                                base64.decode(controller.imageProfileBase64),
                              ),
                            ),
                          ),
                        ),
                  InkWell(
                    onTap: () async {
                      showDialogUploadImageFromGalleryOrCamera();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: Get.width * .03,
                        right: Get.width * .03,
                      ),
                      child: Material(
                        color: Colors.white,
                        shape: const CircleBorder(
                          side: BorderSide(color: Colors.white),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(Get.width * .01),
                          child: Icon(
                            Icons.camera_alt,
                            color: themeModeValue == 'dark'
                                ? Colors.white
                                : darkColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * .01),
              SizedBox(height: Get.height * .05),
            ],
          ),
        ),
      ),
    );
  }

  InkWell _widgetTab(text, int intTap, {bool activeColor = false}) {
    return InkWell(
      onTap: () {
        if (intTap == -1) {
          controller.deleteMyAccountFunction(
            isLogin['Email'],
            isLogin['Phone'],
            isLogin['IdentityNumber'],
          );
          return;
        }
        controller.optionTap.value = intTap;
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: activeColor ? greenColor : darkColor),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * .02,
          vertical: Get.height * .01,
        ),
        margin: EdgeInsets.symmetric(vertical: Get.height * .02),
        child: widgetText(context, '$text'.tr, fontSize: Get.width * .035),
      ),
    );
  }

  Future showDialogUploadImageFromGalleryOrCamera() {
    return Get.dialog(
      AlertDialog(
        backgroundColor: themeModeValue == 'light' ? Colors.white : darkColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        contentPadding: const EdgeInsets.only(top: 10.0),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: Get.height * .02),
            widgetText(
              context,
              'chooseAPhoto'.tr,
              fontSize: Get.width * .03,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: Get.height * .015),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    XFile? file = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                    );
                    Uint8List imagebytes = await file!.readAsBytes();
                    controller.imageProfileBase64 = base64.encode(imagebytes);

                    controller.updateLogo();
                    Get.back();
                    Get.back();
                  },
                  child: SvgPicture.asset(
                    svgLogoCamera,
                    height: Get.height * .055,
                    semanticsLabel: 'Acme Logo',
                  ),
                ),
                SizedBox(width: Get.width * .08),
                Container(
                  margin: EdgeInsets.only(top: Get.height * .022),
                  width: Get.width * .0008,
                  height: Get.height * .02,
                  color: greyColor3,
                ),
                SizedBox(width: Get.width * .08),
                InkWell(
                  onTap: () async {
                    XFile? file = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    Uint8List imagebytes = await file!.readAsBytes();
                    controller.imageProfileBase64 = base64.encode(imagebytes);

                    controller.updateLogo();
                    Get.back();
                    Get.back();
                  },
                  child: SvgPicture.asset(
                    svgLogoLibrary,
                    height: Get.height * .055,
                  ),
                ),
              ],
            ),
            SizedBox(height: Get.height * .02),
            Container(
              width: Get.width * .48,
              height: Get.height * .0006,
              color: greyColor3,
            ),
            SizedBox(height: Get.height * .05),
          ],
        ),
      ),
    );
  }
}
