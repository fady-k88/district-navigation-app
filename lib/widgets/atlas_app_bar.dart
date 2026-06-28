import 'package:flutter/material.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';
import 'package:district_navigation_app/themes/app_dimensions.dart';

class AtlasAppBar extends StatelessWidget {
  const AtlasAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final d = AppDimensions(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(d.paddingM, d.paddingM, d.paddingM, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        // Distributes space evenly between the left actions group and the right title
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
                  onTap: () {},
                  customBorder: const CircleBorder(),
                  child: SizedBox(
                    width: d.compassSize,
                    height: d.compassSize,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AtlasColors.primary,
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
              _ToolbarIcon(icon: Icons.info_outline, onTap: () {}, d: d),
              SizedBox(width: d.paddingS * 0.75),
              _ToolbarIcon(icon: Icons.tune, active: true, onTap: () {}, d: d),
            ],
          ),

          SizedBox(width: d.paddingM), // Guaranteed minimum breathing room gap
          // ── Right Side: App Title (Demands all remaining viewport width) ──
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

// ─── Private toolbar icon button ────────────────────────────────────────────

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
              color: active ? AtlasColors.accent : AtlasColors.surfaceLight,
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
