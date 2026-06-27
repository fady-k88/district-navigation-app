import 'dart:ui';

class Building {
  final String id;
  final String number;
  final String project;
  final double latitude;
  final double longitude;
  final Color color; // building color on map

  const Building({
    required this.id,
    required this.number,
    required this.project,
    required this.latitude,
    required this.longitude,
    required this.color,
  });
}
