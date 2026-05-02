import 'package:flutter/material.dart';
import 'dart:ui';
import '../widgets/feedback_form.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              "assets/images/lnu_bg.jpg",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0B1F5C),
                      Color(0xFFD4AF37),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          /// DIRTY WHITE OVERLAY
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
              ),
            ),
          ),

          /// CONTENT CARD
          SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                margin: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFFD4AF37), width: 2),
                  ),
                  child: const SingleChildScrollView(
                    child: FeedbackForm(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
