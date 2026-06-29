// widgets/ads/banner_ad_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:district_navigation_app/providers/ad_provider.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';
import 'package:district_navigation_app/themes/app_dimensions.dart';

class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final d = AppDimensions(context);
    final adProvider = context.watch<AdProvider>();

    if (!adProvider.isLoaded || adProvider.bannerAd == null) {
      // Placeholder — shown only during very first load or on failure
      return Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(d.borderRadiusS),
          border: Border.all(color: AtlasColors.chipBorder),
        ),
        alignment: Alignment.center,
        child: Text(
          'مساحة إعلانية',
          style: TextStyle(color: AtlasColors.textSecondary, fontSize: d.fontM),
        ),
      );
    }

    return SizedBox(
      width: adProvider.bannerAd!.size.width.toDouble(),
      height: adProvider.bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: adProvider.bannerAd!),
    );
  }
}
