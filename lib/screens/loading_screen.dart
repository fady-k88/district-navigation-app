import 'package:flutter/material.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AtlasColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AtlasColors.primary),
            SizedBox(height: 20),
            Text(
              'جارٍ تحميل البيانات...',
              style: TextStyle(color: AtlasColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
