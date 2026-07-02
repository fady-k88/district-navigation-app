import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:district_navigation_app/widgets/info_sheet.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';
import 'package:district_navigation_app/providers/ad_provider.dart';
import 'package:district_navigation_app/themes/app_dimensions.dart';
import 'package:district_navigation_app/providers/settings_provider.dart';
import 'package:district_navigation_app/widgets/settings_bottom_sheet.dart';

class AtlasAppBar extends StatelessWidget {
  final VoidCallback onCompassTap;
  const AtlasAppBar({super.key, required this.onCompassTap});

  @override
  Widget build(BuildContext context) {
    final d = AppDimensions(context);
    final accentColor = context.watch<SettingsProvider>().accentColor;

    return Padding(
      padding: EdgeInsets.fromLTRB(d.paddingM, d.paddingM, d.paddingM, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Left Side: Actions Group (Compass + Tools) ─────────────────────
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onCompassTap,
                  customBorder: const CircleBorder(),
                  child: SizedBox(
                    width: d.compassSize,
                    height: d.compassSize,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        // Compass circle uses the live accent color
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.explore,
                        color: Colors.white,
                        size: d.iconM,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: d.paddingS),
              _ToolbarIcon(
                icon: Icons.info_outline,
                onTap: () {
                  final adProvider = context.read<AdProvider>();
                  InfoSheet.show(context).whenComplete(() {
                    adProvider.reloadSlot(AdSlot.infoSheet);
                  });
                },
                d: d,
              ),
              SizedBox(width: d.paddingS * 0.75),
              // ── Tune button now opens the settings sheet ──────────────────
              _ToolbarIcon(
                icon: Icons.tune,
                active: true,
                onTap: () {
                  final adProvider = context.read<AdProvider>();
                  SettingsBottomSheet.show(context).whenComplete(() {
                    adProvider.reloadSlot(AdSlot.settingsSheet);
                  });
                },
                d: d,
              ),
            ],
          ),

          SizedBox(width: d.paddingM),

          // ── Right Side: App Title ─────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'أطلس حدائق أكتوبر',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: AtlasColors.textPrimary,
                    fontSize: d.fontS,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: d.paddingXS * 0.5),
                Text(
                  'نظام الخرائط والملاحة',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: AtlasColors.textSecondary,
                    fontSize: d.fontXS,
                  ),
                ),
                SizedBox(height: d.paddingXS * 0.5),
                Text(
                  'لعمارات مشاريع حدائق أكتوبر',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: AtlasColors.textSecondary,
                    fontSize: d.fontXS,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Private toolbar icon button ─────────────────────────────────────────────

class _ToolbarIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  final AppDimensions d;

  const _ToolbarIcon({
    required this.icon,
    this.active = false,
    required this.onTap,
    required this.d,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(d.borderRadiusS * 0.8);
    final bg = active ? AtlasColors.accent : AtlasColors.surfaceLight;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: SizedBox(
          width: d.toolbarIconSize,
          height: d.toolbarIconSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: borderRadius,
              border: Border.all(color: AtlasColors.chipBorder),
            ),
            child: Icon(
              icon,
              color: active ? Colors.white : AtlasColors.textSecondary,
              size: d.iconS,
            ),
          ),
        ),
      ),
    );
  }
}
