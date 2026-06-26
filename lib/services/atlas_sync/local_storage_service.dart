// local_storage_service.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:district_navigation_app/services/atlas_sync/i_local_storage_service.dart';

class LocalStorageService implements ILocalStorageService {
  static const String _hashFileName = 'district.hash256';
  static const String _kmlFileName = 'district.kml';

  Future<File> _getFile(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName');
  }

  @override
  Future<String?> readHash() async {
    try {
      final file = await _getFile(_hashFileName);
      if (!await file.exists()) return null;
      return await file.readAsString();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> writeHash(String hash) async {
    final file = await _getFile(_hashFileName);
    await file.writeAsString(hash);
  }

  @override
  Future<String?> readKml() async {
    try {
      final file = await _getFile(_kmlFileName);
      if (!await file.exists()) return null;
      return await file.readAsString();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> writeKml(String kml) async {
    final file = await _getFile(_kmlFileName);
    await file.writeAsString(kml);
  }
}
