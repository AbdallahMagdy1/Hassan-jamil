import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hj_app/controller/profileController.dart';
import 'package:image_picker/image_picker.dart';
import '../../global/globalUI.dart';

class EditProfileDetails extends StatefulWidget {
  const EditProfileDetails({super.key});

  @override
  State<StatefulWidget> createState() => _EditProfileDetailsState();
}

class _EditProfileDetailsState extends State<EditProfileDetails> {
  var controller = Get.put(ProfileController());

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
          'editProfile'.tr,
          color: themeModeValue == 'light' ? darkColor : Colors.white,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: Get.height * .02),
                SizedBox(height: Get.height * .02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        controller.imageProfileBase64 == null
                            ? Container(
                                width: Get.width * .3,
                                height: Get.width * .3,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(pngCharacter),
                                  ),
                                ),
                              )
                            : Container(
                                width: Get.width * .3,
                                height: Get.width * .3,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: MemoryImage(
                                      base64.decode(
                                        controller.imageProfileBase64,
                                      ),
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
                              shape: CircleBorder(
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
                  ],
                ),
                SizedBox(height: Get.height * .07),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width * .43,
                      child: widgetTextForm(
                        context,
                        controller: controller.controllerFistName,
                        errorText: controller.validateFirstName.value
                            ? 'pleaseEnterFirstName'.tr
                            : null,
                        onChanged: (v) {
                          if (controller.controllerFistName.text.isEmpty) {
                            controller.validateFirstName.value = true;
                            setState(() {});
                          } else if (controller
                              .controllerFistName
                              .text
                              .isNotEmpty) {
                            controller.validateFirstName.value = false;
                            setState(() {});
                          }
                        },
                        hintText: 'firstName'.tr,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * .43,
                      child: widgetTextForm(
                        context,
                        controller: controller.controllerMiddleName,
                        errorText: controller.validateMiddleName.value
                            ? 'pleaseEnterMiddleName'.tr
                            : null,
                        onChanged: (v) {
                          if (controller.controllerMiddleName.text.isEmpty) {
                            controller.validateMiddleName.value = true;
                            setState(() {});
                          } else if (controller
                              .controllerMiddleName
                              .text
                              .isNotEmpty) {
                            controller.validateMiddleName.value = false;
                            setState(() {});
                          }
                        },
                        hintText: 'middleName'.tr,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width * .43,
                      child: widgetTextForm(
                        context,
                        controller: controller.controllerGrandFatherName,
                        errorText: controller.validateGrandFatherName.value
                            ? 'pleaseEnterGrandfatherName'.tr
                            : null,
                        onChanged: (v) {
                          if (controller
                              .controllerGrandFatherName
                              .text
                              .isEmpty) {
                            controller.validateGrandFatherName.value = true;
                            setState(() {});
                          } else if (controller
                              .controllerGrandFatherName
                              .text
                              .isNotEmpty) {
                            controller.validateGrandFatherName.value = false;
                            setState(() {});
                          }
                        },
                        hintText: 'grandfatherName'.tr,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * .43,
                      child: widgetTextForm(
                        context,
                        controller: controller.controllerLastName,
                        errorText: controller.validateLastName.value
                            ? 'pleaseEnterLastName'.tr
                            : null,
                        onChanged: (v) {
                          if (controller.controllerLastName.text.isEmpty) {
                            controller.validateLastName.value = true;
                            setState(() {});
                          } else if (controller
                              .controllerLastName
                              .text
                              .isNotEmpty) {
                            controller.validateLastName.value = false;
                            setState(() {});
                          }
                        },
                        hintText: 'lastName'.tr,
                      ),
                    ),
                  ],
                ),
                widgetPhoneNumber(context),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: widgetTextForm(
                        context,
                        controller: controller.controllerIdentityNumber,
                        textInputType: TextInputType.number,
                        errorText: controller.validateIDNumber.value
                            ? 'pleaseEnterTheIDNumber'.tr
                            : null,
                        onChanged: (v) {
                          if (controller.controllerIdentityNumber.text.length <
                              10) {
                            controller.validateIDNumber.value = true;
                            setState(() {});
                          } else if (controller
                                  .controllerIdentityNumber
                                  .text
                                  .length >
                              9) {
                            controller.validateIDNumber.value = false;
                            setState(() {});
                          }
                        },
                        textDirection: TextDirection.ltr,
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        hintText: 'identificationNumber'.tr,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: Get.height * .06,
                        margin: EdgeInsets.only(
                          bottom: Get.height * .015,
                          left: Get.width * .01,
                          right: Get.width * .01,
                        ),
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5,
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            showDialogUploadImageFromGalleryOrCameraForIdentificationNumber();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeModeValue == 'light'
                                  ? Colors.white
                                  : buttonDarkColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(Get.width * .01),
                              child: Row(
                                children: [
                                  Expanded(
                                    child:
                                        controller.imageidentityBase64 == null
                                        ? widgetText(
                                            context,
                                            'insertPhotoID'.tr,
                                            fontSize: Get.width * .025,
                                          )
                                        : widgetText(
                                            context,
                                            'editPhotoID'.tr,
                                            fontSize: Get.width * .025,
                                          ),
                                  ),
                                  Image.asset(pngInsertPhotoID),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                widgetTextForm(
                  context,
                  controller: controller.controllerEmail,
                  errorText: controller.validateEmail.value
                      ? 'pleaseEnterTheEmail'.tr
                      : null,
                  onChanged: (v) {
                    if (!controller.controllerEmail.text.isEmail) {
                      controller.validateEmail.value = true;
                      setState(() {});
                    } else if (controller.controllerEmail.text.isEmail) {
                      controller.validateEmail.value = false;
                      setState(() {});
                    }
                  },
                  textDirection: TextDirection.ltr,
                  hintText: 'email'.tr,
                ),
                widgetTextForm(
                  context,
                  controller: controller.controllerAddress,
                  errorText: controller.validateTheAddress.value
                      ? 'pleaseEnterTheAddress'.tr
                      : null,
                  onChanged: (v) {
                    if (controller.controllerAddress.text.isEmpty) {
                      controller.validateTheAddress.value = true;
                      setState(() {});
                    } else if (controller.controllerAddress.text.isNotEmpty) {
                      controller.validateTheAddress.value = false;
                      setState(() {});
                    }
                  },
                  hintText: 'theAddress'.tr,
                ),
                Obx(
                  () => widgetButton(
                    context,
                    'save'.tr,
                    colorText:
                        (controller.controllerFistName.text.isEmpty ||
                            controller.controllerMiddleName.text.isEmpty ||
                            controller.controllerGrandFatherName.text.isEmpty ||
                            controller.controllerLastName.text.isEmpty ||
                            controller.controllerIdentityNumber.text.length <
                                10 ||
                            controller.controllerAddress.text.isEmpty)
                        ? darkColor
                        : Colors.white,
                    colorButton:
                        (controller.controllerFistName.text.isEmpty ||
                            controller.controllerMiddleName.text.isEmpty ||
                            controller.controllerGrandFatherName.text.isEmpty ||
                            controller.controllerLastName.text.isEmpty ||
                            controller.controllerIdentityNumber.text.length <
                                10 ||
                            controller.controllerAddress.text.isEmpty)
                        ? greyDarkColor
                        : greenColor,
                    fontSize: Get.width * .035,
                    fontWeight: FontWeight.bold,
                    width: Get.width * .9,
                    onTap: () {
                      if (controller.controllerFistName.text.isEmpty ||
                          controller.controllerMiddleName.text.isEmpty ||
                          controller.controllerGrandFatherName.text.isEmpty ||
                          controller.controllerLastName.text.isEmpty ||
                          controller.controllerIdentityNumber.text.length <
                              10 ||
                          controller.controllerAddress.text.isEmpty) {
                        if (controller.controllerFistName.text.isEmpty) {
                          controller.validateFirstName.value = true;
                          setState(() {});
                        } else if (controller
                            .controllerFistName
                            .text
                            .isNotEmpty) {
                          controller.validateFirstName.value = false;
                          setState(() {});
                        }
                        if (controller.controllerMiddleName.text.isEmpty) {
                          controller.validateMiddleName.value = true;
                          setState(() {});
                        } else if (controller
                            .controllerMiddleName
                            .text
                            .isNotEmpty) {
                          controller.validateMiddleName.value = false;
                          setState(() {});
                        }
                        if (controller.controllerGrandFatherName.text.isEmpty) {
                          controller.validateGrandFatherName.value = true;
                          setState(() {});
                        } else if (controller
                            .controllerGrandFatherName
                            .text
                            .isNotEmpty) {
                          controller.validateGrandFatherName.value = false;
                          setState(() {});
                        }
                        if (controller.controllerLastName.text.isEmpty) {
                          controller.validateLastName.value = true;
                          setState(() {});
                        } else if (controller
                            .controllerLastName
                            .text
                            .isNotEmpty) {
                          controller.validateLastName.value = false;
                          setState(() {});
                        }
                        if (controller.controllerIdentityNumber.text.length <
                            10) {
                          controller.validateIDNumber.value = true;
                          setState(() {});
                        } else if (controller
                                .controllerIdentityNumber
                                .text
                                .length >
                            9) {
                          controller.validateIDNumber.value = false;
                          setState(() {});
                        }
                        if (controller.controllerAddress.text.isEmpty) {
                          controller.validateTheAddress.value = true;
                          setState(() {});
                        } else if (controller
                            .controllerAddress
                            .text
                            .isNotEmpty) {
                          controller.validateTheAddress.value = false;
                          setState(() {});
                        }
                      } else {
                        controller.isProgress.value = true;
                        controller.updateProfile(
                          firstName: controller.controllerFistName.text,
                          middleName: controller.controllerMiddleName.text,
                          grandFatherName:
                              controller.controllerGrandFatherName.text,
                          lastName: controller.controllerLastName.text,
                          logo: controller.imageProfileBase64,
                          email: controller.controllerEmail.text,
                          identificationNumber:
                              controller.controllerIdentityNumber.text,
                          identityImage: controller.imageidentityBase64,
                          address: controller.controllerAddress.text,
                        );
                      }
                    },
                    isProgress: controller.isProgress.value,
                  ),
                ),
                SizedBox(height: Get.height * .05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container widgetPhoneNumber(context) {
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
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: TextField(
            keyboardType: TextInputType.phone,
            controller: controller.controllerPhoneNumber,
            readOnly: true,
            style: TextStyle(
              color: themeModeValue == 'dark' ? Colors.white : darkColor,
            ),
          ),
        ),
      ),
    );
  }

  Future showDialogUploadImageFromGalleryOrCamera() {
    return Get.dialog(
      AlertDialog(
        backgroundColor: themeModeValue == 'light' ? Colors.white : darkColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        contentPadding: EdgeInsets.only(top: 10.0),
        content: Container(
          child: Column(
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
                      controller.imageProfileBase64 = base64.encode(imagebytes);

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

  Future showDialogUploadImageFromGalleryOrCameraForIdentificationNumber() {
    return Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        contentPadding: EdgeInsets.only(top: 10.0),
        content: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: Get.height * .02),
              controller.imageidentityBase64 == null
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
              controller.imageidentityBase64 == null
                  ? Container()
                  : Container(
                      width: Get.width * .3,
                      height: Get.width * .3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: MemoryImage(
                            base64.decode(controller.imageidentityBase64),
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
                      controller.imageidentityBase64 = base64.encode(
                        imagebytes,
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
                      controller.imageidentityBase64 = base64.encode(
                        imagebytes,
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
}
