import 'package:flutter/material.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';

class AtlasFooter extends StatelessWidget {
  const AtlasFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AtlasColors.surface.withOpacity(0.95),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {},
            child: const Text(
              'دليل الاستخدام الفني',
              style: TextStyle(
                color: AtlasColors.primary,
                fontSize: 12,
                decoration: TextDecoration.underline,
                decorationColor: AtlasColors.primary,
              ),
            ),
          ),
          const Text(
            'أطلس حدائق أكتوبر © 2026',
            style: TextStyle(color: AtlasColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
