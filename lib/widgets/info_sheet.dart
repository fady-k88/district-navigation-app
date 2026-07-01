import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';
import 'package:district_navigation_app/themes/app_dimensions.dart';
import 'package:district_navigation_app/providers/ad_provider.dart';
import 'package:district_navigation_app/widgets/banner_ad_widget.dart';
import 'package:district_navigation_app/providers/settings_provider.dart';

class InfoSheet extends StatelessWidget {
  const InfoSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<SettingsProvider>(),
        child: const InfoSheet(),
      ),
    );
  }

  // ── App constants — update these as needed ────────────────────────────────
  static const String _appName = 'أطلس حدائق أكتوبر';
  static const String _tagline = 'نظام الخرائط والملاحة';
  static const String _version = '1.0.0';
  static const String _developerName = 'اسم المطور أو الشركة';
  static const String _supportPhone = '+20 100 000 0000';
  static const String _supportEmail = 'support@example.com';
  static const String _socialUrl = 'https://facebook.com/example';
  static const String _socialLabel = 'صفحتنا على فيسبوك';

  @override
  Widget build(BuildContext context) {
    final d = AppDimensions(context);
    final accentColor = context.watch<SettingsProvider>().accentColor;

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: d.paddingM),

              // ── Drag handle ────────────────────────────────────────────────
              Center(
                child: Container(
                  width: d.compassSize,
                  height: d.paddingXS * 0.5,
                  decoration: BoxDecoration(
                    color: AtlasColors.chipBorder,
                    borderRadius: BorderRadius.circular(d.paddingXS * 0.25),
                  ),
                ),
              ),
              SizedBox(height: d.paddingL),

              // ── App identity block ─────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(d.paddingL),
                margin: EdgeInsets.symmetric(horizontal: d.paddingL),
                decoration: BoxDecoration(
                  color: AtlasColors.surfaceLight,
                  borderRadius: BorderRadius.circular(d.borderRadius),
                ),
                child: Column(
                  children: [
                    // App icon placeholder — replace with your actual logo
                    Container(
                      width: d.compassSize * 1.3,
                      height: d.compassSize * 1.3,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(d.borderRadius),
                      ),
                      child: Icon(
                        Icons.explore,
                        color: Colors.white,
                        size: d.iconL,
                      ),
                    ),
                    SizedBox(height: d.paddingM),
                    Text(
                      _appName,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: AtlasColors.textPrimary,
                        fontSize: d.fontXL,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: d.paddingXS),
                    Text(
                      _tagline,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: AtlasColors.textSecondary,
                        fontSize: d.fontS,
                      ),
                    ),
                    SizedBox(height: d.paddingS),
                    // Version badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: d.paddingM,
                        vertical: d.paddingXS,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(d.borderRadius),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        'الإصدار $_version',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: accentColor,
                          fontSize: d.fontXS,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: d.paddingM),

              // ── Info rows ──────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: d.paddingL),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.business_outlined,
                      label: 'المطور',
                      value: _developerName,
                      accentColor: accentColor,
                      d: d,
                    ),
                    SizedBox(height: d.paddingS),
                    _InfoRow(
                      icon: Icons.phone_outlined,
                      label: 'الدعم الفني',
                      value: _supportPhone,
                      accentColor: accentColor,
                      d: d,
                      onTap: () => _launch('tel:$_supportPhone'),
                      onLongPress: () => _copy(context, _supportPhone, d),
                    ),
                    SizedBox(height: d.paddingS),
                    _InfoRow(
                      icon: Icons.email_outlined,
                      label: 'البريد الإلكتروني',
                      value: _supportEmail,
                      accentColor: accentColor,
                      d: d,
                      onTap: () => _launch('mailto:$_supportEmail'),
                      onLongPress: () => _copy(context, _supportEmail, d),
                    ),
                    SizedBox(height: d.paddingS),
                    _InfoRow(
                      icon: Icons.link_outlined,
                      label: 'التواصل الاجتماعي',
                      value: _socialLabel,
                      accentColor: accentColor,
                      d: d,
                      onTap: () => _launch(_socialUrl),
                      isLink: true,
                    ),
                  ],
                ),
              ),

              // ── Banner Ad ──────────────────────────────────────────────────────────
              SizedBox(height: d.paddingM),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: d.paddingL),
                child: const BannerAdWidget(slot: AdSlot.infoSheet),
              ),

              SizedBox(
                height: d.paddingM + MediaQuery.of(context).padding.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _copy(BuildContext context, String text, AppDimensions d) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم النسخ',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: d.fontS),
        ),
        duration: const Duration(milliseconds: 1200),
        backgroundColor: AtlasColors.surfaceLight,
      ),
    );
  }
}

// ─── Info row ─────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;
  final AppDimensions d;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isLink;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
    required this.d,
    this.onTap,
    this.onLongPress,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.all(d.paddingM),
        decoration: BoxDecoration(
          color: AtlasColors.surfaceLight,
          borderRadius: BorderRadius.circular(d.borderRadiusS),
          border: Border.all(color: AtlasColors.chipBorder),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            // Icon
            Container(
              width: d.compassSize,
              height: d.compassSize,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(d.borderRadiusS * 0.7),
              ),
              child: Icon(icon, color: accentColor, size: d.iconS),
            ),
            SizedBox(width: d.paddingM),
            // Label + value
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: AtlasColors.textSecondary,
                      fontSize: d.fontXS,
                    ),
                  ),
                  SizedBox(height: d.paddingXS * 0.5),
                  Text(
                    value,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: isLink ? accentColor : AtlasColors.textPrimary,
                      fontSize: d.fontS,
                      fontWeight: FontWeight.w500,
                      decoration: isLink ? TextDecoration.underline : null,
                      decorationColor: isLink ? accentColor : null,
                    ),
                  ),
                ],
              ),
            ),
            // Tap indicator for actionable rows
            if (onTap != null) ...[
              SizedBox(width: d.paddingS),
              Icon(
                Icons.chevron_left,
                color: AtlasColors.textSecondary,
                size: d.iconS,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
