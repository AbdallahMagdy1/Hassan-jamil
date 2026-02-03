import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hj_app/view/screen/mainView.dart';

import '../../controller/loginAndRegisterControl.dart';
import '../../global/globalUI.dart';

class LoginPassWordScreen extends StatefulWidget {
  final bool isFromSplashScreen;
  final bool acrossEmail;
  final bool acrossIdentificationNumber;

  final dynamic email;
  final dynamic phone;
  final dynamic identificationNumber;

  const LoginPassWordScreen({
    super.key,
    this.isFromSplashScreen = false,
    this.acrossEmail = false,
    this.acrossIdentificationNumber = false,
    this.email,
    this.phone,
    this.identificationNumber,
  });

  @override
  State<StatefulWidget> createState() => _LoginPassWordScreenState();
}

class _LoginPassWordScreenState extends State<LoginPassWordScreen> {
  final LoginAndRegisterControl control = Get.put(LoginAndRegisterControl());
  TextEditingController controllerText = TextEditingController();
  bool obscureText = true;

  @override
  void dispose() {
    control.isPassWordNotCorrect.value = false;
    control.validation.value = true;
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
            ? SizedBox()
            : IconButton(
                onPressed: () {
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
                //     pngLoginPassWord,
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
                SizedBox(
                  width: double.infinity,
                  child: widgetText(
                    context,
                    'welcome'.tr,
                    fontWeight: FontWeight.bold,
                    fontSize: Get.width * .08,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: Get.height * .03),
                SizedBox(
                  width: double.infinity,
                  child: widgetText(
                    context,
                    'signIn'.tr,
                    fontSize: Get.width * .04,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: Get.height * .02),
                widgetTextForm(
                  context,
                  hintText: 'password'.tr,
                  controller: controllerText,
                  textDirection: TextDirection.ltr,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    icon: Icon(
                      !obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  obscureText: obscureText,
                  onChanged: (v) {
                    control.textErrorLogin.value = '';
                    if (v.length > 0) {
                      control.validation.value = true;
                      control.isPassWordNotCorrect.value = false;
                      setState(() {});
                    }
                    if (v.length < 1) {
                      control.validation.value = false;
                      setState(() {});
                    }
                  },
                ),
                Obx(
                  () => control.isPassWordNotCorrect.value
                      ? SizedBox(
                          width: double.infinity,
                          child: widgetText(
                            context,
                            'thePasswordIsIncorrect'.tr,
                            color: const Color(0xffc00000),
                            fontSize: Get.width * .035,
                            textAlign: TextAlign.start,
                          ),
                        )
                      : const SizedBox(),
                ),
                Obx(
                  () => Visibility(
                    visible: control.textErrorLogin.value != '',
                    child: SizedBox(
                      width: double.infinity,
                      child: widgetText(
                        context,
                        control.textErrorLogin.value.tr,
                        color: redColor,
                        fontSize: Get.width * .03,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: control.isPassWordNotCorrect.value
                      ? Get.height * .02
                      : Get.height * .025,
                ),
                Obx(
                  () => widgetLoginButton(
                    context,
                    'login',
                    onTap: () {
                      if (control.validation.value) {
                        if (widget.acrossEmail) {
                          control.checkEmailAndPassWordIsCorrect(
                            widget.email,
                            controllerText.text,
                            widget.isFromSplashScreen,
                          );
                        } else if (widget.acrossIdentificationNumber) {
                          control.checkIdentificationNumberAndPassWordIsCorrect(
                            widget.identificationNumber,
                            controllerText.text,
                            widget.isFromSplashScreen,
                          );
                        }
                      }
                    },
                    isProgress: control.isProgress.value,
                    backgroundColor: control.validation.value
                        ? greenColor
                        : greyDarkColor,
                  ),
                ),
                SizedBox(height: Get.height * .02),
                Obx(
                  () => control.isForgotPassword.value
                      ? SizedBox(
                          height: Get.height * .02,
                          width: Get.height * .02,
                          child: CircularProgressIndicator(color: greenColor),
                        )
                      : InkWell(
                          onTap: () {
                            control.forgotPassword(
                              widget.phone,
                              widget.isFromSplashScreen,
                            );
                          },
                          child: widgetText(
                            context,
                            'forgotYourPassword'.tr,
                            color: greenColor,
                            fontSize: Get.width * .04,
                          ),
                        ),
                ),
                SizedBox(height: Get.height * .045),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
