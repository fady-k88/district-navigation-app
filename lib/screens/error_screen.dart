import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:district_navigation_app/providers/atlas_sync_provider.dart';
import 'package:district_navigation_app/themes/atlas_colors.dart';
import 'package:district_navigation_app/themes/app_dimensions.dart';

class ErrorScreen extends StatelessWidget {
  final String message;
  const ErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final d = AppDimensions(context);

    return Scaffold(
      backgroundColor: AtlasColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(d.paddingXL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off, color: AtlasColors.danger, size: d.iconL),
                SizedBox(height: d.paddingL),

                Text(
                  'تعذّر تحميل البيانات',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: AtlasColors.textPrimary,
                    fontSize: d.fontXXL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: d.paddingM),

                Text(
                  'يحتاج التطبيق إلى اتصال بالإنترنت عند تشغيله لأول مرة.\nتحقق من اتصالك وأعد المحاولة.',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: AtlasColors.textSecondary,
                    fontSize: d.fontM,
                    height: 1.6,
                  ),
                ),

                SizedBox(height: d.paddingXL),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AtlasColors.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: d.paddingXL,
                      vertical: d.paddingM,
                    ),
                  ),
                  onPressed: () => context.read<AtlasSyncProvider>().sync(),
                  child: Text(
                    'إعادة المحاولة',
                    style: TextStyle(color: Colors.white, fontSize: d.fontL),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
