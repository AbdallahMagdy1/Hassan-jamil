import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hj_app/global/globalUrl.dart';
import 'package:hj_app/view/screen/profileDetails.dart';
import 'package:hj_app/view/screen/settings.dart';
import '../controller/loginAndRegisterControl.dart';
import '../global/globalUI.dart';
import '../global/responsive.dart';
import 'Login/loginUserNameScreen.dart';
import 'screen/globalWebView.dart';
import 'screen/mainView.dart';

class MorePage extends StatefulWidget {
  final Function onSettingUpdate;
  const MorePage({super.key, required this.onSettingUpdate});

  @override
  State<StatefulWidget> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  var isLogin = readGetStorage(loginKey);
  final LoginAndRegisterControl controller = Get.put(LoginAndRegisterControl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeModeValue == 'dark' ? darkColor : Colors.white,
      appBar: AppBar(
        backgroundColor: themeModeValue == 'dark' ? darkColor : Colors.white,
        title: widgetText(
          context,
          'more'.tr,
          color: themeModeValue == 'light' ? darkColor : Colors.white,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: themeModeValue == 'light' ? darkColor : Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            isLogin == null
                ? Container(
                    height: Responsive.hp(context, 0.20),
                    decoration: BoxDecoration(
                      color: themeModeValue == 'light'
                          ? greyColor5
                          : buttonDarkColor,
                      border: Border(
                        bottom: BorderSide(
                          width: Get.width * .005,
                          color: const Color(
                            0xffE1E6E2,
                          ).withAlpha((255 * .30).toInt()),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.only(top: Responsive.hp(context, 0.06)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widgetText(
                              context,
                              'youAreNotRegisteredInTheApplication'.tr,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        SizedBox(height: Responsive.hp(context, 0.02)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widgetButton(
                              context,
                              'signIn'.tr,
                              colorText: Colors.white,
                              colorButton: greenColor,
                              width: Responsive.wp(context, 0.33),
                              onTap: () {
                                Get.to(LoginUserName());
                              },
                            ),
                            SizedBox(width: Responsive.wp(context, 0.03)),
                            widgetText(context, 'or'.tr),
                            SizedBox(width: Responsive.wp(context, 0.03)),
                            widgetButton(
                              context,
                              'createAnAccount'.tr,
                              colorText: Colors.white,
                              colorButton: greenColor,
                              width: Responsive.wp(context, 0.33),
                              onTap: () {
                                controller.getUserAccountTypes(
                                  'numberPhone',
                                  true,
                                );
                              },
                              isProgress: controller.isProgress.value,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Get.to(const profileDetails());
                      },
                      child: Container(
                        height: Responsive.hp(context, 0.20),
                        decoration: BoxDecoration(
                          color: themeModeValue == 'light'
                              ? greyColor5
                              : buttonDarkColor,
                          border: Border(
                            bottom: BorderSide(
                              width: Get.width * .005,
                              color: const Color(
                                0xffE1E6E2,
                              ).withAlpha((255 * .30).toInt()),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: Responsive.hp(context, 0.05),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(const profileDetails());
                                        },
                                        child: Column(
                                          children: [
                                            isLogin['Logo'] != null
                                                ? Container(
                                                    width:
                                                        Responsive.avatarSize(
                                                          context,
                                                        ),
                                                    height:
                                                        Responsive.avatarSize(
                                                          context,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: MemoryImage(
                                                          base64.decode(
                                                            isLogin['Logo'],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    width:
                                                        Responsive.avatarSize(
                                                          context,
                                                        ),
                                                    height:
                                                        Responsive.avatarSize(
                                                          context,
                                                        ),
                                                    decoration:
                                                        const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: AssetImage(
                                                              pngCharacter,
                                                            ),
                                                          ),
                                                        ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        language == "ar"
                                            ? Row(
                                                children: [
                                                  widgetText(
                                                    context,
                                                    isLogin['FirstNameAr'] ??
                                                        isLogin['FirstNameEn'],
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  SizedBox(
                                                    width: Responsive.wp(
                                                      context,
                                                      0.01,
                                                    ),
                                                  ),
                                                  widgetText(
                                                    context,
                                                    (isLogin['LastNameAr'] ??
                                                        isLogin['LastNameEn'] ??
                                                        ''),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  widgetText(
                                                    context,
                                                    isLogin['FirstNameEn'] ??
                                                        isLogin['FirstNameAr'],
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  SizedBox(
                                                    width: Get.width * .01,
                                                  ),
                                                  widgetText(
                                                    context,
                                                    (isLogin['LastNameEn'] ??
                                                        isLogin['LastNameAr'] ??
                                                        ''),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ],
                                              ),
                                        SizedBox(
                                          height: Responsive.wp(context, 0.02),
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              Get.to(const profileDetails());
                                            },
                                            child: Text(
                                              "profileReview".tr,
                                              style: TextStyle(
                                                fontSize: Responsive.scaledFont(
                                                  context,
                                                  12,
                                                ),
                                                color: greenColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Get.to(const profileDetails());
                                          },
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            color: arww,
                                            size: Responsive.wp(context, 0.04),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            listInMorePage(
              context,
              svgMyRequests,
              "myRequests".tr,
              onTap: () {
                isLogin == null
                    ? messagePleaseLogin()
                    : Get.to(
                        GlobalWebView(
                          '$webUrl$language/myorders/${isLogin['Web_UserID']}',
                        ),
                      );
              },
              colorText: themeModeValue == 'light' ? darkColor : Colors.white,
            ),
            listInMorePage(
              context,
              svgMyBookings,
              "myBookings".tr,
              onTap: () {
                isLogin == null
                    ? messagePleaseLogin()
                    : Get.to(
                        GlobalWebView(
                          '$webUrl$language/maintenance-mycars/myReservation',
                        ),
                      );
              },
              colorText: themeModeValue == 'light' ? darkColor : Colors.white,
            ),
            listInMorePage(
              context,
              svgMaintenance,
              "maintenance".tr,
              onTap: () {
                isLogin == null
                    ? messagePleaseLogin()
                    : Get.to(GlobalWebView('$webUrl$language/CustomerCar'));
              },
              colorText: themeModeValue == 'light' ? darkColor : Colors.white,
            ),
            listInMorePage(
              context,
              svgInformationAboutUs,
              "informationAboutUs".tr,
              onTap: () {
                Get.to(GlobalWebView('$webUrl$language/about'));
              },
              colorText: themeModeValue == 'light' ? darkColor : Colors.white,
            ),
            listInMorePage(
              context,
              svgCallUs,
              "callUs".tr,
              onTap: () {
                Get.to(GlobalWebView('$webUrl$language/contactus'));
              },
              colorText: themeModeValue == 'light' ? darkColor : Colors.white,
            ),
            listInMorePage(
              context,
              svgRecruitment,
              "recruitment".tr,
              onTap: () {
                Get.to(GlobalWebView('$webUrl$language/jobs'));
              },
              colorText: themeModeValue == 'light' ? darkColor : Colors.white,
            ),
            listInMorePage(
              context,
              svgTips,
              "advice".tr,
              onTap: () {
                Get.to(GlobalWebView('$webUrl$language/tips'));
              },
              colorText: themeModeValue == 'light' ? darkColor : Colors.white,
            ),
            listInMorePage(
              context,
              svgSettings,
              "settings".tr,
              onTap: () async {
                await Get.to(const Settings());
                setState(() {});
                widget.onSettingUpdate();
              },
              colorText: themeModeValue == 'light' ? darkColor : Colors.white,
            ),
            if (isLogin != null) ...[
              listInMorePage(
                context,
                svgSignOut,
                "signOut".tr,
                heightFactor: 1.1,
                colorText: redColor,
                visibility: false,
                onTap: signOutFunction,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void signOutFunction() {
    Get.dialog(
      Dialog(
        backgroundColor: themeModeValue == 'light' ? Colors.white : darkColor,
        child: Container(
          alignment: Alignment.topCenter,
          height: Responsive.hp(context, 0.18),
          width: Responsive.wp(context, 0.8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              widgetText(
                context,
                'signOut'.tr,
                fontWeight: FontWeight.bold,
                fontSize: Responsive.scaledFont(context, 16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: themeModeValue == 'light'
                              ? greyc
                              : buttonDarkColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: Responsive.wp(context, 0.3),
                        height: Responsive.hp(context, 0.04),
                        child: widgetText(
                          context,
                          'cancel'.tr,
                          color: themeModeValue == 'dark'
                              ? Colors.white
                              : darkColor,
                          fontSize: Responsive.scaledFont(context, 14),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        await removeGetStorage(loginKey);
                        Get.offAll(
                          MainView(
                            lastPageNavigator: LoginUserName(
                              isFromSplashScreen: false,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: greenColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: Responsive.wp(context, 0.3),
                        height: Responsive.hp(context, 0.04),
                        child: widgetText(
                          context,
                          'ok'.tr,
                          color: Colors.white,
                          fontSize: Responsive.scaledFont(context, 14),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listInMorePage(
    BuildContext context,
    svgPicture,
    String title, {
    double heightFactor = 1.0,
    var onTap,
    bool hideEndIcon = true,
    Color? colorText,
    visibility,
  }) {
    final height = Responsive.height(context) * heightFactor;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(
            right: Responsive.wp(context, 0.02),
            bottom: height * .022,
            top: height * .022,
          ),
          decoration: BoxDecoration(
            color: themeModeValue == 'light' ? Colors.white : darkColor,
            border: Border(bottom: BorderSide(color: arww)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(children: [SvgPicture.asset(svgPicture)]),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: height * .02,
                            color: colorText ?? darkColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: visibility ?? true,
                child: Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Visibility(
                        visible: hideEndIcon,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: arww,
                          size: Responsive.wp(context, 0.04),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> messagePleaseLogin() {
    return Fluttertoast.showToast(msg: 'pleaseSignIn'.tr);
  }
}
