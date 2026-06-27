import 'package:flutter/material.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';

class AtlasAppBar extends StatelessWidget {
  const AtlasAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Row(
        children: [
          // Compass button
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AtlasColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.explore, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 8),

          // Toolbar icons
          _ToolbarIcon(icon: Icons.info_outline, onTap: () {}),
          const SizedBox(width: 6),
          _ToolbarIcon(icon: Icons.tune, active: true, onTap: () {}),
          const SizedBox(width: 6),
          _ToolbarIcon(icon: Icons.wb_sunny_outlined, onTap: () {}),
          const SizedBox(width: 6),
          _ToolbarIcon(icon: Icons.layers_outlined, onTap: () {}),
          const SizedBox(width: 6),

          // _ToolbarIcon(icon: Icons.logout, onTap: () {}),
          // const SizedBox(width: 6),

          // // Account button
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          //   decoration: BoxDecoration(
          //     color: AtlasColors.surfaceLight,
          //     borderRadius: BorderRadius.circular(20),
          //     border: Border.all(color: AtlasColors.chipBorder),
          //   ),
          //   child: const Row(
          //     children: [
          //       Icon(
          //         Icons.person_outline,
          //         color: AtlasColors.textSecondary,
          //         size: 16,
          //       ),
          //       SizedBox(width: 4),
          //       Text(
          //         'حساب',
          //         style: TextStyle(
          //           color: AtlasColors.textSecondary,
          //           fontSize: 12,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          const Spacer(),

          // App title
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'أطلس حدائق أكتوبر',
                style: TextStyle(
                  color: AtlasColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'نظام الخرائط والملاحة',
                style: TextStyle(
                  color: AtlasColors.textSecondary,
                  fontSize: 10,
                ),
              ),
              Text(
                'لعمارات مشاريع حدائق أكتوبر',
                style: TextStyle(
                  color: AtlasColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToolbarIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _ToolbarIcon({
    required this.icon,
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: active ? AtlasColors.accent : AtlasColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AtlasColors.chipBorder),
        ),
        child: Icon(
          icon,
          color: active ? Colors.white : AtlasColors.textSecondary,
          size: 18,
        ),
      ),
    );
  }
}
