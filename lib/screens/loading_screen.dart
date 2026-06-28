import 'package:flutter/material.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';
import 'package:district_navigation_app/themes/app_dimensions.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final d = AppDimensions(context);

    return Scaffold(
      backgroundColor: AtlasColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Added accessibility semantics so screen readers announce the loading state
              const CircularProgressIndicator(
                color: AtlasColors.primary,
                semanticsLabel: 'جارٍ تحميل البيانات',
              ),

              SizedBox(height: d.paddingXL),

              Text(
                'جارٍ تحميل البيانات...',
                // Enforcing RTL text direction prevents punctuation from flipping to the wrong side
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AtlasColors.textSecondary,
                  fontSize: d.fontM,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
