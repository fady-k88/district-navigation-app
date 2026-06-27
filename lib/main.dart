import 'package:district_navigation_app/app/district_navigation_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:district_navigation_app/repositories/atlas_repository.dart';
import 'package:district_navigation_app/providers/atlas_sync_provider.dart';
import 'package:district_navigation_app/providers/atlas_search_provider.dart';
import 'package:district_navigation_app/services/atlas_sync/remote_kml_service.dart';
import 'package:district_navigation_app/services/atlas_sync/atlas_sync_service.dart';
import 'package:district_navigation_app/services/atlas_sync/kml_parser_service.dart';
import 'package:district_navigation_app/services/atlas_sync/remote_hash_service.dart';
import 'package:district_navigation_app/services/atlas_sync/local_storage_service.dart';
import 'package:district_navigation_app/services/atlas_sync/hash_comparison_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = AtlasRepository();
  final syncService = AtlasSyncService(
    remoteHash: RemoteHashService(),
    remoteKml: RemoteKmlService(),
    storage: LocalStorageService(),
    hashComparison: HashComparisonService(),
    parser: KmlParserService(),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AtlasSyncProvider(
            syncService: syncService,
            repository: repository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AtlasSearchProvider(repository: repository),
        ),
      ],
      child: const DistrictNavigationApp(),
    ),
  );
}
