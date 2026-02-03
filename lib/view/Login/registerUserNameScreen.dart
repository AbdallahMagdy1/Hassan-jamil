import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/loginAndRegisterControl.dart';
import '../../global/globalUI.dart';
import '../screen/mainView.dart';
import 'loginUserNameScreen.dart';

class RegisterUserName extends StatefulWidget {
  final String? hintText;
  final dynamic textInputType;
  final dynamic inputFormatters;
  final bool isFromSplashScreen;
  final bool acrossEmail;
  final dynamic validatorError;
  final bool acrossPhoneNumber;
  final bool acrossIdentificationNumber;

  const RegisterUserName({
    super.key,
    this.hintText,
    this.textInputType,
    this.inputFormatters,
    this.isFromSplashScreen = false,
    this.acrossEmail = false,
    this.validatorError,
    this.acrossPhoneNumber = false,
    this.acrossIdentificationNumber = false,
  });

  @override
  State<StatefulWidget> createState() => _RegisterUserName2State();
}

class _RegisterUserName2State extends State<RegisterUserName> {
  TextEditingController controllerText = TextEditingController();
  final LoginAndRegisterControl controller = Get.put(LoginAndRegisterControl());
  bool validatePassWord = false;
  bool validateConfirmPassWordIsMatch = false;
  bool validateAcrossValueIsCorrect = false;

  @override
  void dispose() {
    controllerText.clear();
    controller.passwordController.clear();
    controller.confirmPasswordController.clear();
    controller.textErrorLogin.value = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeModeValue == 'light'
            ? Colors.white
            : Color(0xFF39393d),
        leading: widget.isFromSplashScreen
            ? InkWell(
                onTap: () {
                  Get.offAll(MainView());
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: greenColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: EdgeInsets.only(top: Get.height * .04),
                  height: Get.height * .035,
                  width: Get.height * .07,
                  child: widgetText(context, 'skip'.tr, color: Colors.white),
                ),
              )
            : IconButton(
                onPressed: () {
                  controller.validation.value = false;
                  controllerText.clear();
                  controller.passwordController.clear();
                  controller.confirmPasswordController.clear();
                  controller.textErrorLogin.value = '';
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios_sharp),
              ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: Get.width * .04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: Get.width * .12),
                //   child: Image.asset(
                //     pngLogoOptionRegister,
                //   ),
                // ),
                SizedBox(height: Get.height * .12),
                Image.asset(
                  themeModeValue == 'dark'
                      ? 'assets/images/hj.png'
                      : 'assets/images/hj-black.png',
                  width: Get.width * .2,
                ),
                SizedBox(height: Get.height * .02),
                Text(
                  'Hassan Jameel Motors',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: themeModeValue == 'dark' ? Colors.white : darkColor,
                  ),
                ),
                Text(
                  'حسن جميل للسيارات',
                  style: GoogleFonts.almarai(
                    fontSize: 16,
                    color: themeModeValue == 'dark' ? Colors.white : darkColor,
                  ),
                ),
                SizedBox(height: Get.height * .1),
                widgetText(
                  context,
                  'createAnAccount'.tr,
                  fontWeight: FontWeight.bold,
                  fontSize: Get.width * .04,
                ),
                SizedBox(height: Get.height * .04),
                Obx(
                  () => Visibility(
                    visible: controller.textErrorLogin.value == '',
                    child: SizedBox(height: Get.height * .015),
                  ),
                ),
                SizedBox(height: Get.height * .04),
                widgetTextForm(
                  context,
                  controller: controllerText,
                  hintText: widget.hintText,
                  centerAlign: true,
                  textDirection: TextDirection.ltr,
                  textInputType: widget.textInputType,
                  inputFormatters: widget.inputFormatters,
                  validatorError: widget.validatorError,
                  onChanged: (v) {
                    controller.textErrorLogin.value = '';
                    controller.validation.value = true;
                    if (widget.acrossIdentificationNumber) {
                      if (v.length > 9) {
                        validateAcrossValueIsCorrect = true;
                        setState(() {});
                      } else {
                        validateAcrossValueIsCorrect = false;
                        setState(() {});
                      }
                    }
                    validatePhoneNumber(v);
                    if (widget.acrossEmail) {
                      if (validateEmail(v)) {
                        validateAcrossValueIsCorrect = true;
                        setState(() {});
                      } else {
                        validateAcrossValueIsCorrect = false;
                        setState(() {});
                      }
                    }
                  },
                ),
                if (widget.acrossEmail) ...[
                  widgetTextForm(
                    context,
                    hintText: 'EnterThePassword',
                    centerAlign: true,
                    controller: controller.passwordController,
                    onChanged: (v) {
                      controller.validation.value = true;
                      if (v.toString() ==
                          controller.confirmPasswordController.text) {
                        setState(() {
                          validateConfirmPassWordIsMatch = false;
                        });
                      } else {
                        setState(() {
                          validateConfirmPassWordIsMatch = true;
                          controller.validation.value = false;
                        });
                      }
                    },
                    errorText: validatePassWord
                        ? 'pleaseEnterThePassword'.tr
                        : null,
                    obscureText: true,
                  ),
                  widgetTextForm(
                    context,
                    hintText: 'confirmPassword',
                    centerAlign: true,
                    controller: controller.confirmPasswordController,
                    onChanged: (v) {
                      controller.validation.value = true;
                      if (v.toString() == controller.passwordController.text) {
                        setState(() {
                          validateConfirmPassWordIsMatch = false;
                        });
                      } else {
                        setState(() {
                          validateConfirmPassWordIsMatch = true;
                          controller.validation.value = false;
                        });
                      }
                    },
                    errorText: (validateConfirmPassWordIsMatch)
                        ? ('thePasswordConfirmDoesNotMatch'.tr)
                        : null,
                    obscureText: true,
                  ),
                ],
                Obx(
                  () => Visibility(
                    visible: controller.textErrorLogin.value != '',
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            widgetText(
                              context,
                              controller.textErrorLogin.value.tr,
                              color: redColor,
                              fontSize: Get.width * .03,
                            ),
                          ],
                        ),
                        SizedBox(height: Get.height * .01),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => widgetLoginButton(
                    context,
                    'createAnAccount',
                    onTap: () {
                      if (validateAcrossValueIsCorrect &&
                          controller.validation.value) {
                        if (widget.acrossPhoneNumber) {
                          controller.RegisterAcrossPhoneNumber(
                            validatePhoneNumber(controllerText.text) ?? '',
                            widget.isFromSplashScreen,
                          );
                          return;
                        }
                        if (widget.acrossIdentificationNumber) {
                          controller.RegisterAcrossIdentificationNumber(
                            controllerText.text,
                          );
                          return;
                        }
                        if (!validateConfirmPassWordIsMatch &&
                            controller.passwordController.text.isNotEmpty) {
                          if (widget.acrossEmail) {
                            controller.RegisterAcrossEmail(controllerText.text);
                          }
                        }
                      }
                    },
                    backgroundColor:
                        !validateConfirmPassWordIsMatch &&
                            validateAcrossValueIsCorrect &&
                            controller.passwordController.text.isNotEmpty &&
                            controller.validation.value
                        ? greenColor
                        : greyDarkColor,
                    isProgress: controller.isProgress.value,
                    fontSize: Get.width * .04,
                  ),
                ),
                SizedBox(
                  height: validateConfirmPassWordIsMatch
                      ? Get.height * .01
                      : Get.height * .04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validatePhoneNumber(String v) {
    if (widget.acrossPhoneNumber) {
      if (v.length == 10 && v.toString().startsWith('0')) {
        v = v.toString().replaceFirst('0', '');
      }
      if (v.length == 9) {
        validateAcrossValueIsCorrect = true;
        setState(() {});
        return v.trim();
      } else {
        validateAcrossValueIsCorrect = false;
        setState(() {});
      }
    }

    return null;
  }

  Container widgetPhoneNumber(context, hintText, {textFieldController}) {
    return Container(
      height: Get.height * .065,
      margin: EdgeInsets.only(left: Get.width * .01, right: Get.width * .01),
      decoration: BoxDecoration(
        color: themeModeValue == 'light' ? Colors.white : buttonDarkColor,
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: -2),
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: TextField(
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            if (controller.passwordController.text ==
                    controller.confirmPasswordController.text &&
                controller.passwordController.text.isNotEmpty) {
              controller.validation.value = true;
              validateAcrossValueIsCorrect = true;
              setState(() {});
            } else {
              controller.validation.value = false;
              validateAcrossValueIsCorrect = false;
              setState(() {});
            }
          },
          style: TextStyle(
            color: themeModeValue == 'dark' ? Colors.white : darkColor,
          ),
          controller: textFieldController,
          decoration: InputDecoration(
            hintText: '$hintText'.tr,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 5.0),
            ),
          ),
        ),
      ),
    );
  }
}
