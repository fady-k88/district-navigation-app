import 'package:flutter/material.dart';
import 'package:district_navigation_app/app/app_entry.dart';

class DistrictNavigationApp extends StatelessWidget {
  const DistrictNavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أطلس حدائق أكتوبر',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const AppEntry(),
    );
  }
}
