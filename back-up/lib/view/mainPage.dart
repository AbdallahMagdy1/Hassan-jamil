import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hj_app/global/globalUrl.dart';
import '../global/globalUI.dart';
import 'Login/loginUserNameScreen.dart';
import 'screen/globalWebView.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var isLogin = readGetStorage(loginKey);

  @override
  Widget build(BuildContext context) {
    return isLogin == null
        ? Stack(
            children: [
              GlobalWebView(
                '$webUrl$language/home/""/""/""',
                isStandalone: false,
              ),
              Container(
                color: Color.fromARGB(137, 9, 13, 11),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: (themeModeValue == 'light'
                            ? Colors.white
                            : buttonDarkColor),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: Get.width * .15),
                      child: Column(
                        children: [
                          SizedBox(height: Get.height * .02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                pngPleaseLoginForABetterExperience,
                                width: Get.width * .5,
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height * .015),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              widgetText(
                                context,
                                'pleaseLoginForABetterExperience'.tr,
                                fontSize: Get.width * .035,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height * .02),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Get.width * .05,
                            ),
                            child: widgetLoginButton(
                              context,
                              'signIn',
                              backgroundColor: greenColor,
                              onTap: () {
                                Get.to(LoginUserName());
                              },
                              fontSize: Get.width * .04,
                            ),
                          ),
                          SizedBox(height: Get.height * .02),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : GlobalWebView(
            '$webUrl$language/home/${isLogin['GUID']}/${isLogin['Web_UserID']}/${isLogin['FirstNameAr']}',
            isStandalone: false,
          );
  }
}
