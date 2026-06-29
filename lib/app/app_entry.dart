import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:district_navigation_app/providers/ad_provider.dart';
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
        Widget child;

        if (sync.isLoading) {
          child = const LoadingScreen(key: ValueKey('loading'));
        } else if (sync.hasError) {
          child = ErrorScreen(
            key: const ValueKey('error'),
            message: sync.errorMessage ?? '',
          );
        } else if (sync.isReady) {
          child = const MainScreen(key: ValueKey('main'));
          // Guard against multiple calls — only preload if not already loaded
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final adProvider = context.read<AdProvider>();
            if (!adProvider.isLoaded(AdSlot.buildingSheet)) {
              adProvider.preloadAll();
            }
          });
        } else {
          child = const LoadingScreen(key: ValueKey('loading'));
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: child,
        );
      },
    );
  }
}
