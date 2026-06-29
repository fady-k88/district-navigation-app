// providers/settings_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Font Scale ───────────────────────────────────────────────────────────────

enum FontScale { small, medium, large }

extension FontScaleExt on FontScale {
  double get multiplier {
    switch (this) {
      case FontScale.small:
        return 0.85;
      case FontScale.medium:
        return 1.00;
      case FontScale.large:
        return 1.20;
    }
  }

  String get label {
    switch (this) {
      case FontScale.small:
        return 'صغير';
      case FontScale.medium:
        return 'متوسط';
      case FontScale.large:
        return 'كبير';
    }
  }
}

// ─── Map Style ────────────────────────────────────────────────────────────────

enum MapStyle { standard, light, satellite }

extension MapStyleExt on MapStyle {
  String get label {
    switch (this) {
      case MapStyle.standard:
        return 'قياسي';
      case MapStyle.light:
        return 'فاتح';
      case MapStyle.satellite:
        return 'قمر صناعي';
    }
  }

  IconData get icon {
    switch (this) {
      case MapStyle.standard:
        return Icons.map_outlined;
      case MapStyle.light:
        return Icons.wb_sunny_outlined;
      case MapStyle.satellite:
        return Icons.satellite_alt_outlined;
    }
  }

  String get tileUrl {
    switch (this) {
      case MapStyle.standard:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      case MapStyle.light:
        return 'https://tile.openstreetmap.fr/hot/{z}/{x}/{y}.png';
      case MapStyle.satellite:
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
    }
  }
}

// ─── Marker Style ─────────────────────────────────────────────────────────────

enum MarkerStyle { pin, dot, numbered }

extension MarkerStyleExt on MarkerStyle {
  String get label {
    switch (this) {
      case MarkerStyle.pin:
        return 'دبوس';
      case MarkerStyle.dot:
        return 'نقطة';
      case MarkerStyle.numbered:
        return 'مُرقَّم';
    }
  }

  IconData get icon {
    switch (this) {
      case MarkerStyle.pin:
        return Icons.location_pin;
      case MarkerStyle.dot:
        return Icons.circle;
      case MarkerStyle.numbered:
        return Icons.looks_one_outlined;
    }
  }
}

// ─── Accent Color — 3 clean choices ──────────────────────────────────────────

class AccentOption {
  final String label;
  final Color color;
  const AccentOption(this.label, this.color);
}

const List<AccentOption> kAccentOptions = [
  AccentOption('أخضر', Color(0xFF2ECC71)),
  AccentOption('أزرق', Color(0xFF3498DB)),
  AccentOption('ذهبي', Color(0xFFF39C12)),
];

// ─── Provider ─────────────────────────────────────────────────────────────────

class SettingsProvider extends ChangeNotifier {
  FontScale _fontScale = FontScale.medium;
  MapStyle _mapStyle = MapStyle.standard;
  MarkerStyle _markerStyle = MarkerStyle.pin;
  Color _accentColor = const Color(0xFF2ECC71);
  List<String> _featuredBuildings = ['45', '104', '5'];

  FontScale get fontScale => _fontScale;
  MapStyle get mapStyle => _mapStyle;
  MarkerStyle get markerStyle => _markerStyle;
  Color get accentColor => _accentColor;
  List<String> get featuredBuildings => List.unmodifiable(_featuredBuildings);

  static const _kFontScale = 'settings_font_scale';
  static const _kMapStyle = 'settings_map_style';
  static const _kMarkerStyle = 'settings_marker_style';
  static const _kAccentColor = 'settings_accent_color';
  static const _kFeatured = 'settings_featured_buildings';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    _fontScale = FontScale.values[prefs.getInt(_kFontScale) ?? 1];
    _mapStyle = MapStyle.values[prefs.getInt(_kMapStyle) ?? 0];
    _markerStyle = MarkerStyle.values[prefs.getInt(_kMarkerStyle) ?? 0];

    final colorValue = prefs.getInt(_kAccentColor);
    if (colorValue != null) _accentColor = Color(colorValue);

    final saved = prefs.getStringList(_kFeatured);
    if (saved != null && saved.isNotEmpty) _featuredBuildings = saved;

    notifyListeners();
  }

  Future<void> setFontScale(FontScale v) async {
    if (_fontScale == v) return;
    _fontScale = v;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kFontScale, v.index);
  }

  Future<void> setMapStyle(MapStyle v) async {
    if (_mapStyle == v) return;
    _mapStyle = v;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kMapStyle, v.index);
  }

  Future<void> setMarkerStyle(MarkerStyle v) async {
    if (_markerStyle == v) return;
    _markerStyle = v;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kMarkerStyle, v.index);
  }

  Future<void> setAccentColor(Color v) async {
    if (_accentColor == v) return;
    _accentColor = v;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kAccentColor, v.toARGB32());
  }

  Future<void> setFeaturedBuildings(List<String> v) async {
    _featuredBuildings = v;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kFeatured, v);
  }

  Future<void> resetToDefaults() async {
    _fontScale = FontScale.medium;
    _mapStyle = MapStyle.standard;
    _markerStyle = MarkerStyle.pin;
    _accentColor = const Color(0xFF2ECC71);
    _featuredBuildings = ['45', '104', '5'];
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kFontScale);
    await prefs.remove(_kMapStyle);
    await prefs.remove(_kMarkerStyle);
    await prefs.remove(_kAccentColor);
    await prefs.remove(_kFeatured);
  }
}
