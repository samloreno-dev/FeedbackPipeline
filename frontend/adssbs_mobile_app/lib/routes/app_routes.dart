import 'package:flutter/material.dart';

import '../screens/feedback_screen.dart';
import '../screens/thankyou_screen.dart';

class AppRoutes {

  static const String feedback = '/feedback';
  static const String thankyou = '/thankyou';

  static Map<String, WidgetBuilder> routes = {

    feedback: (context) => const FeedbackScreen(),
    thankyou: (context) => const ThankYouScreen(),
  };
}