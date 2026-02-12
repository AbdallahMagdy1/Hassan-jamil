import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hj_app/view/Login/registerUserNameScreen.dart';
import '../../controller/loginAndRegisterControl.dart';
import '../../global/globalUI.dart';

class optionRegister extends StatefulWidget {
  final bool isFromSplashScreen;

  const optionRegister({super.key, this.isFromSplashScreen = false});

  @override
  State<StatefulWidget> createState() => optionRegisterState();
}

class optionRegisterState extends State<optionRegister> {
  final LoginAndRegisterControl controller = Get.put(LoginAndRegisterControl());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.isProgress.value = false;
      controller.isProgressCreateAccount.value = false;
    });
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
                SizedBox(height: Get.height * .09),
                widgetLoginButton(
                  context,
                  'numberPhone'.tr,
                  backgroundColor: themeModeValue == 'light'
                      ? Colors.white
                      : buttonDarkColor,
                  boxShadow: themeModeValue == 'light'
                      ? null
                      : [const BoxShadow()],
                  colorFont: themeModeValue == 'light'
                      ? darkColor
                      : Colors.white,
                  onTap: () {
                    Get.to(
                      RegisterUserName(
                        hintText: 'numberPhone'.tr,
                        isFromSplashScreen: widget.isFromSplashScreen,
                        acrossPhoneNumber: true,
                        inputFormatters: [LengthLimitingTextInputFormatter(9)],
                      ),
                    );
                  },
                  fontWeight: true,
                  fontSize: Get.width * .04,
                ),
                SizedBox(height: Get.height * .02),
                widgetLoginButton(
                  context,
                  'email',
                  backgroundColor: themeModeValue == 'light'
                      ? Colors.white
                      : buttonDarkColor,
                  boxShadow: themeModeValue == 'light'
                      ? null
                      : [const BoxShadow()],
                  colorFont: themeModeValue == 'light'
                      ? darkColor
                      : Colors.white,
                  onTap: () {
                    Get.to(
                      RegisterUserName(
                        hintText: 'email',
                        textInputType: TextInputType.emailAddress,
                        validatorError: 'pleaseEnterTheEmail',
                        isFromSplashScreen: widget.isFromSplashScreen,
                        acrossEmail: true,
                      ),
                    );
                  },
                  fontWeight: true,
                  fontSize: Get.width * .04,
                ),
                SizedBox(height: Get.height * .02),
                widgetLoginButton(
                  context,
                  'identificationNumber',
                  backgroundColor: themeModeValue == 'light'
                      ? Colors.white
                      : buttonDarkColor,
                  boxShadow: themeModeValue == 'light'
                      ? null
                      : [const BoxShadow()],
                  colorFont: themeModeValue == 'light'
                      ? darkColor
                      : Colors.white,
                  onTap: () {
                    Get.to(
                      RegisterUserName(
                        hintText: 'identificationNumber',
                        textInputType: TextInputType.number,
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        validatorError: 'pleaseEnterTheIDNumber'.tr,
                        isFromSplashScreen: widget.isFromSplashScreen,
                        acrossIdentificationNumber: true,
                      ),
                    );
                  },
                  fontWeight: true,
                  fontSize: Get.width * .04,
                ),
                SizedBox(height: Get.height * .05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
