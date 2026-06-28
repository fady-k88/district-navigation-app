import 'package:flutter/material.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';
import 'package:district_navigation_app/themes/app_dimensions.dart';

class AtlasFooter extends StatelessWidget {
  const AtlasFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final d = AppDimensions(context);

    return Container(
      // Adds bottom padding equal to the system navigation-bar height
      padding: EdgeInsets.fromLTRB(
        d.paddingL,
        d.paddingS,
        d.paddingL,
        d.paddingS + MediaQuery.of(context).padding.bottom,
      ),
      color: AtlasColors.surface.withOpacity(0.95),
      child: Row(
        // Pushes the copyright to the far right side and the guide link to the far left side
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection
            .rtl, // Mirrors the Row children positioning logic for RTL layout mapping
        children: [
          // ── Copyright (Positions on the Right Side) ────────────────────────
          Flexible(
            child: Text(
              'أطلس حدائق أكتوبر © 2026',
              textDirection: TextDirection
                  .rtl, // Safe-guards numbers and copyright glyph sequence parsing
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: AtlasColors.textSecondary,
                fontSize: d.fontXS,
              ),
            ),
          ),

          // ── "User guide" link (Positions on the Left Side) ─────────────────
          Flexible(
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'دليل الاستخدام الفني',
                textDirection: TextDirection
                    .rtl, // Forces proper internal glyph rendering directionality
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: AtlasColors.primary,
                  fontSize: d.fontS,
                  decoration: TextDecoration.underline,
                  decorationColor: AtlasColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
