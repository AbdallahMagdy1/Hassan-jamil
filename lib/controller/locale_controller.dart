import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hj_app/global/globalUI.dart';

class LocaleController extends GetxController {
  var locale = Locale(language).obs;

  void changeLocale(Locale newLocale) {
    locale.value = newLocale;
    Get.updateLocale(newLocale);
  }
}
