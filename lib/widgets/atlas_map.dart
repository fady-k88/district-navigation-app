import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:district_navigation_app/models/building.dart';

class AtlasMap extends StatelessWidget {
  final List<Building> buildings;
  final Building? selected;
  final LatLng center;
  final MapController mapController;
  final void Function(Building) onTap;

  const AtlasMap({
    super.key,
    required this.buildings,
    required this.selected,
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
        // OSM tile layer — free, no key
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
                  color: isSelected ? Colors.red : Colors.blue,
                  size: 30,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
