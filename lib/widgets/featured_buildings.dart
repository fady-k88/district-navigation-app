import 'package:flutter/material.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';
import 'package:district_navigation_app/themes/app_dimensions.dart';

class FeaturedBuildings extends StatelessWidget {
  final List<String> buildings;
  final Function(String) onTap;

  const FeaturedBuildings({
    super.key,
    required this.buildings,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final d = AppDimensions(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(d.paddingM, 0, d.paddingM, d.paddingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Scrollable chip list — takes remaining space ─────────────────
          // Expanded + SingleChildScrollView is the canonical Flutter pattern
          // for a horizontal list that must not overflow its parent Row.
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              // reverse: true keeps the first chip at the right for RTL UX.
              reverse: true,
              child: Row(
                children: buildings.map((number) {
                  return Padding(
                    padding: EdgeInsets.only(left: d.paddingS),
                    child: _FeaturedChip(
                      label: 'عمارة $number',
                      onTap: () => onTap(number),
                      d: d,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(width: d.paddingS),

          // ── Label — fixed, never pushed out ─────────────────────────────
          // No Flexible needed here because Expanded above already consumed
          // all remaining space; this Text only needs its intrinsic width.
          Text(
            ':البنايات المميزة',
            style: TextStyle(
              color: AtlasColors.textSecondary,
              fontSize: d.fontS,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Individual chip ─────────────────────────────────────────────────────────

class _FeaturedChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final AppDimensions d;

  const _FeaturedChip({
    required this.label,
    required this.onTap,
    required this.d,
  });

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
          borderRadius: BorderRadius.circular(d.borderRadius),
          border: Border.all(color: AtlasColors.chipBorder),
        ),
        child: Text(
          label,
          style: TextStyle(color: AtlasColors.textPrimary, fontSize: d.fontS),
        ),
      ),
    );
  }
}
