import 'package:flutter/material.dart';
import 'theme.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADSSBS Mobile Feedback',
      debugShowCheckedModeBanner: false,
      theme: MobileTheme.theme,
      initialRoute: AppRoutes.feedback,
      routes: AppRoutes.routes,
    );
  }
}