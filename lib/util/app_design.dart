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
  static const Color background = Color(0xff181714);
  static const Color surface = Color(0xff24221E);
  static const Color surfaceRaised = Color(0xff302D27);
  static const Color textPrimary = Color(0xffF4F0E8);
  static const Color textSecondary = Color(0xffC3BDB2);
  static const Color divider = Color(0xff514B40);
  static const Color accent = Color(0xffD0AD7A);
  static const Color onAccent = Color(0xff211D17);
  static const Color onAccentDetail = Color(0xff332C22);
  static const Color success = Color(0xffA6CB9C);
  static const Color error = Color(0xffE0654F);
  static const Color disabled = Color(0x66FFFFFF);
}

/// Keeps page text readable while retaining each selected theme's hues.
/// Board colors and theme previews use the original, unmodified palette.
LinearGradient readablePageGradient(LinearGradient gradient) {
  final foregrounds = [
    AppColors.textPrimary,
    AppColors.textSecondary,
    AppColors.accent,
  ];
  final needsScrim = gradient.colors.any((background) => foregrounds.any(
      (foreground) =>
          (foreground.computeLuminance() + .05) /
              (background.computeLuminance() + .05) <
          4.5));
  if (!needsScrim) return gradient;
  // Even white under this scrim supports 4.5:1 for our darkest page text.
  return LinearGradient(
    begin: gradient.begin,
    end: gradient.end,
    stops: gradient.stops,
    tileMode: gradient.tileMode,
    transform: gradient.transform,
    colors: gradient.colors
        .map((color) => Color.alphaBlend(const Color(0xBF000000), color))
        .toList(),
  );
}

/// Minimum touch target per HIG (44pt) / Material (48dp); use 48 as the
/// single cross-platform floor so interactive controls never fall below it.
const double kMinTouchTarget = 48;
