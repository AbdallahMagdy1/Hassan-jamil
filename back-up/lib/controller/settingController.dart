import 'dart:ui';
import 'package:get/get.dart';
import 'package:hj_app/controller/locale_controller.dart';

import '../global/globalUI.dart';

class SettingController extends GetxController {
  void changeLanguage() {
    if (language == "en") {
      writeGetStorage(keyLanguage, 'ar');
      Get.find<LocaleController>().changeLocale(const Locale("ar"));
    } else if (language == "ar") {
      writeGetStorage(keyLanguage, 'en');
      Get.find<LocaleController>().changeLocale(const Locale("en"));
    }
    getLanguage();
    clearWebViewCache();
  }

  void changeLanguageEnglish() {
    if (language == "ar") {
      writeGetStorage(keyLanguage, 'en');
      Get.find<LocaleController>().changeLocale(const Locale("en"));
      getLanguage();
      clearWebViewCache();
    }
  }

  void changeLanguageArabic() {
    if (language == "en") {
      writeGetStorage(keyLanguage, 'ar');
      Get.find<LocaleController>().changeLocale(const Locale("ar"));
      getLanguage();
      clearWebViewCache();
    }
  }
}
