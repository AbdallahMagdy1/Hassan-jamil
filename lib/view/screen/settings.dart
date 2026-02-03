import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../global/globalUI.dart';
import '../../controller/settingController.dart';
import 'package:hj_app/controller/themeController.dart';
import 'notification.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() => _Settings();
}

class _Settings extends State<Settings> {
  final SettingController controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: themeModeValue == 'dark' ? Colors.white : darkColor,
            size: Get.width * .04,
          ),
        ),
        title: widgetText(context, 'settings'.tr, fontWeight: FontWeight.bold),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
          child: Column(
            children: [
              SizedBox(height: Get.height * .04),
              Row(
                children: [
                  widgetText(
                    context,
                    'language'.tr,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ],
              ),
              SizedBox(height: Get.height * .02),
              Container(
                // Negative padding
                transform: Matrix4.translationValues(0.0, -2.6, 0.0),
                // Add top border
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFc3c3c3), width: 0.6),
                  ),
                ),
              ),
              SizedBox(height: Get.height * .02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widgetText(
                    context,
                    'applicationLanguage'.tr,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: Get.height * .02),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            controller.changeLanguageArabic();
                          },
                          child: Container(
                            width: Get.width * .2,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(3.0),
                            margin: EdgeInsets.only(top: Get.width * .02),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: language != 'en' ? greenColor : arww,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: Text(
                              "العربية",
                              style: GoogleFonts.almarai(
                                fontWeight: FontWeight.bold,
                                color: themeModeValue == 'light'
                                    ? (language != 'ar' ? arww : darkColor)
                                    : (language != 'ar' ? arww : Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: Get.width * .02),
                        InkWell(
                          onTap: () {
                            controller.changeLanguageEnglish();
                          },
                          child: Container(
                            width: Get.width * .2,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(3.0),
                            margin: EdgeInsets.only(top: Get.width * .02),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: language == 'en' ? greenColor : arww,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: Text(
                              "English",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: themeModeValue == 'light'
                                    ? (language != 'en' ? arww : darkColor)
                                    : (language != 'en' ? arww : Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * .01),
              Container(
                // Negative padding
                transform: Matrix4.translationValues(0.0, -2.6, 0.0),
                // Add top border
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFc3c3c3), width: 0.6),
                  ),
                ),
              ),
              SizedBox(height: Get.height * .03),
              SizedBox(
                width: double.maxFinite,
                child: widgetText(
                  context,
                  'theAppearance'.tr,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: Get.height * .01),
              Container(
                // Negative padding
                transform: Matrix4.translationValues(0.0, -2.6, 0.0),
                // Add top border
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFc3c3c3), width: 0.6),
                  ),
                ),
              ),
              SizedBox(height: Get.height * .03),
              InkWell(
                onTap: () {
                  showBottomSheetWidget();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widgetText(
                      context,
                      'appAppearance'.tr,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                    Row(
                      children: [
                        Text(
                          systemMode
                              ? 'defaultMode'.tr
                              : lightMode
                              ? 'lghitmode'.tr
                              : 'nightmode'.tr,
                          style: TextStyle(
                            color: greenColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Get.width * .03,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: greyColor2,
                          size: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: Get.height * .01),
              Container(
                // Negative padding
                transform: Matrix4.translationValues(0.0, -2.6, 0.0),
                // Add top border
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFc3c3c3), width: 0.6),
                  ),
                ),
              ),
              SizedBox(height: Get.height * .03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(const NotificationPage());
                    },
                    child: widgetText(
                      context,
                      'notifications'.tr,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: greyColor2, size: 15),
                ],
              ),
              SizedBox(height: Get.height * .01),
              Container(
                // Negative padding
                transform: Matrix4.translationValues(0.0, -2.6, 0.0),
                // Add top border
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFc3c3c3), width: 0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future showBottomSheetWidget() {
    return Get.bottomSheet(
      SafeArea(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: Get.height * 0.7, // Reduced from 0.9
          ),
          child: IntrinsicHeight(
            // Add this to wrap content
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StatefulBuilder(
                  builder: (context, setState) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: Get.width * .02),
                      Container(
                        width: Get.width * .2,
                        height: Get.height * .005,
                        decoration: BoxDecoration(
                          color: greyColor2,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(height: Get.height * .03),
                      widgetText(
                        context,
                        'appAppearance'.tr,
                        color: greenColor,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: Get.height * .01),
                      Container(
                        decoration: BoxDecoration(color: greyColor),
                        width: Get.width * .9,
                        height: Get.height * .001,
                      ),
                      appearanceitme(
                        'defaultmobilesettings',
                        systemMode,
                        onTap: () {
                          setState(() {
                            lightModeChoose = false;
                            nightModeChoose = false;
                            systemModeChoose = true;
                            lightMode = false;
                            nightMode = false;
                            systemMode = true;
                          });
                        },
                      ),
                      appearanceitme(
                        'lghitmode',
                        lightMode,
                        onTap: () {
                          setState(() {
                            lightModeChoose = true;
                            nightModeChoose = false;
                            systemModeChoose = false;
                            lightMode = true;
                            nightMode = false;
                            systemMode = false;
                          });
                        },
                      ),
                      appearanceitme(
                        'nightmode',
                        nightMode,
                        onTap: () {
                          setState(() {
                            lightModeChoose = false;
                            nightModeChoose = true;
                            systemModeChoose = false;
                            lightMode = false;
                            nightMode = true;
                            systemMode = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Get.height * .04),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: Get.width * .05,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(color: greenColor),
                        width: Get.width,
                        child: widgetButton(
                          context,
                          'confirm'.tr,
                          onTap: () async {
                            if (lightModeChoose == true) {
                              lightModeChoose = true;
                              nightModeChoose = false;
                              lightMode = true;
                              nightMode = false;
                              Get.changeThemeMode(ThemeMode.light);
                              writeGetStorage(
                                keyTheme,
                                'themeModeValue = light',
                              );
                              setState(() {});
                              themeModeValue = 'light';
                              await clearWebViewCache();
                            } else if (nightModeChoose == true) {
                              lightModeChoose = false;
                              nightModeChoose = true;
                              lightMode = false;
                              nightMode = true;
                              Get.changeThemeMode(ThemeMode.dark);
                              writeGetStorage(
                                keyTheme,
                                'themeModeValue = dark',
                              );
                              setState(() {});
                              themeModeValue = 'dark';
                              await clearWebViewCache();
                            } else if (systemModeChoose == true) {
                              lightModeChoose = false;
                              nightModeChoose = false;
                              systemModeChoose = true;
                              lightMode = false;
                              nightMode = false;
                              systemMode = true;
                              writeGetStorage(
                                keyTheme,
                                'themeModeValue = system',
                              );
                              setState(() {});

                              if (Get.mediaQuery.platformBrightness ==
                                  Brightness.dark) {
                                themeModeValue = 'dark';
                                Get.changeThemeMode(ThemeMode.dark);
                              } else {
                                themeModeValue = 'light';
                                Get.changeThemeMode(ThemeMode.light);
                              }
                              await clearWebViewCache();
                            }
                            updateSystemUIOverlays(themeModeValue);
                            Get.find<ThemeController>().updateTheme();
                            Get.back();
                          },
                          colorButton: greenColor,
                          colorText: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: Get.width * .052,
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
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(25),
          topStart: Radius.circular(25),
        ),
      ),
      backgroundColor: themeModeValue == 'dark' ? darkColor : Colors.white,
    );
  }

  InkWell appearanceitme(String name, selected, {onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * .05,
              vertical: Get.height * .03,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widgetText(
                  context,
                  name.tr,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: greyColor2,
                ),
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(color: greyColor2, width: 2.0),
                  ),
                  child: CircleAvatar(
                    backgroundColor: selected ? greenColor : Colors.white,
                    child: SizedBox(
                      width: Get.width * .03,
                      height: Get.height * .03,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: greyColor,
            width: Get.width * .9,
            height: Get.height * .001,
          ),
        ],
      ),
    );
  }
}
