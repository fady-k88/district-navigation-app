import 'package:district_navigation_app/models/building.dart';
import 'package:district_navigation_app/services/atlas_sync/i_remote_kml_service.dart';
import 'package:district_navigation_app/services/atlas_sync/i_remote_hash_service.dart';
import 'package:district_navigation_app/services/atlas_sync/i_local_storage_service.dart';
import 'package:district_navigation_app/services/atlas_sync/i_hash_comparison_service.dart';
import 'package:district_navigation_app/services/atlas_sync/i_kml_parser_service.dart';

class AtlasSyncService {
  final IRemoteHashService _remoteHash;
  final IRemoteKmlService _remoteKml;
  final ILocalStorageService _storage;
  final IHashComparisonService _hashComparison;
  final IKmlParserService _parser;

  AtlasSyncService({
    required IRemoteHashService remoteHash,
    required IRemoteKmlService remoteKml,
    required ILocalStorageService storage,
    required IHashComparisonService hashComparison,
    required IKmlParserService parser,
  }) : _remoteHash = remoteHash,
       _remoteKml = remoteKml,
       _storage = storage,
       _hashComparison = hashComparison,
       _parser = parser;

  Future<List<Building>> sync() async {
    final remoteHash = await _remoteHash.fetchRemoteHash();
    final localHash = await _storage.readHash();

    if (!_hashComparison.hasChanged(remoteHash, localHash)) {
      final cachedKml = await _storage.readKml();
      return _parser.parse(cachedKml!);
    }

    final kmlContent = await _remoteKml.fetchKmlContent();
    await _storage.writeKml(kmlContent);
    await _storage.writeHash(remoteHash);
    return _parser.parse(kmlContent);
  }
}
