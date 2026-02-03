import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hj_app/global/globalUI.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/loginAndRegisterControl.dart';

class RegistrationPage extends StatefulWidget {
  final dynamic phoneNumber;
  final dynamic emial;
  final dynamic IdentityNumber;
  final dynamic password;

  const RegistrationPage({
    super.key,
    this.phoneNumber,
    this.emial,
    this.IdentityNumber,
    this.password,
  });

  @override
  State<StatefulWidget> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final LoginAndRegisterControl controller = Get.put(LoginAndRegisterControl());
  bool validateFirstName = false;
  bool validateMiddleName = false;
  bool validateLastName = false;
  bool validateEmail = false;
  bool validatePassWord = false;
  bool validateConfirmPassWord = false;
  bool validateConfirmPassWordIsMatch = false;
  bool validateUserAccountType = false;
  bool validateIdentificationNumber = false;
  bool validateTheCommercialRegistrationNo = false;

  @override
  void initState() {
    super.initState();
    if (widget.emial != null) {
      controller.emailController.text = widget.emial;
    }
    if (widget.IdentityNumber != null) {
      controller.identificationNumberController.text = widget.IdentityNumber;
    }
    controller.showIdentification.value = false;
    controller.showCommercialRegistrationNo.value = false;
    userAccountTypesValue = null;
    controller.getPrivacyPolicy();
  }

  @override
  void dispose() {
    controller.textErrorLogin.value = '';
    controller.isProgress.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeModeValue == 'dark' ? darkColor : Colors.white,

        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: themeModeValue == 'light' ? darkColor : Colors.white,
          ),
        ),
        title: widgetText(
          context,
          'createAnAccount'.tr,
          fontWeight: FontWeight.bold,
          color: themeModeValue == 'light' ? darkColor : Colors.white,
          textAlign: TextAlign.start,
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: Get.width * .03),
                margin: EdgeInsets.only(top: Get.height * .01),
                child: Column(
                  children: [
                    widgetTextForm(
                      context,
                      hintText: 'firstName',
                      controller: controller.firstNameController,
                      onChanged: (v) {
                        controller.textErrorLogin.value = '';
                        if (validateFirstName) {
                          if (v.toString().isNotEmpty) {
                            setState(() {
                              validateFirstName = false;
                            });
                          }
                        }
                        controller.checkRegistrationFieldsFull(
                          firstName: controller.firstNameController.text,
                          lastName: controller.lastNameController.text,
                          middleName: controller.middleNameController.text,
                          password: controller.passwordController.text,
                          confirmPassword:
                              controller.confirmPasswordController.text,
                          identificationNumber:
                              controller.identificationNumberController.text,
                          commercialRegistrationNo: controller
                              .commercialRegistrationNoController
                              .text,
                        );
                      },
                      errorText: validateFirstName
                          ? 'pleaseEnterFirstName'.tr
                          : null,
                    ),
                    SizedBox(height: Get.height * .015),
                    widgetTextForm(
                      context,
                      hintText: 'middleName',
                      controller: controller.middleNameController,
                      onChanged: (v) {
                        controller.textErrorLogin.value = '';
                        if (validateMiddleName) {
                          if (v.toString().isNotEmpty) {
                            setState(() {
                              validateMiddleName = false;
                            });
                          }
                        }
                        controller.checkRegistrationFieldsFull(
                          firstName: controller.firstNameController.text,
                          lastName: controller.lastNameController.text,
                          middleName: controller.middleNameController.text,
                          password: controller.passwordController.text,
                          confirmPassword:
                              controller.confirmPasswordController.text,
                          identificationNumber:
                              controller.identificationNumberController.text,
                          commercialRegistrationNo: controller
                              .commercialRegistrationNoController
                              .text,
                        );
                      },
                      errorText: validateMiddleName
                          ? 'pleaseEnterMiddleName'.tr
                          : null,
                    ),
                    SizedBox(height: Get.height * .015),
                    widgetTextForm(
                      context,
                      hintText: 'lastName',
                      controller: controller.lastNameController,
                      onChanged: (v) {
                        controller.textErrorLogin.value = '';
                        if (validateLastName) {
                          if (v.toString().isNotEmpty) {
                            setState(() {
                              validateLastName = false;
                            });
                          }
                        }
                        controller.checkRegistrationFieldsFull(
                          firstName: controller.firstNameController.text,
                          lastName: controller.lastNameController.text,
                          middleName: controller.middleNameController.text,
                          password: controller.passwordController.text,
                          confirmPassword:
                              controller.confirmPasswordController.text,
                          identificationNumber:
                              controller.identificationNumberController.text,
                          commercialRegistrationNo: controller
                              .commercialRegistrationNoController
                              .text,
                        );
                      },
                      errorText: validateLastName
                          ? 'pleaseEnterLastName'.tr
                          : null,
                    ),
                    SizedBox(height: Get.height * .015),
                    Visibility(
                      visible: widget.emial == null,
                      child: widgetTextForm(
                        context,
                        hintText: 'email',
                        controller: controller.emailController,
                        onChanged: (v) {
                          controller.textErrorLogin.value = '';
                          if (validateEmail) {
                            if (v.toString().isNotEmpty) {
                              setState(() {
                                validateEmail = false;
                              });
                            }
                          }
                          controller.checkRegistrationFieldsFull(
                            firstName: controller.firstNameController.text,
                            lastName: controller.lastNameController.text,
                            middleName: controller.middleNameController.text,
                            password: controller.passwordController.text,
                            confirmPassword:
                                controller.confirmPasswordController.text,
                            identificationNumber:
                                controller.identificationNumberController.text,
                            commercialRegistrationNo: controller
                                .commercialRegistrationNoController
                                .text,
                          );
                        },
                        textDirection: TextDirection.ltr,
                        errorText: validateEmail
                            ? 'pleaseEnterTheEmail'.tr
                            : null,
                      ),
                    ),
                    SizedBox(height: Get.height * .015),
                    Visibility(
                      visible: widget.phoneNumber == null,
                      child: widgetPhoneNumber(context),
                    ),
                    SizedBox(height: Get.height * .015),
                    widgetDropdownGetUserAccountTypes(
                      context,
                      controller.listUserAccountTypes,
                      language,
                      onChanged: (value) {
                        validateUserAccountType = false;
                        controller.userAccountTypesTheChosen = controller
                            .listUserAccountTypes
                            .where((element) => element.id == value)
                            .toList();
                        userAccountTypesValue = value.toString();
                        controller.getUserAccountTypeDropDownOnChange(value);
                        validateUserAccountType = false;
                        validateTheCommercialRegistrationNo = false;
                        validateIdentificationNumber = false;
                        setState(() {});
                      },
                      errorColor: validateUserAccountType,
                    ),
                    SizedBox(height: Get.height * .015),
                    Visibility(
                      visible: controller.showIdentification.value,
                      child: Column(
                        children: [
                          widgetTextForm(
                            context,
                            textDirection: TextDirection.ltr,
                            hintText: 'identificationNumber',
                            controller:
                                controller.identificationNumberController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                            ],
                            onChanged: (v) {
                              controller.textErrorLogin.value = '';
                              if (validateIdentificationNumber) {
                                if (v.toString().isNotEmpty) {
                                  setState(() {
                                    validateIdentificationNumber = false;
                                  });
                                }
                              }
                              controller.checkRegistrationFieldsFull(
                                firstName: controller.firstNameController.text,
                                lastName: controller.lastNameController.text,
                                middleName:
                                    controller.middleNameController.text,
                                password: controller.passwordController.text,
                                confirmPassword:
                                    controller.confirmPasswordController.text,
                                identificationNumber: controller
                                    .identificationNumberController
                                    .text,
                                commercialRegistrationNo: controller
                                    .commercialRegistrationNoController
                                    .text,
                              );
                            },
                            errorText: validateIdentificationNumber
                                ? 'pleaseEnterTheIDNumber'.tr
                                : null,
                            textInputType: TextInputType.number,
                          ),
                          SizedBox(height: Get.height * .015),
                          Row(
                            children: [
                              widgetText(
                                context,
                                'idCardPhoto'.tr,
                                fontSize: Get.width * .035,
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height * .015),
                          controller.imageIdentificationNumberBase64 != null
                              ? widgetUploadImage(
                                  context,
                                  buttonText: 'editFile'.tr,
                                  textNextButton: '',
                                  onPressed: () async {
                                    showDialogUploadImageFromGalleryOrCameraIdentificationNumber();
                                  },
                                )
                              : widgetUploadImage(
                                  context,
                                  buttonText: 'chooseFile'.tr,
                                  textNextButton: 'noFileChosen'.tr,
                                  onPressed: () async {
                                    showDialogUploadImageFromGalleryOrCameraIdentificationNumber();
                                  },
                                ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: controller.showCommercialRegistrationNo.value,
                      child: Column(
                        children: [
                          widgetTextForm(
                            context,
                            textDirection: TextDirection.ltr,
                            hintText: 'commercialRegistrationNo',
                            controller:
                                controller.commercialRegistrationNoController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                            ],
                            onChanged: (v) {
                              controller.textErrorLogin.value = '';
                              if (validateTheCommercialRegistrationNo) {
                                if (v.toString().isNotEmpty) {
                                  setState(() {
                                    validateTheCommercialRegistrationNo = false;
                                  });
                                }
                              }
                              controller.checkRegistrationFieldsFull(
                                firstName: controller.firstNameController.text,
                                lastName: controller.lastNameController.text,
                                middleName:
                                    controller.middleNameController.text,
                                password: controller.passwordController.text,
                                confirmPassword:
                                    controller.confirmPasswordController.text,
                                identificationNumber: controller
                                    .identificationNumberController
                                    .text,
                                commercialRegistrationNo: controller
                                    .commercialRegistrationNoController
                                    .text,
                              );
                            },
                            errorText: validateTheCommercialRegistrationNo
                                ? 'pleaseEnterTheCommercialRegistrationNo'.tr
                                : null,
                            textInputType: TextInputType.number,
                          ),
                          SizedBox(height: Get.height * .015),
                          Row(
                            children: [
                              Expanded(
                                child: widgetText(
                                  context,
                                  'ACopyOfTheCommercialRegister'.tr,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height * .015),
                          controller.imageCommercialRegistrationNoBase64 != null
                              ? widgetUploadImage(
                                  context,
                                  buttonText: 'editFile'.tr,
                                  textNextButton: '',
                                  onPressed: () async {
                                    controller.textErrorLogin.value = '';
                                    showDialogUploadImageFromGalleryOrCameraCommercialRegistrationNo();
                                  },
                                )
                              : widgetUploadImage(
                                  context,
                                  buttonText: 'chooseFile'.tr,
                                  textNextButton: 'noFileChosen'.tr,
                                  onPressed: () async {
                                    showDialogUploadImageFromGalleryOrCameraCommercialRegistrationNo();
                                  },
                                ),
                        ],
                      ),
                    ),
                    SizedBox(height: Get.height * .015),
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            side: BorderSide(
                              color: controller.checkboxIsFalse.value
                                  ? redColor
                                  : const Color(0xff000000),
                            ),
                            value: controller.checkbox.value,
                            activeColor: greenColor,
                            onChanged: (value) {
                              controller.checkbox.value = value!;
                              controller.checkboxIsFalse.value = false;
                              setState(() {});
                            },
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                widgetText(
                                  context,
                                  'iAgreeTo'.tr,
                                  fontSize: Get.width * .04,
                                ),
                                InkWell(
                                  onTap: () async {
                                    // todo wen need api for privacy and usage policy
                                    if (controller
                                        .privacyBaseInfo
                                        .value
                                        .isNotEmpty) {
                                      Get.bottomSheet(
                                        Container(
                                          height: Get.height * .7,
                                          color: themeModeValue == 'light'
                                              ? Colors.white
                                              : darkColor,
                                          child: Column(
                                            children: [
                                              AppBar(
                                                backgroundColor:
                                                    themeModeValue == 'light'
                                                    ? Colors.white
                                                    : darkColor,
                                                leading: IconButton(
                                                  onPressed: () => Get.back(),
                                                  icon: Icon(
                                                    Icons.close,
                                                    color:
                                                        themeModeValue ==
                                                            'light'
                                                        ? darkColor
                                                        : Colors.white,
                                                  ),
                                                ),
                                                title: widgetText(
                                                  context,
                                                  'privacyAndUsagePolicy'.tr,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      themeModeValue == 'light'
                                                      ? darkColor
                                                      : Colors.white,
                                                  textAlign: TextAlign.start,
                                                ),
                                                elevation: 0.0,
                                                centerTitle: true,
                                              ),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  padding: EdgeInsets.all(
                                                    Get.width * .03,
                                                  ),
                                                  child: widgetText(
                                                    context,
                                                    controller
                                                        .privacyBaseInfo
                                                        .value,
                                                    fontSize: Get.width * .035,
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: widgetText(
                                    context,
                                    'privacyAndUsagePolicy'.tr,
                                    color: greenColor,
                                    fontSize: Get.width * .04,
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: controller.checkboxIsFalse.value,
                              child: widgetText(
                                context,
                                'pleaseAgreeToPrivacyAndUsagePolicy'.tr,
                                color: redColor,
                                fontSize: Get.width * .038,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.textErrorLogin.value != '',
                        child: Column(
                          children: [
                            widgetText(
                              context,
                              controller.textErrorLogin.value.tr,
                              color: redColor,
                              fontSize: Get.width * .03,
                            ),
                            SizedBox(height: Get.height * .01),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Obx(
                          () => widgetButton(
                            context,
                            'ok'.tr,
                            colorButton:
                                controller.isRegistrationFieldsFull.value
                                ? greenColor
                                : greyDarkColor,
                            colorText: controller.isRegistrationFieldsFull.value
                                ? Colors.white
                                : darkColor,
                            isProgress: controller.isProgress.value,
                            onTap: () {
                              if (controller.firstNameController.text.isEmpty ||
                                  controller
                                      .middleNameController
                                      .text
                                      .isEmpty ||
                                  controller.lastNameController.text.isEmpty ||
                                  userAccountTypesValue == null ||
                                  (controller
                                          .identificationNumberController
                                          .text
                                          .isEmpty &&
                                      controller
                                          .commercialRegistrationNoController
                                          .text
                                          .isEmpty) ||
                                  !controller.checkbox.value) {
                                if (controller
                                    .firstNameController
                                    .text
                                    .isEmpty) {
                                  setState(() {
                                    validateFirstName = true;
                                  });
                                } else {
                                  setState(() {
                                    validateFirstName = false;
                                  });
                                }
                                if (controller
                                    .middleNameController
                                    .text
                                    .isEmpty) {
                                  setState(() {
                                    validateMiddleName = true;
                                  });
                                } else {
                                  setState(() {
                                    validateMiddleName = false;
                                  });
                                }
                                if (controller
                                    .lastNameController
                                    .text
                                    .isEmpty) {
                                  setState(() {
                                    validateLastName = true;
                                  });
                                } else {
                                  setState(() {
                                    validateLastName = false;
                                  });
                                }
                                if (userAccountTypesValue == null) {
                                  setState(() {
                                    validateUserAccountType = true;
                                  });
                                } else {
                                  setState(() {
                                    validateUserAccountType = false;
                                  });
                                }
                                if (controller.showIdentification.value) {
                                  if (controller
                                      .identificationNumberController
                                      .text
                                      .isEmpty) {
                                    setState(() {
                                      validateIdentificationNumber = true;
                                    });
                                  } else {
                                    setState(() {
                                      validateIdentificationNumber = false;
                                    });
                                  }
                                }
                                if (controller
                                    .showCommercialRegistrationNo
                                    .value) {
                                  if (controller
                                      .commercialRegistrationNoController
                                      .text
                                      .isEmpty) {
                                    setState(() {
                                      validateTheCommercialRegistrationNo =
                                          true;
                                    });
                                  } else {
                                    setState(() {
                                      validateTheCommercialRegistrationNo =
                                          false;
                                    });
                                  }
                                }
                                if (!controller.checkbox.value) {
                                  setState(() {
                                    controller.checkboxIsFalse.value = true;
                                  });
                                } else {
                                  setState(() {
                                    controller.checkboxIsFalse.value = false;
                                  });
                                }
                              } else {
                                controller.sendRegistrationPage(
                                  firstName:
                                      controller.firstNameController.text,
                                  middleName:
                                      controller.middleNameController.text,
                                  lastName: controller.lastNameController.text,
                                  identificationNumber: controller
                                      .identificationNumberController
                                      .text,
                                  commercialRegistrationNo: controller
                                      .commercialRegistrationNoController
                                      .text,
                                  password: controller.passwordController.text,
                                  phone:
                                      widget.phoneNumber ??
                                      controller.controllerPhoneNumber.text,
                                  email: controller.emailController.text,
                                  IdentityImage: controller
                                      .imageIdentificationNumberBase64,
                                );
                              }
                            },
                          ),
                        ),
                        widgetButton(
                          context,
                          'cancel'.tr,
                          onTap: () {
                            Get.back();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * .02),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future showDialogUploadImageFromGalleryOrCameraIdentificationNumber() {
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
              controller.imageIdentificationNumber == null
                  ? widgetText(
                      context,
                      'chooseAPhoto'.tr,
                      fontSize: Get.width * .025,
                      fontWeight: FontWeight.bold,
                    )
                  : widgetText(
                      context,
                      'editAPhoto'.tr,
                      fontSize: Get.width * .025,
                      fontWeight: FontWeight.bold,
                    ),
              SizedBox(height: Get.height * .01),
              controller.imageIdentificationNumber == null
                  ? Container()
                  : Container(
                      width: Get.width * .3,
                      height: Get.width * .3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: MemoryImage(
                            controller.imageIdentificationNumber,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: Get.height * .01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      XFile? file = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                      );
                      Uint8List imagebytes = await file!.readAsBytes();
                      controller.imageIdentificationNumberBase64 = base64
                          .encode(imagebytes);
                      setState(() {});
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
                      controller.imageIdentificationNumberBase64 = base64
                          .encode(imagebytes);
                      controller.imageIdentificationNumber = base64.decode(
                        controller.imageIdentificationNumberBase64,
                      );
                      setState(() {});
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
      ),
    );
  }

  Future showDialogUploadImageFromGalleryOrCameraCommercialRegistrationNo() {
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
              controller.imageCommercialRegistrationNo == null
                  ? widgetText(
                      context,
                      'chooseAPhoto'.tr,
                      fontSize: Get.width * .025,
                      fontWeight: FontWeight.bold,
                    )
                  : widgetText(
                      context,
                      'editAPhoto'.tr,
                      fontSize: Get.width * .025,
                      fontWeight: FontWeight.bold,
                    ),
              SizedBox(height: Get.height * .01),
              controller.imageCommercialRegistrationNo == null
                  ? Container()
                  : Container(
                      width: Get.width * .3,
                      height: Get.width * .3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: MemoryImage(
                            controller.imageCommercialRegistrationNo,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: Get.height * .01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      XFile? file = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                      );
                      Uint8List imagebytes = await file!.readAsBytes();
                      controller.imageCommercialRegistrationNoBase64 = base64
                          .encode(imagebytes);
                      controller.imageCommercialRegistrationNo = base64.decode(
                        controller.imageCommercialRegistrationNoBase64,
                      );
                      setState(() {});
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
                      controller.imageCommercialRegistrationNoBase64 = base64
                          .encode(imagebytes);
                      controller.imageCommercialRegistrationNo = base64.decode(
                        controller.imageCommercialRegistrationNoBase64,
                      );
                      setState(() {});
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
      ),
    );
  }

  Container widgetPhoneNumber(context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        bottom: Get.height * .017,
        left: Get.width * .01,
        right: Get.width * .01,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          themeModeValue == 'light'
              ? const BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10,
                  spreadRadius: -5,
                )
              : const BoxShadow(color: Colors.transparent),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: TextField(
          keyboardType: TextInputType.phone,
          controller: controller.controllerPhoneNumber,
          style: TextStyle(
            color: themeModeValue == 'dark' ? Colors.white : darkColor,
          ),
          textAlign: TextAlign.start,
          cursorColor: greenColor,
          decoration: InputDecoration(
            hintText: 'mobileNumber'.tr,
            filled: true,
            fillColor: (themeModeValue == 'light'
                ? Colors.white
                : buttonDarkColor),
            focusColor: greyColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                width: 16.0,
                color: themeModeValue == 'light'
                    ? greyColor
                    : Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: themeModeValue == 'light'
                    ? greyColor
                    : Colors.transparent,
              ),
            ),
            contentPadding: const EdgeInsets.only(
              bottom: 25.0,
              right: 25.0,
              left: 25.0,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: themeModeValue == 'light'
                    ? greyColor
                    : Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
