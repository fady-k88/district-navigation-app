// widgets/settings_sheet.dart
import 'package:district_navigation_app/providers/ad_provider.dart';
import 'package:district_navigation_app/widgets/banner_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';
import 'package:district_navigation_app/themes/app_dimensions.dart';
import 'package:district_navigation_app/providers/settings_provider.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<SettingsProvider>(),
        child: const SettingsBottomSheet(),
      ),
    );
  }

  @override
  State<SettingsBottomSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsBottomSheet> {
  late TextEditingController _featuredCtrl;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>();
    _featuredCtrl = TextEditingController(
      text: settings.featuredBuildings.join(', '),
    );
  }

  @override
  void dispose() {
    _featuredCtrl.dispose();
    super.dispose();
  }

  void _onFeaturedChanged(String raw, SettingsProvider settings) {
    final nums = raw
        .split(RegExp(r'[,،\s]+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    settings.setFeaturedBuildings(nums);
  }

  @override
  Widget build(BuildContext context) {
    final d = AppDimensions(context);

    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return SafeArea(
          bottom: false,
          child: Container(
            margin: EdgeInsets.fromLTRB(d.paddingM, 0, d.paddingM, d.paddingM),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.90,
            ),
            decoration: BoxDecoration(
              color: AtlasColors.surface,
              borderRadius: BorderRadius.circular(d.borderRadius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Drag handle ──────────────────────────────────────────────
                SizedBox(height: d.paddingM),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AtlasColors.chipBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: d.paddingM),

                // ── Sheet header ─────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: d.paddingL),
                  child: Row(
                    children: [
                      _ResetButton(
                        d: d,
                        onTap: () => _confirmReset(context, settings),
                      ),
                      const Spacer(),
                      Text(
                        'الإعدادات',
                        style: TextStyle(
                          color: AtlasColors.textPrimary,
                          fontSize: d.fontXL,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.tune,
                        color: settings.accentColor,
                        size: d.iconM,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: d.paddingM),
                Divider(color: AtlasColors.chipBorder, height: 1),

                // ── Scrollable body ──────────────────────────────────────────
                Flexible(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: d.paddingL,
                      vertical: d.paddingM,
                    ),
                    shrinkWrap: true,
                    children: [
                      // ── 1. Accent Color ──────────────────────────────────
                      _SectionHeader(title: 'لون التمييز', d: d),
                      SizedBox(height: d.paddingS),
                      _AccentColorPicker(settings: settings, d: d),

                      SizedBox(height: d.paddingL),

                      // ── 2. Font Size ─────────────────────────────────────
                      _SectionHeader(title: 'حجم الخط', d: d),
                      SizedBox(height: d.paddingS),
                      _SegmentedRow<FontScale>(
                        values: FontScale.values,
                        selected: settings.fontScale,
                        label: (v) => v.label,
                        onTap: settings.setFontScale,
                        accentColor: settings.accentColor,
                        d: d,
                      ),

                      SizedBox(height: d.paddingL),

                      // ── 3. Map Style ─────────────────────────────────────
                      _SectionHeader(title: 'نمط الخريطة', d: d),
                      SizedBox(height: d.paddingS),
                      _IconSegmentedRow<MapStyle>(
                        values: MapStyle.values,
                        selected: settings.mapStyle,
                        label: (v) => v.label,
                        icon: (v) => v.icon,
                        onTap: settings.setMapStyle,
                        accentColor: settings.accentColor,
                        d: d,
                      ),

                      SizedBox(height: d.paddingL),

                      // ── 4. Marker Style ──────────────────────────────────
                      _SectionHeader(title: 'شكل علامة المبنى', d: d),
                      SizedBox(height: d.paddingS),
                      _IconSegmentedRow<MarkerStyle>(
                        values: MarkerStyle.values,
                        selected: settings.markerStyle,
                        label: (v) => v.label,
                        icon: (v) => v.icon,
                        onTap: settings.setMarkerStyle,
                        accentColor: settings.accentColor,
                        d: d,
                      ),

                      SizedBox(height: d.paddingL),

                      // ── 5. Featured buildings ────────────────────────────
                      _SectionHeader(title: 'البنايات المميزة', d: d),
                      SizedBox(height: d.paddingXS),
                      Text(
                        'أدخل أرقام العمارات مفصولة بفاصلة',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: AtlasColors.textSecondary,
                          fontSize: d.fontS,
                        ),
                      ),
                      SizedBox(height: d.paddingS),
                      _FeaturedBuildingsField(
                        controller: _featuredCtrl,
                        accentColor: settings.accentColor,
                        d: d,
                        onChanged: (v) => _onFeaturedChanged(v, settings),
                      ),

                      // ── Banner Ad ────────────────────────────────────────────────────────
                      SizedBox(height: d.paddingM),
                      const BannerAdWidget(slot: AdSlot.settingsSheet),

                      SizedBox(
                        height:
                            d.paddingM + MediaQuery.of(context).padding.bottom,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmReset(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AtlasColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions(context).borderRadius,
            ),
          ),
          title: Text(
            'إعادة الضبط',
            style: TextStyle(color: AtlasColors.textPrimary),
          ),
          content: Text(
            'هل تريد إعادة جميع الإعدادات إلى القيم الافتراضية؟',
            style: TextStyle(color: AtlasColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إلغاء',
                style: TextStyle(color: AtlasColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                settings.resetToDefaults();
                _featuredCtrl.text = settings.featuredBuildings.join(', ');
                Navigator.pop(context);
              },
              child: Text(
                'إعادة الضبط',
                style: TextStyle(color: AtlasColors.danger),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Sub-widgets
// ══════════════════════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  final String title;
  final AppDimensions d;
  const _SectionHeader({required this.title, required this.d});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          color: AtlasColors.textPrimary,
          fontSize: d.fontM,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _AccentColorPicker extends StatelessWidget {
  final SettingsProvider settings;
  final AppDimensions d;
  const _AccentColorPicker({required this.settings, required this.d});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: kAccentOptions.map((opt) {
          final isSelected = settings.accentColor == opt.color;
          return Padding(
            padding: EdgeInsets.only(left: d.paddingS),
            child: GestureDetector(
              onTap: () => settings.setAccentColor(opt.color),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: opt.color,
                  borderRadius: BorderRadius.circular(d.borderRadiusS),
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 3)
                      : Border.all(color: Colors.transparent, width: 3),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: opt.color.withValues(alpha: 0.6),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 22)
                    : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SegmentedRow<T> extends StatelessWidget {
  final List<T> values;
  final T selected;
  final String Function(T) label;
  final void Function(T) onTap;
  final Color accentColor;
  final AppDimensions d;

  const _SegmentedRow({
    required this.values,
    required this.selected,
    required this.label,
    required this.onTap,
    required this.accentColor,
    required this.d,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: values.reversed.map((v) {
        final isSelected = v == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTap(v),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.symmetric(horizontal: d.paddingXS * 0.5),
              padding: EdgeInsets.symmetric(vertical: d.paddingS),
              decoration: BoxDecoration(
                color: isSelected ? accentColor : AtlasColors.surfaceLight,
                borderRadius: BorderRadius.circular(d.borderRadiusS),
                border: Border.all(
                  color: isSelected ? accentColor : AtlasColors.chipBorder,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                label(v),
                style: TextStyle(
                  color: isSelected ? Colors.white : AtlasColors.textSecondary,
                  fontSize: d.fontS,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _IconSegmentedRow<T> extends StatelessWidget {
  final List<T> values;
  final T selected;
  final String Function(T) label;
  final IconData Function(T) icon;
  final void Function(T) onTap;
  final Color accentColor;
  final AppDimensions d;

  const _IconSegmentedRow({
    required this.values,
    required this.selected,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.accentColor,
    required this.d,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: values.reversed.map((v) {
        final isSelected = v == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTap(v),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.symmetric(horizontal: d.paddingXS * 0.5),
              padding: EdgeInsets.symmetric(vertical: d.paddingS),
              decoration: BoxDecoration(
                color: isSelected ? accentColor : AtlasColors.surfaceLight,
                borderRadius: BorderRadius.circular(d.borderRadiusS),
                border: Border.all(
                  color: isSelected ? accentColor : AtlasColors.chipBorder,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon(v),
                    color: isSelected
                        ? Colors.white
                        : AtlasColors.textSecondary,
                    size: d.iconS,
                  ),
                  SizedBox(height: d.paddingXS * 0.5),
                  Text(
                    label(v),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AtlasColors.textSecondary,
                      fontSize: d.fontXS,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _FeaturedBuildingsField extends StatelessWidget {
  final TextEditingController controller;
  final Color accentColor;
  final AppDimensions d;
  final void Function(String) onChanged;

  const _FeaturedBuildingsField({
    required this.controller,
    required this.accentColor,
    required this.d,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      keyboardType: TextInputType.number,
      style: TextStyle(color: AtlasColors.textPrimary, fontSize: d.fontM),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'مثال: 45, 104, 5',
        hintTextDirection: TextDirection.rtl,
        hintStyle: TextStyle(
          color: AtlasColors.textSecondary,
          fontSize: d.fontM,
        ),
        filled: true,
        fillColor: AtlasColors.surfaceLight,
        contentPadding: EdgeInsets.symmetric(
          horizontal: d.paddingM,
          vertical: d.paddingS,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(d.borderRadiusS),
          borderSide: const BorderSide(color: AtlasColors.chipBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(d.borderRadiusS),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
      ),
    );
  }
}

class _ResetButton extends StatelessWidget {
  final AppDimensions d;
  final VoidCallback onTap;
  const _ResetButton({required this.d, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: d.paddingM,
          vertical: d.paddingS,
        ),
        decoration: BoxDecoration(
          color: AtlasColors.surfaceLight,
          borderRadius: BorderRadius.circular(d.borderRadiusS),
          border: Border.all(color: AtlasColors.chipBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.restart_alt, color: AtlasColors.danger, size: d.iconS),
            SizedBox(width: d.paddingXS),
            Text(
              'إعادة الضبط',
              style: TextStyle(color: AtlasColors.danger, fontSize: d.fontS),
            ),
          ],
        ),
      ),
    );
  }
}
