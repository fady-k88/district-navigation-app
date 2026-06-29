import 'package:flutter/material.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';
import 'package:district_navigation_app/themes/app_dimensions.dart';
import 'package:district_navigation_app/services/url_launch/url_launcher_service.dart';

class AtlasFooter extends StatelessWidget {
  const AtlasFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final d = AppDimensions(context);

    return Container(
      padding: EdgeInsets.fromLTRB(
        d.paddingL,
        d.paddingS,
        d.paddingL,
        d.paddingS,
      ),
      color: AtlasColors.surface.withOpacity(0.95),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl,
        children: [
          // ── Copyright ─────────────────────────────────────────────────────
          Flexible(
            child: Text(
              'أطلس حدائق أكتوبر © 2026',
              textDirection: TextDirection.rtl,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: AtlasColors.textSecondary,
                fontSize: d.fontXS,
              ),
            ),
          ),

          // ── User guide link ───────────────────────────────────────────────
          Flexible(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                onTap: () => UrlLauncherService.launchURL(
                  'https://atlas-hadayek-october.pages.dev',
                ),
                borderRadius: BorderRadius.circular(d.borderRadiusS * 0.5),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: d.paddingXS,
                    vertical: d.paddingXS * 0.5,
                  ),
                  child: Text(
                    'دليل الاستخدام الفني',
                    textDirection: TextDirection.rtl,
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
            ),
          ),
        ],
      ),
    );
  }
}
