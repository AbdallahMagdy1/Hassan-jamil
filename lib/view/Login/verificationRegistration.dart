import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/verificationController.dart';
import '../../global/PinPut.dart';
import '../../global/globalUI.dart';

class VerificationRegistration extends StatefulWidget {
  final String phoneNumber;
  final dynamic md5Hash;
  final bool isFromSplashScreen;
  final int? verificationCodeFromFunction;

  const VerificationRegistration(
    this.phoneNumber,
    this.md5Hash, {
    super.key,
    this.verificationCodeFromFunction,
    this.isFromSplashScreen = false,
  });

  @override
  State<StatefulWidget> createState() => _VerificationRegistrationState();
}

class _VerificationRegistrationState extends State<VerificationRegistration> {
  final VerificationControl control = Get.put(VerificationControl());
  TextEditingController verificationCode = TextEditingController();

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
                widgetText(
                  context,
                  'verification'.tr,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: Get.height * .005),
                Text(
                  'checkYourTextMessages'.tr,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Get.width * .05,
                  ),
                ),
                SizedBox(height: Get.height * .05),
                Text(
                  'weHaveSentYouTheCode'.tr,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: Get.width * .04,
                  ),
                ),
                SizedBox(height: Get.height * .01),
                widgetText(
                  context,
                  '+966${widget.phoneNumber.toString().replaceRange(0, 7, '*******')}',
                  color: blueColor,
                  textDirection: TextDirection.ltr,
                ),
                Container(
                  width: Get.width * .7,
                  height: Get.height * .0008,
                  color: greyColor3,
                ),
                SizedBox(height: Get.height * .01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'enterTheCode'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: Get.width * .04,
                      ),
                    ),
                  ],
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * .1),
                    child: FilledRoundedPinPut(verificationCode, (v) {
                      if (v.toString().length > 3) {
                        control.validation.value = true;
                      } else {
                        control.validation.value = false;
                      }
                    }),
                  ),
                ),
                SizedBox(height: Get.height * .005),
                TweenAnimationBuilder<Duration>(
                  duration: const Duration(seconds: 60),
                  tween: Tween(
                    begin: const Duration(seconds: 60),
                    end: Duration.zero,
                  ),
                  onEnd: () {},
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
                        if (widget.verificationCodeFromFunction ==
                            int.parse(verificationCode.text)) {
                          control.isProgress.value = false;
                          control.validation.value = false;
                          control.checkVerificationCodeInRegister(
                            context,
                            widget.phoneNumber,
                            widget.md5Hash,
                            verificationCode.text,
                          );
                        } else {
                          control.isProgress.value = false;
                          control.validation.value = false;
                          control.textErrorLogin.value =
                              'errorVerificationCode';
                        }
                      }
                    },
                  ),
                ),
                SizedBox(height: Get.height * .015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widgetText(
                      context,
                      'youDidNotReceiveTheCode'.tr,
                      fontSize: 14.0,
                    ),
                    Row(
                      children: [
                        widgetText(
                          context,
                          'resend'.tr,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: blueColor,
                        ),
                        SizedBox(width: Get.width * .01),
                        Icon(Icons.refresh),
                      ],
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
