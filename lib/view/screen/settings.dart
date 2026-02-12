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
    bool isDark = themeModeValue == 'dark';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? darkColor : Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: isDark ? Colors.white : darkColor,
            size: 18,
          ),
        ),
        title: widgetText(context, 'settings'.tr, fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * .05,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SECTION: LANGUAGE
              _buildSectionTitle(context, 'language'.tr),
              const SizedBox(height: 12),
              Container(
                decoration: _containerDecoration(isDark),
                child: Column(
                  children: [
                    _buildSettingRow(
                      context,
                      label: 'applicationLanguage'.tr,
                      trailing: Row(
                        children: [
                          _buildLangButton(
                            "العربية",
                            language != 'en',
                            () => controller.changeLanguageArabic(),
                          ),
                          const SizedBox(width: 8),
                          _buildLangButton(
                            "English",
                            language == 'en',
                            () => controller.changeLanguageEnglish(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // SECTION: APPEARANCE
              _buildSectionTitle(context, 'theAppearance'.tr),
              const SizedBox(height: 12),
              Container(
                decoration: _containerDecoration(isDark),
                child: Column(
                  children: [
                    // Theme Switcher Row
                    InkWell(
                      onTap: () => showBottomSheetWidget(),
                      child: _buildSettingRow(
                        context,
                        label: 'appAppearance'.tr,
                        trailing: Row(
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
                                fontSize: 13,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: greyColor2,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildDivider(),
                    // Notifications Row
                    InkWell(
                      onTap: () => Get.to(const NotificationPage()),
                      child: _buildSettingRow(
                        context,
                        label: 'notifications'.tr,
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: greyColor2,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI HELPER METHODS (Same "Comfortable" Logic as React) ---

  BoxDecoration _containerDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark
          ? const Color(0xFF1E1E1E)
          : Colors.white, // Mimicking bg-theme-up
      borderRadius: BorderRadius.circular(24.0), // The "Perfect" Radius
      border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.2)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: widgetText(
        context,
        text,
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
      ),
    );
  }

  Widget _buildSettingRow(
    BuildContext context, {
    required String label,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: widgetText(
              context,
              label,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      color: const Color(0xFFDBDBDB).withOpacity(0.3),
    );
  }

  Widget _buildLangButton(String title, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? greenColor : arww),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          title,
          style: title == "العربية"
              ? GoogleFonts.almarai(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isSelected ? greenColor : arww,
                )
              : TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isSelected ? greenColor : arww,
                ),
        ),
      ),
    );
  }

  // --- LOGIC: BOTTOM SHEET (Keep logic identical, update UI) ---

  Future showBottomSheetWidget() {
    return Get.bottomSheet(
      SafeArea(
        child: IntrinsicHeight(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: greyColor2.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              widgetText(
                context,
                'appAppearance'.tr,
                color: greenColor,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 10),
              _buildDivider(),
              StatefulBuilder(
                builder: (context, setST) => Column(
                  children: [
                    appearanceitme(
                      'defaultmobilesettings',
                      systemMode,
                      onTap: () {
                        setST(() {
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
                        setST(() {
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
                        setST(() {
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
              Padding(
                padding: const EdgeInsets.all(20),
                child: widgetButton(
                  context,
                  'confirm'.tr,
                  onTap: () async {
                    // ALL ORIGINAL LOGIC KEPT HERE
                    if (lightModeChoose == true) {
                      Get.changeThemeMode(ThemeMode.light);
                      writeGetStorage(keyTheme, 'themeModeValue = light');
                      themeModeValue = 'light';
                    } else if (nightModeChoose == true) {
                      Get.changeThemeMode(ThemeMode.dark);
                      writeGetStorage(keyTheme, 'themeModeValue = dark');
                      themeModeValue = 'dark';
                    } else if (systemModeChoose == true) {
                      writeGetStorage(keyTheme, 'themeModeValue = system');
                      if (Get.mediaQuery.platformBrightness ==
                          Brightness.dark) {
                        themeModeValue = 'dark';
                        Get.changeThemeMode(ThemeMode.dark);
                      } else {
                        themeModeValue = 'light';
                        Get.changeThemeMode(ThemeMode.light);
                      }
                    }
                    await clearWebViewCache();
                    Get.find<ThemeController>().updateTheme();
                    setState(() {});
                    Get.back();
                  },
                  colorButton: greenColor,
                  colorText: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: themeModeValue == 'dark' ? darkColor : Colors.white,
      isScrollControlled: true,
    );
  }

  Widget appearanceitme(String name, selected, {onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? greenColor : greyColor2,
                      width: 2.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                      backgroundColor: selected
                          ? greenColor
                          : Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildDivider(),
        ],
      ),
    );
  }
}
