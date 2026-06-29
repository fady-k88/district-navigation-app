// widgets/atlas_map.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:district_navigation_app/models/building.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';
import 'package:district_navigation_app/providers/settings_provider.dart';

class AtlasMap extends StatelessWidget {
  final List<Building> buildings;
  final Building? selected;
  final LatLng? userLocation;
  final LatLng center;
  final MapController mapController;
  final void Function(Building) onTap;

  const AtlasMap({
    super.key,
    required this.buildings,
    required this.selected,
    this.userLocation,
    required this.center,
    required this.mapController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final markerStyle = settings.markerStyle;
    final accentColor = settings.accentColor;

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(initialCenter: center, initialZoom: 15),
      children: [
        // ── Tile layer — switches based on mapStyle setting ──────────────────
        TileLayer(
          urlTemplate: settings.mapStyle.tileUrl,
          userAgentPackageName: 'com.example.district_navigation_app',
        ),

        // ── Building markers — style driven by markerStyle setting ────────────
        MarkerLayer(
          markers: buildings.map((b) {
            final isSelected = selected?.id == b.id;
            return Marker(
              point: LatLng(b.latitude, b.longitude),
              width: markerStyle == MarkerStyle.numbered ? 36 : 30,
              height: markerStyle == MarkerStyle.numbered ? 36 : 30,
              child: GestureDetector(
                onTap: () => onTap(b),
                child: _buildMarker(
                  b: b,
                  isSelected: isSelected,
                  style: markerStyle,
                  accentColor: accentColor,
                ),
              ),
            );
          }).toList(),
        ),

        // ── User location marker — green dot with ring ───────────────────────
        if (userLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: userLocation!,
                width: 40,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  child: const Icon(
                    Icons.circle,
                    color: Colors.green,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildMarker({
    required Building b,
    required bool isSelected,
    required MarkerStyle style,
    required Color accentColor,
  }) {
    final color = isSelected ? AtlasColors.danger : b.color;

    switch (style) {
      case MarkerStyle.pin:
        return Icon(Icons.location_pin, color: color, size: 30);

      case MarkerStyle.dot:
        return Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 4),
            ],
          ),
        );

      case MarkerStyle.numbered:
        return Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          alignment: Alignment.center,
          child: FittedBox(
            child: Text(
              b.number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        );
    }
  }
}
