// services/ads/ad_service.dart
import 'dart:io';

class AdService {
  AdService._(); // prevent instantiation — static only

  // ── Ad Unit IDs ─────────────────────────────────────────────────────────
  // Test IDs are used automatically on debug builds.
  // Replace the _real* values with your actual AdMob unit IDs before release.

  static const String _realBannerAndroid =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String _testBanner = 'ca-app-pub-3940256099942544/6300978111';

  static bool get _isTesting {
    // Always use test ads in debug mode
    bool result = false;
    assert(() {
      result = true;
      return true;
    }()); // dart assert trick
    return result;
  }

  static String get bannerAdUnitId {
    if (_isTesting) return _testBanner;
    if (Platform.isAndroid) return _realBannerAndroid;
    throw UnsupportedError('Only Android is supported for now');
  }
}
