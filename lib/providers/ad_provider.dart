// providers/ad_provider.dart
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:district_navigation_app/services/ads/ad_service.dart';

enum AdSlot { buildingSheet, infoSheet, settingsSheet }

class AdProvider extends ChangeNotifier {
  final Map<AdSlot, BannerAd?> _ads = {};
  final Map<AdSlot, bool> _loaded = {};

  bool isLoaded(AdSlot slot) => _loaded[slot] ?? false;
  BannerAd? bannerAd(AdSlot slot) => _ads[slot];

  // ── Preload a specific slot ──────────────────────────────────────────────
  void preloadBanner(AdSlot slot) {
    _ads[slot]?.dispose();
    _ads[slot] = null;
    _loaded[slot] = false;

    final ad = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      size: AdSize.largeBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _loaded[slot] = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _ads[slot] = null;
          _loaded[slot] = false;
          // Retry after 30 seconds silently
          Future.delayed(
            const Duration(seconds: 30),
            () => preloadBanner(slot),
          );
        },
      ),
    )..load();

    _ads[slot] = ad;
  }

  // ── Preload all slots at once ────────────────────────────────────────────
  void preloadAll() {
    for (final slot in AdSlot.values) {
      preloadBanner(slot);
    }
  }

  // ── Call after a sheet closes to refresh that slot ──────────────────────
  void reloadSlot(AdSlot slot) {
    _loaded[slot] = false;
    notifyListeners();
    preloadBanner(slot);
  }

  @override
  void dispose() {
    for (final ad in _ads.values) {
      ad?.dispose();
    }
    super.dispose();
  }
}
