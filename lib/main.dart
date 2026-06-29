// main.dart
import 'package:district_navigation_app/app/district_navigation_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:district_navigation_app/repositories/atlas_repository.dart';
import 'package:district_navigation_app/providers/atlas_sync_provider.dart';
import 'package:district_navigation_app/providers/atlas_search_provider.dart';
import 'package:district_navigation_app/providers/settings_provider.dart';
import 'package:district_navigation_app/services/atlas_sync/remote_kml_service.dart';
import 'package:district_navigation_app/services/atlas_sync/atlas_sync_service.dart';
import 'package:district_navigation_app/services/atlas_sync/kml_parser_service.dart';
import 'package:district_navigation_app/services/atlas_sync/remote_hash_service.dart';
import 'package:district_navigation_app/services/atlas_sync/local_storage_service.dart';
import 'package:district_navigation_app/services/atlas_sync/hash_comparison_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Load persisted settings before the first frame ──────────────────────
  final settingsProvider = SettingsProvider();
  await settingsProvider.load();

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
        // Settings must be first — other widgets depend on it via context.watch
        ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider),
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
  // Remove the native splash immediately after Flutter starts
  FlutterNativeSplash.remove();
}
