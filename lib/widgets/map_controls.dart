import 'package:flutter/material.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';
import 'package:district_navigation_app/themes/app_dimensions.dart';

class MapControls extends StatelessWidget {
  final Future<void> Function() onMyLocation;
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
    final d = AppDimensions(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MapControlButton(
          icon: Icons.my_location,
          label: 'موقعي',
          onTap: onMyLocation,
          d: d,
        ),
        SizedBox(height: d.paddingS),
        _MapControlButton(
          icon: Icons.center_focus_strong,
          label: 'المركز',
          onTap: () async => onCenter(),
          d: d,
        ),
        SizedBox(height: d.paddingS),

        // ── Zoom ± combined button ────────────────────────────────────────
        // Width matches the other control buttons exactly.
        // BoxConstraints() on IconButton removes Flutter's default 48 × 48
        // minimum touch target — we add our own explicit padding instead.
        Container(
          width: d.mapControlWidth,
          decoration: BoxDecoration(
            color: AtlasColors.surface,
            borderRadius: BorderRadius.circular(d.borderRadiusS),
            border: Border.all(color: AtlasColors.chipBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onZoomIn,
                padding: EdgeInsets.symmetric(vertical: d.paddingS),
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.add,
                  color: AtlasColors.textPrimary,
                  size: d.iconS,
                ),
              ),
              Container(height: 1, color: AtlasColors.chipBorder),
              IconButton(
                onPressed: onZoomOut,
                padding: EdgeInsets.symmetric(vertical: d.paddingS),
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.remove,
                  color: AtlasColors.textPrimary,
                  size: d.iconS,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Individual control button (location / center) ───────────────────────────

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Future<void> Function() onTap;
  final AppDimensions d;

  const _MapControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.d,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: d.mapControlWidth,
        padding: EdgeInsets.symmetric(vertical: d.paddingS),
        decoration: BoxDecoration(
          color: AtlasColors.surface,
          borderRadius: BorderRadius.circular(d.borderRadiusS),
          border: Border.all(color: AtlasColors.chipBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AtlasColors.primary, size: d.mapControlIconSize),
            SizedBox(height: d.paddingS * 0.25),
            Text(
              label,
              style: TextStyle(
                color: AtlasColors.textSecondary,
                fontSize: d.fontXS,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
