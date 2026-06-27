import 'package:flutter/material.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Row(
                children: buildings.map((number) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _FeaturedChip(
                      label: 'عمارة $number',
                      onTap: () => onTap(number),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            ':البنايات المميزة',
            style: TextStyle(color: AtlasColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _FeaturedChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FeaturedChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AtlasColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AtlasColors.chipBorder),
        ),
        child: Text(
          label,
          style: const TextStyle(color: AtlasColors.textPrimary, fontSize: 12),
        ),
      ),
    );
  }
}
