import 'package:flutter/material.dart';
import '../features/feedback/pages/feedback_page.dart';

class AppRoutes {
  static const String feedback = "/";

  static Map<String, WidgetBuilder> routes = {
    feedback: (context) => const FeedbackPage(),
  };
}
