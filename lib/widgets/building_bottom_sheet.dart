import 'package:flutter/material.dart';
import 'package:district_navigation_app/models/building.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';

class BuildingBottomSheet extends StatefulWidget {
  final Building building;
  final VoidCallback onNavigate;
  final VoidCallback onClose;

  const BuildingBottomSheet({
    super.key,
    required this.building,
    required this.onNavigate,
    required this.onClose,
  });

  @override
  State<BuildingBottomSheet> createState() => _BuildingBottomSheetState();
}

class _BuildingBottomSheetState extends State<BuildingBottomSheet> {
  bool _navigating = false;

  @override
  Widget build(BuildContext context) {
    final b = widget.building;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: AtlasColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AtlasColors.chipBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Header row — close + title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AtlasColors.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AtlasColors.chipBorder),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AtlasColors.textSecondary,
                      size: 16,
                    ),
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'عمارة رقم ${b.number}',
                      style: const TextStyle(
                        color: AtlasColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      b.project,
                      style: const TextStyle(
                        color: AtlasColors.primary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Coordinates card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AtlasColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _CoordRow(
                    label: 'خط الطول:',
                    value: b.longitude.toStringAsFixed(7),
                  ),
                  const SizedBox(height: 8),
                  _CoordRow(
                    label: 'دائرة العرض:',
                    value: b.latitude.toStringAsFixed(7),
                  ),
                  const SizedBox(height: 8),
                  const _CoordRow(label: 'الارتفاع:', value: 'غير متوفر'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Navigation button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _navigating
                      ? AtlasColors.danger
                      : AtlasColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_navigating) {
                    setState(() => _navigating = false);
                  } else {
                    setState(() => _navigating = true);
                    widget.onNavigate();
                  }
                },
                icon: Icon(
                  _navigating ? Icons.close : Icons.navigation,
                  color: Colors.white,
                  size: 18,
                ),
                label: Text(
                  _navigating
                      ? 'إنهاء الملاحة الفورية'
                      : '(Start Navigation) ابدأ الملاحة الفورية',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Ad space
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AtlasColors.chipBorder),
              ),
              child: const Center(
                child: Text(
                  'مساحة إعلانية',
                  style: TextStyle(
                    color: AtlasColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _CoordRow extends StatelessWidget {
  final String label;
  final String value;

  const _CoordRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: const TextStyle(color: AtlasColors.textPrimary, fontSize: 13),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AtlasColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
