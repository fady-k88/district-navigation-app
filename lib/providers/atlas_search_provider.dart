import 'package:flutter/material.dart';
import 'package:district_navigation_app/models/building.dart';
import 'package:district_navigation_app/repositories/atlas_repository.dart';

class AtlasSearchProvider extends ChangeNotifier {
  final AtlasRepository _repository;

  String? _selectedProject;
  String _query = '';
  List<Building> _results = [];

  AtlasSearchProvider({required AtlasRepository repository})
    : _repository = repository;

  // getters
  String? get selectedProject => _selectedProject;
  String get query => _query;
  List<Building> get results => _results;
  List<String> get projects => _repository.projects;

  // select project from dropdown
  void selectProject(String project) {
    _selectedProject = project;
    _query = '';
    _results = _repository.buildingsFor(project);
    notifyListeners();
  }

  // search by building number
  void search(String query) {
    _query = query;
    if (_selectedProject == null) return;
    _results = query.isEmpty
        ? _repository.buildingsFor(_selectedProject!)
        : _repository.search(_selectedProject!, query);
    notifyListeners();
  }

  // find exact building for navigation
  Building? findBuilding(String number) {
    if (_selectedProject == null) return null;
    return _repository.find(_selectedProject!, number);
  }

  // Add this method to your AtlasSearchProvider class
  void selectDefaultProjectIfNone() {
    if (_selectedProject == null && projects.isNotEmpty) {
      selectProject(projects.first);
    }
  }

  void clear() {
    _query = '';
    _results = _selectedProject != null
        ? _repository.buildingsFor(_selectedProject!)
        : [];
    notifyListeners();
  }
}
