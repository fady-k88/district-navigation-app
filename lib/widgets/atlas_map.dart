import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:district_navigation_app/models/building.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';

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
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(initialCenter: center, initialZoom: 15),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.district_navigation_app',
        ),

        // Building markers
        MarkerLayer(
          markers: buildings.map((b) {
            final isSelected = selected?.id == b.id;
            return Marker(
              point: LatLng(b.latitude, b.longitude),
              width: 30,
              height: 30,
              child: GestureDetector(
                onTap: () => onTap(b),
                child: Icon(
                  Icons.location_pin,
                  color: isSelected
                      ? AtlasColors.danger
                      : b.color, // ← b.color not red
                  size: 30,
                ),
              ),
            );
          }).toList(),
        ),

        // User location marker — green
        if (userLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: userLocation!,
                width: 40,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
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
}
