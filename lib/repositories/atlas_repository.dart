// repositories/atlas_repository.dart
import 'package:district_navigation_app/models/building.dart';
import 'package:district_navigation_app/models/district.dart';

class AtlasRepository {
  List<Building> _buildings = [];

  // called once after sync completes
  void load(List<Building> buildings) {
    _buildings = buildings;
  }

  // all projects
  List<String> get projects => District.projectsFrom(_buildings);

  // all buildings for a project
  List<Building> buildingsFor(String project) =>
      District.buildingsFor(_buildings, project);

  // search within a project
  List<Building> search(String project, String query) =>
      District.search(_buildings, project, query);

  // find exact building
  Building? find(String project, String number) {
    try {
      return _buildings.firstWhere(
        (b) => b.project == project && b.number == number,
      );
    } catch (_) {
      return null;
    }
  }

  bool get isEmpty => _buildings.isEmpty;
  int get totalBuildings => _buildings.length;
}
