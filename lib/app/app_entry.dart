import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:district_navigation_app/providers/atlas_sync_provider.dart';
import 'package:district_navigation_app/screens/loading_screen.dart';
import 'package:district_navigation_app/screens/error_screen.dart';
import 'package:district_navigation_app/screens/main_screen.dart';

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AtlasSyncProvider>().sync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AtlasSyncProvider>(
      builder: (context, sync, _) {
        if (sync.isLoading) return const LoadingScreen();
        if (sync.hasError) return ErrorScreen(message: sync.errorMessage ?? '');
        if (sync.isReady) return const MainScreen();
        return const LoadingScreen();
      },
    );
  }
}
