import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hj_app/global/globalUI.dart';

class ThemeController extends GetxController {
  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      primaryColor: greenColor,
      scaffoldBackgroundColor: Colors.white,
      textTheme: _getTextTheme(Brightness.light),
      fontFamilyFallback: _getFallBackFontFamily(),
      textSelectionTheme: TextSelectionThemeData(cursorColor: greenColor),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: blackColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(color: blackColor, fontSize: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: greenColor,
          textStyle: TextStyle(color: blackColor),
        ),
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      primaryColor: greenColor,
      scaffoldBackgroundColor: blackColor,
      textTheme: _getTextTheme(Brightness.dark),
      fontFamilyFallback: _getFallBackFontFamily(),
      textSelectionTheme: TextSelectionThemeData(cursorColor: greenColor),
      dialogTheme: DialogThemeData(
        backgroundColor: blackColor,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  List<String> _getFallBackFontFamily() {
    final locale = Get.locale ?? const Locale('en', 'US');
    switch (locale.languageCode) {
      case 'ar':
        return [
          "Noto Sans Arabic",
          "DejaVu Sans",
          'Arial',
          "Helvetica Neue",
          'Helvetica',
          'sans-serif',
        ];
      default:
        return ['Noto Sans', 'sans-serif'];
    }
  }

  TextTheme _getTextTheme(Brightness brightness) {
    // Get current locale from GetX
    final locale = Get.locale ?? const Locale('en', 'US');

    // Define font families for different languages
    switch (locale.languageCode) {
      case 'ar': // Arabic
        return GoogleFonts.almaraiTextTheme(
          ThemeData(brightness: brightness).textTheme,
        );
      default: // English and others
        return GoogleFonts.robotoTextTheme(
          ThemeData(brightness: brightness).textTheme,
        );
    }
  }

  void updateTheme() => update();
}
