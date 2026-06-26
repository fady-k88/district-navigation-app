// providers/atlas_sync_provider.dart
import 'package:flutter/material.dart';
import 'package:district_navigation_app/repositories/atlas_repository.dart';
import 'package:district_navigation_app/services/atlas_sync/atlas_sync_service.dart';

enum SyncStatus { idle, loading, success, error }

class AtlasSyncProvider extends ChangeNotifier {
  final AtlasSyncService _syncService;
  final AtlasRepository _repository;

  SyncStatus _status = SyncStatus.idle;
  String? _errorMessage;

  AtlasSyncProvider({
    required AtlasSyncService syncService,
    required AtlasRepository repository,
  }) : _syncService = syncService,
       _repository = repository;

  SyncStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == SyncStatus.loading;
  bool get hasError => _status == SyncStatus.error;
  bool get isReady => _status == SyncStatus.success;

  Future<void> sync() async {
    _status = SyncStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final buildings = await _syncService.sync();
      _repository.load(buildings);
      _status = SyncStatus.success;
    } catch (e) {
      _status = SyncStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }
}
