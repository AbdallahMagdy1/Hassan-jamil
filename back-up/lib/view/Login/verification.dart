import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/loginAndRegisterControl.dart';
import '../../controller/verificationController.dart';
import '../../global/PinPut.dart';
import '../../global/globalUI.dart';

class Verification extends StatefulWidget {
  final String phoneNumber;
  final bool isFromSplashScreen;
  final bool isForgetPassWord;
  final int verificationCodeFromFunction;
  final bool acrossEmail;

  const Verification(
    this.phoneNumber, {
    super.key,
    required this.verificationCodeFromFunction,
    this.acrossEmail = false,
    this.isFromSplashScreen = false,
    this.isForgetPassWord = false,
  });

  @override
  State<StatefulWidget> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  TextEditingController verificationCode = TextEditingController();
  final VerificationControl control = Get.put(VerificationControl());
  final LoginAndRegisterControl controlLoginAndRegister = Get.put(
    LoginAndRegisterControl(),
  );

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
                //     pngVerificationConfirm,
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
                    'verification'.tr,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: Get.height * .005),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'checkYourTextMessages'.tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Get.width * .05,
                    ),
                  ),
                ),
                SizedBox(height: Get.height * .05),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'weHaveSentYouTheCode'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: Get.width * .04,
                    ),
                  ),
                ),
                SizedBox(height: Get.height * .005),
                widgetText(
                  context,
                  widget.acrossEmail
                      ? widget.phoneNumber.toString().replaceRange(
                          0,
                          (widget.phoneNumber.length - 2),
                          '*' * (widget.phoneNumber.length - 2),
                        )
                      : '+966${widget.phoneNumber.toString().replaceRange(0, (widget.phoneNumber.length - 2), '*' * (widget.phoneNumber.length - 2))}',
                  color: blueColor,
                  textDirection: TextDirection.ltr,
                ),
                SizedBox(height: Get.height * .008),
                Container(
                  width: Get.width * .7,
                  height: Get.height * .0008,
                  color: greyColor3,
                ),
                SizedBox(height: Get.height * .013),
                Text(
                  'enterTheCode'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: Get.width * .04,
                  ),
                ),
                SizedBox(height: Get.height * .013),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * .1),
                    child: FilledRoundedPinPut(verificationCode, (v) {
                      control.textErrorLogin.value = '';
                      if (v.toString().length > 3) {
                        control.validation.value = true;
                      } else {
                        control.validation.value = false;
                      }
                    }),
                  ),
                ),
                SizedBox(height: Get.height * .008),
                TweenAnimationBuilder<Duration>(
                  duration: const Duration(seconds: 60),
                  tween: Tween(
                    begin: const Duration(seconds: 60),
                    end: Duration.zero,
                  ),
                  onEnd: () {
                    control.validation.value = true;
                    controlLoginAndRegister.validation.value = true;
                    control.canResend.value = true;
                  },
                  builder: (BuildContext context, Duration value, Widget? child) {
                    final minutes = value.inMinutes;
                    final seconds = value.inSeconds % 60;
                    return Text(
                      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: Get.width * .05),
                    );
                  },
                ),
                Obx(
                  () => Visibility(
                    visible: control.textErrorLogin.value != '',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        widgetText(
                          context,
                          control.textErrorLogin.value.tr,
                          color: redColor,
                          fontSize: Get.width * .03,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Get.height * .005),
                Obx(
                  () => widgetLoginButton(
                    context,
                    'continue',
                    backgroundColor: control.validation.value
                        ? greenColor
                        : greyDarkColor,
                    onTap: () {
                      if (control.validation.value) {
                        if (verificationCode.text.isNotEmpty &&
                            widget.verificationCodeFromFunction ==
                                int.parse(verificationCode.text)) {
                          control.getUserAccountTypes2(
                            context,
                            widget.phoneNumber,
                          );
                          control.isProgress.value = false;
                          control.validation.value = false;
                          if (widget.isForgetPassWord) {
                            control.checkVerificationForForgetPassword(
                              context,
                              widget.phoneNumber,
                              verificationCode.text,
                            );
                          } else {
                            control.checkVerification(
                              context,
                              widget.phoneNumber,
                            );
                          }
                        } else {
                          control.isProgress.value = false;
                          control.validation.value = false;
                          control.textErrorLogin.value =
                              'errorVerificationCode';
                        }
                      }
                    },
                    isProgress: control.isProgress.value,
                  ),
                ),
                SizedBox(height: Get.height * .01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widgetText(
                      context,
                      'youDidNotReceiveTheCode'.tr,
                      fontSize: 14.0,
                    ),
                    Obx(
                      () => InkWell(
                        onTap: () {
                          if (control.canResend.value) {
                            control.canResend.value = false;
                            control.isProgress.value = true;
                            controlLoginAndRegister.sendLoginAcrossPhoneNumber(
                              widget.phoneNumber,
                              widget.isFromSplashScreen,
                              goback: true,
                            );
                            control.isProgress.value = false;
                          }
                        },
                        child: Row(
                          children: [
                            widgetText(
                              context,
                              'resend'.tr,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: control.canResend.value
                                  ? blueColor
                                  : greyDarkColor,
                            ),
                            SizedBox(width: Get.width * .01),
                            Icon(Icons.refresh),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * .02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
