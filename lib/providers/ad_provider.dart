// providers/ad_provider.dart
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:district_navigation_app/services/ads/ad_service.dart';

class AdProvider extends ChangeNotifier {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  BannerAd? get bannerAd => _bannerAd;

  // Call this once when the app is ready — loads ad in background immediately
  void preloadBanner() {
    _bannerAd = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      size: AdSize.largeBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _isLoaded = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
          _isLoaded = false;
          // Wait 30 seconds then retry silently
          Future.delayed(const Duration(seconds: 30), preloadBanner);
        },
      ),
    )..load();
  }

  // Call this after the sheet closes to reload for the next building tap
  void reloadAfterUse() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isLoaded = false;
    notifyListeners();
    preloadBanner(); // immediately start loading next ad
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
