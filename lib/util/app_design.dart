import 'package:flutter/cupertino.dart';

/// Shared design tokens so spacing, radii, motion and color usage stay
/// consistent across every screen instead of being re-invented per widget.
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 30;
  static const double xxxl = 40;
}

class AppRadius {
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 20;
  static const double pill = 250;
}

class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 320);
}

class AppColors {
  static const Color accent = Color(0xffCC996F);
  static const Color onAccent = Color(0xff473D3D);
  static const Color error = Color(0xffE0654F);
  static const Color disabled = Color(0x66FFFFFF);
}

/// Minimum touch target per HIG (44pt) / Material (48dp); use 48 as the
/// single cross-platform floor so interactive controls never fall below it.
const double kMinTouchTarget = 48;
