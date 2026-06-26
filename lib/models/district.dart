// models/district.dart
import 'package:district_navigation_app/models/building.dart';

class District {
  // District name
  final String name;

  // Buildings that exist in the district
  final List<Building> buildings;

  // District constructor requires name and buildings
  const District({required this.name, required this.buildings});

  // all unique project names across all buildings
  static List<String> projectsFrom(List<Building> buildings) {
    return buildings.map((b) => b.project).toSet().toList();
  }

  // filter buildings by project
  static List<Building> buildingsFor(List<Building> buildings, String project) {
    return buildings.where((b) => b.project == project).toList();
  }

  // search by number within a project
  static List<Building> search(
    List<Building> buildings,
    String project,
    String query,
  ) {
    return buildings
        .where((b) => b.project == project && b.number.contains(query.trim()))
        .toList();
  }
}
