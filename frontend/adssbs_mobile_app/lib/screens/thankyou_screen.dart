import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../routes/app_routes.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 32),
              const Text(
                'Thank You!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your feedback has been submitted successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Submit Another Feedback
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.feedback);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    child: const Text(
                      'Submit Another Feedback',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Exit App
                  ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop(); // Full app exit on all platforms
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    child: const Text(
                      'Exit',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
