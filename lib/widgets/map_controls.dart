import 'package:flutter/material.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';

class MapControls extends StatelessWidget {
  final VoidCallback onMyLocation;
  final VoidCallback onCenter;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const MapControls({
    super.key,
    required this.onMyLocation,
    required this.onCenter,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MapControlButton(
          icon: Icons.my_location,
          label: 'موقعي',
          onTap: onMyLocation,
        ),
        const SizedBox(height: 8),
        _MapControlButton(
          icon: Icons.center_focus_strong,
          label: 'المركز',
          onTap: onCenter,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AtlasColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AtlasColors.chipBorder),
          ),
          child: Column(
            children: [
              IconButton(
                onPressed: onZoomIn,
                icon: const Icon(
                  Icons.add,
                  color: AtlasColors.textPrimary,
                  size: 18,
                ),
                tooltip: 'ZOOM',
              ),
              Container(height: 1, color: AtlasColors.chipBorder),
              IconButton(
                onPressed: onZoomOut,
                icon: const Icon(
                  Icons.remove,
                  color: AtlasColors.textPrimary,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MapControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AtlasColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AtlasColors.chipBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: AtlasColors.primary, size: 20),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: AtlasColors.textSecondary,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
