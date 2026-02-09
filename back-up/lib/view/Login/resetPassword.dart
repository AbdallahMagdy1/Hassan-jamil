import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/verificationController.dart';
import '../../global/globalUI.dart';

class ResetPassword extends StatefulWidget {
  final bool isFromSplashScreen;
  final bool acrossEmail;
  final bool acrossIdentificationNumber;

  final dynamic email;
  final dynamic phone;
  final dynamic identificationNumber;

  const ResetPassword({
    super.key,
    this.isFromSplashScreen = false,
    this.acrossEmail = false,
    this.acrossIdentificationNumber = false,
    this.email,
    this.phone,
    this.identificationNumber,
  });

  @override
  State<StatefulWidget> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final VerificationControl control = Get.put(VerificationControl());
  TextEditingController controllerNewPassword = TextEditingController();
  TextEditingController controllerConfirmPassword = TextEditingController();
  bool obscureText = true;
  bool obscureTextRe = true;

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
                Get.back();
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
                //     pngResetPassword,
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
                    'resetPassword'.tr,
                    fontWeight: FontWeight.bold,
                    fontSize: Get.width * .050,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: Get.height * .03),
                widgetTextForm(
                  context,
                  hintText: 'newPassword'.tr,
                  controller: controllerNewPassword,
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
                    if (controllerNewPassword.text !=
                            controllerConfirmPassword.text &&
                        controllerNewPassword.text.isNotEmpty) {
                      control.validation.value = false;
                      setState(() {});
                    } else if (controllerNewPassword.text ==
                            controllerConfirmPassword.text &&
                        controllerNewPassword.text.isNotEmpty) {
                      control.validation.value = true;
                      setState(() {});
                    }
                  },
                ),
                SizedBox(height: Get.height * .0005),
                widgetTextForm(
                  context,
                  hintText: 'confirmPassword'.tr,
                  controller: controllerConfirmPassword,
                  textDirection: TextDirection.ltr,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureTextRe = !obscureTextRe;
                      });
                    },
                    icon: Icon(
                      !obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  obscureText: obscureTextRe,
                  onChanged: (v) {
                    if (controllerNewPassword.text ==
                            controllerConfirmPassword.text &&
                        controllerNewPassword.text.isNotEmpty) {
                      control.validation.value = true;
                      setState(() {});
                    } else {
                      control.validation.value = false;
                      setState(() {});
                    }
                  },
                ),
                SizedBox(height: Get.height * .01),
                Obx(
                  () => widgetLoginButton(
                    context,
                    'reset',
                    onTap: () {
                      if (control.validation.value) {
                        control.updatePassWordAcrossEmail(
                          context,
                          widget.phone,
                          controllerConfirmPassword.text,
                        );
                      }
                    },
                    isProgress: control.isProgress.value,
                    backgroundColor: control.validation.value
                        ? greenColor
                        : greyDarkColor,
                    fontSize: Get.width * .035,
                  ),
                ),
                SizedBox(height: Get.height * .04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
