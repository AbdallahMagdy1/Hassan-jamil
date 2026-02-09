import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hj_app/view/screen/mainView.dart';
import '../../controller/loginAndRegisterControl.dart';
import '../../global/globalUI.dart';

class LoginUserName extends StatefulWidget {
  final bool isFromSplashScreen;

  const LoginUserName({super.key, this.isFromSplashScreen = false});

  @override
  State<StatefulWidget> createState() => _LoginUserName2State();
}

class _LoginUserName2State extends State<LoginUserName> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerText = TextEditingController();
  final LoginAndRegisterControl controller = Get.put(LoginAndRegisterControl());
  bool acrossPhoneNumber = false;
  bool acrossEmail = false;
  bool acrossIdentificationNumber = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.isProgress.value = false;
      controller.isProgressCreateAccount.value = false;
    });
    super.initState();
  }

  String? validatorError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeModeValue == 'light'
            ? Colors.white
            : Color(0xFF39393d),
        leading: widget.isFromSplashScreen
            ? SizedBox()
            : IconButton(
                onPressed: () {
                  controller.validation.value = false;
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios_sharp),
              ),
        actions: [
          if (widget.isFromSplashScreen) ...[
            ElevatedButton(
              onPressed: () {
                Get.offAll(MainView());
              },
              child: widgetText(context, 'skip'.tr, color: Colors.white),
            ),
          ],
          SizedBox(width: Get.width * .02),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: Get.width * .04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: Get.width * .12),
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
                      color: themeModeValue == 'dark'
                          ? Colors.white
                          : darkColor,
                    ),
                  ),
                  Text(
                    'حسن جميل للسيارات',
                    style: GoogleFonts.almarai(
                      fontSize: 16,
                      color: themeModeValue == 'dark'
                          ? Colors.white
                          : darkColor,
                    ),
                  ),
                  SizedBox(height: Get.height * .1),
                  SizedBox(
                    width: double.infinity,
                    child: widgetText(
                      context,
                      'welcome'.tr,
                      fontSize: Get.width * .08,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(height: Get.height * .06),
                  SizedBox(
                    width: double.infinity,
                    child: widgetText(
                      context,
                      'signIn'.tr,
                      fontSize: Get.width * .04,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(height: Get.height * .015),
                  widgetTextForm(
                    context,
                    controller: controllerText,
                    hintText: 'ID_MobileNumber_Email',
                    validatorError: validatorError,
                    textDirection: TextDirection.ltr,
                    onChanged: (v) {
                      controller.textErrorLogin.value = '';
                      if (v.toString().contains(RegExp(r'[a-z]'))) {
                        if (validateEmail(v)) {
                          validatorError = 'pleaseEnterTheEmail'.tr;
                          acrossPhoneNumber = false;
                          acrossEmail = true;
                          acrossIdentificationNumber = false;
                          controller.validation.value = true;
                          setState(() {});
                        } else {
                          controller.validation.value = false;
                          setState(() {});
                        }
                      } else {
                        if (v.length > 8 && v.length < 11) {
                          if (v.length == 9) {
                            validatorError = 'pleaseEnterThePhoneNumber';
                            acrossPhoneNumber = true;
                            acrossEmail = false;
                            acrossIdentificationNumber = false;
                            controller.validation.value = true;
                            setState(() {});
                          }
                          if (v.length == 10) {
                            validatorError = 'pleaseEnterTheIDNumber'.tr;
                            acrossPhoneNumber = false;
                            acrossEmail = false;
                            acrossIdentificationNumber = true;
                            controller.validation.value = true;
                            setState(() {});
                          }
                          controller.validation.value = true;
                          setState(() {});
                        } else {
                          acrossPhoneNumber = false;
                          acrossEmail = false;
                          acrossIdentificationNumber = false;
                          controller.validation.value = false;
                          setState(() {});
                        }
                      }
                    },
                  ),
                  Obx(
                    () => Visibility(
                      visible: controller.textErrorLogin.value != '',
                      child: SizedBox(
                        width: double.infinity,
                        child: widgetText(
                          context,
                          controller.textErrorLogin.value.tr,
                          color: redColor,
                          fontSize: Get.width * .03,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      height: controller.textErrorLogin.value != ''
                          ? Get.height * .01
                          : Get.height * .025,
                    ),
                  ),
                  Obx(
                    () => widgetLoginButton(
                      context,
                      'continue',
                      backgroundColor: controller.validation.value
                          ? greenColor
                          : greyDarkColor,
                      isProgress: controller.isProgress.value,
                      fontSize: Get.width * .04,
                      onTap: () {
                        final form = _formKey.currentState;
                        if (controller.validation.value) {
                          if (form!.validate()) {
                            if (acrossPhoneNumber) {
                              controller.sendLoginAcrossPhoneNumber(
                                controllerText.text.trim(),
                                widget.isFromSplashScreen,
                              );
                            }
                            if (acrossEmail) {
                              controller.checkEmailIsFound(
                                controllerText.text,
                                widget.isFromSplashScreen,
                              );
                            } else if (acrossIdentificationNumber) {
                              controller.sendLoginAcrossIdentityNo(
                                controllerText.text,
                                widget.isFromSplashScreen,
                              );
                            }
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: Get.height * .015),
                  Obx(
                    () => controller.isProgressCreateAccount.value
                        ? SizedBox(
                            height: Get.height * .024,
                            width: Get.height * .024,
                            child: CircularProgressIndicator(color: greenColor),
                          )
                        : InkWell(
                            onTap: () {
                              controller.getUserAccountTypes(
                                'numberPhone'.tr,
                                widget.isFromSplashScreen,
                              );
                            },
                            child: widgetText(
                              context,
                              'createAnAccount'.tr,
                              color: greenColor,
                              fontSize: Get.width * .04,
                            ),
                          ),
                  ),
                  SizedBox(height: Get.height * .035),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

bool validateEmail(String value) {
  var pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}
