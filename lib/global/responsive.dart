import 'package:flutter/widgets.dart';

/// Lightweight responsive helpers for consistent sizing across mobile/tablet
/// Usage:
/// - `Responsive.isTablet(context)`
/// - `Responsive.width(context, 0.5)` returns 50% of available width
/// - `Responsive.scaledFont(context, 16)` returns a font size scaled for device
class Responsive {
  /// Consider tablet when width >= 700
  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= 700;
  }

  /// Return available width
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Return available height
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Percentage of width (0..1)
  static double wp(BuildContext context, double percent) {
    final w = width(context);
    return w * percent;
  }

  /// Percentage of height (0..1)
  static double hp(BuildContext context, double percent) {
    final h = height(context);
    return h * percent;
  }

  /// Scales a base font size proportionally to screen width with a clamp
  static double scaledFont(BuildContext context, double base) {
    final w = width(context);
    // baseline 375 -> factor 1.0 ; tablet 1024 -> factor ~1.6
    final factor = (w / 375).clamp(0.8, 1.6);
    return (base * factor).roundToDouble();
  }

  /// Avatar size recommended for profile pictures
  static double avatarSize(BuildContext context) {
    final w = width(context);
    return isTablet(context) ? 160.0 : (w * 0.2).clamp(56.0, 160.0);
  }

  /// Field width for two-column layout on tablets
  static double fieldWidth(BuildContext context) {
    final w = width(context);
    final pad = wp(context, 0.05);
    return isTablet(context) ? (w * 0.45) : (w - pad * 2);
  }
}
