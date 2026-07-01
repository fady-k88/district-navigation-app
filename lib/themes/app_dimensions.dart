import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:district_navigation_app/providers/settings_provider.dart';

class AppDimensions {
  final double screenWidth;
  final double screenHeight;
  final double _ref;
  final double _fontMultiplier;

  // Standard constructor — reads SettingsProvider from context automatically.
  AppDimensions(BuildContext context)
    : screenWidth = MediaQuery.of(context).size.width,
      screenHeight = MediaQuery.of(context).size.height,
      _ref = MediaQuery.of(context).size.shortestSide.clamp(0.0, 480.0),
      // Read the font scale safely — falls back to 1.0 if provider isn't in tree
      _fontMultiplier = _readFontMultiplier(context);

  // Raw constructor — for use in contexts where a BuildContext is unavailable
  // (e.g. inside a StatelessWidget initState or a service layer).
  AppDimensions.raw({
    required this.screenWidth,
    required this.screenHeight,
    double fontMultiplier = 1.0,
  }) : _ref = screenWidth.clamp(0.0, 480.0),
       _fontMultiplier = fontMultiplier;

  static double _readFontMultiplier(BuildContext context) {
    try {
      return context.watch<SettingsProvider>().fontScale.multiplier;
    } catch (_) {
      return 1.0;
    }
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  double _s(double fraction, {double min = 0, double max = double.infinity}) =>
      (_ref * fraction).clamp(min, max);

  double _f(double fraction, {double min = 0, double max = double.infinity}) =>
      (_ref * fraction).clamp(min, max) * _fontMultiplier;

  // ─── Padding & Margin ─────────────────────────────────────────────────────

  double get paddingXS => _s(0.015, min: 4, max: 8);
  double get paddingS => _s(0.020, min: 6, max: 12);
  double get paddingM => _s(0.030, min: 10, max: 16);
  double get paddingL => _s(0.040, min: 14, max: 20);
  double get paddingXL => _s(0.050, min: 18, max: 28);

  // ─── Font Sizes — scaled by fontMultiplier ────────────────────────────────

  double get fontXS => _f(0.024, min: 10); // captions
  double get fontS => _f(0.030, min: 13); // secondary labels
  double get fontM => _f(0.035, min: 14); // body text
  double get fontL => _f(0.040, min: 16); // emphasis
  double get fontXL => _f(0.046, min: 18); // headings
  double get fontXXL => _f(0.055, min: 22); // display

  // ─── Icon Sizes ───────────────────────────────────────────────────────────

  double get iconS => _s(0.050, min: 18, max: 24);
  double get iconM => _s(0.060, min: 20, max: 28);
  double get iconL => _s(0.080, min: 26, max: 36);

  // ─── Component Sizes ──────────────────────────────────────────────────────

  double get mapControlWidth => _s(0.130, min: 44, max: 64);
  double get mapControlIconSize => _s(0.055, min: 18, max: 26);
  double get compassSize => _s(0.110, min: 38, max: 52);
  double get toolbarIconSize => _s(0.095, min: 32, max: 44);

  // ─── Border Radius ────────────────────────────────────────────────────────

  double get borderRadius => _s(0.040, min: 12, max: 20);
  double get borderRadiusS => _s(0.025, min: 8, max: 14);

  // ─── Layout Helpers ───────────────────────────────────────────────────────

  bool get isLandscape => screenWidth > screenHeight;
  bool get isWideScreen => _ref >= 600;

  static double panelMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? 480.0 : double.infinity;
  }
}
