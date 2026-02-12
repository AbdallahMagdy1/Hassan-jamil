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

  // Helper for Theme Colors
  Color get surfaceColor =>
      themeModeValue == 'dark' ? buttonDarkColor : Colors.grey.shade50;
  Color get scaffoldBg => themeModeValue == 'dark' ? darkColor : Colors.white;
  Color get textColor => themeModeValue == 'dark' ? Colors.white : darkColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text(
          'more'.tr,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 10),
              _buildMenuSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: isLogin == null ? _buildGuestHeader() : _buildUserHeader(),
    );
  }

  Widget _buildGuestHeader() {
    return Column(
      children: [
        Text(
          'youAreNotRegisteredInTheApplication'.tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widgetButton(
              context,
              'signIn'.tr,
              colorText: Colors.white,
              colorButton: greenColor,
              width: Responsive.wp(context, 0.35),
              onTap: () => Get.to(LoginUserName()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'or'.tr,
                style: TextStyle(color: textColor.withOpacity(0.6)),
              ),
            ),
            Obx(
              () => widgetButton(
                context,
                'createAnAccount'.tr,
                colorText: Colors.white,
                colorButton: greenColor,
                width: Responsive.wp(context, 0.35),
                onTap: () =>
                    controller.getUserAccountTypes('numberPhone', true),
                isProgress: controller.isProgress.value,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserHeader() {
    // Re-read fresh data from storage on every build
    final freshLogin = readGetStorage(loginKey);

    return InkWell(
      onTap: () async {
        await Get.to(() => const profileDetails());
        // Refresh the page after returning from profile details
        setState(() {
          isLogin = readGetStorage(loginKey);
        });
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: greenColor, width: 2),
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: freshLogin?['Logo'] != null
                  ? MemoryImage(base64.decode(freshLogin['Logo']))
                  : AssetImage(pngCharacter) as ImageProvider,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  language == "ar"
                      ? "${freshLogin?['FirstNameAr'] ?? freshLogin?['FirstNameEn'] ?? ''} ${freshLogin?['LastNameAr'] ?? freshLogin?['LastNameEn'] ?? ''}"
                      : "${freshLogin?['FirstNameEn'] ?? freshLogin?['FirstNameAr'] ?? ''} ${freshLogin?['LastNameEn'] ?? freshLogin?['LastNameAr'] ?? ''}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "profileReview".tr,
                  style: TextStyle(
                    color: greenColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: arww),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
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
        ),
        _buildMenuItem(
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
        ),
        _buildMenuItem(
          svgMaintenance,
          "maintenance".tr,
          onTap: () {
            isLogin == null
                ? messagePleaseLogin()
                : Get.to(GlobalWebView('$webUrl$language/CustomerCar'));
          },
        ),
        _buildMenuItem(
          svgInformationAboutUs,
          "informationAboutUs".tr,
          onTap: () {
            Get.to(GlobalWebView('$webUrl$language/about'));
          },
        ),
        _buildMenuItem(
          svgCallUs,
          "callUs".tr,
          onTap: () {
            Get.to(GlobalWebView('$webUrl$language/contactus'));
          },
        ),
        _buildMenuItem(
          svgRecruitment,
          "recruitment".tr,
          onTap: () {
            Get.to(GlobalWebView('$webUrl$language/jobs'));
          },
        ),
        _buildMenuItem(
          svgTips,
          "advice".tr,
          onTap: () {
            Get.to(GlobalWebView('$webUrl$language/tips'));
          },
        ),
        _buildMenuItem(
          svgSettings,
          "settings".tr,
          onTap: () async {
            await Get.to(const Settings());
            setState(() {});
            widget.onSettingUpdate();
          },
        ),
        if (isLogin != null)
          _buildMenuItem(
            svgSignOut,
            "signOut".tr,
            colorText: redColor,
            hideEndIcon: false,
            onTap: signOutFunction,
          ),
      ],
    );
  }

  Widget _buildMenuItem(
    String iconPath,
    String title, {
    required VoidCallback onTap,
    Color? colorText,
    bool hideEndIcon = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: SvgPicture.asset(iconPath, width: 24, height: 24),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorText ?? textColor,
            fontSize: 15,
          ),
        ),
        trailing: hideEndIcon
            ? Icon(Icons.arrow_forward_ios, size: 14, color: arww)
            : null,
      ),
    );
  }

  void signOutFunction() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: themeModeValue == 'light' ? Colors.white : darkColor,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout, color: Colors.red, size: 40),
              const SizedBox(height: 16),
              widgetText(
                context,
                'signOut'.tr,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: widgetButton(
                      context,
                      'cancel'.tr,
                      colorButton: themeModeValue == 'light'
                          ? greyc
                          : buttonDarkColor,
                      colorText: themeModeValue == 'dark'
                          ? Colors.white
                          : darkColor,
                      onTap: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: widgetButton(
                      context,
                      'ok'.tr,
                      colorButton: greenColor,
                      colorText: Colors.white,
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

  Future<bool?> messagePleaseLogin() {
    return Fluttertoast.showToast(
      msg: 'pleaseSignIn'.tr,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }
}
