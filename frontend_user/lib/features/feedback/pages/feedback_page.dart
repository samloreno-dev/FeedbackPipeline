import 'package:flutter/material.dart';
import '../widgets/feedback_form.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// BACKGROUND IMAGE
          SizedBox.expand(
            child: Image.asset(
              "assets/images/lnu_bg.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// DARK OVERLAY (important for readability)
          Container(
            color: Colors.black.withOpacity(0.45),
          ),

          /// CONTENT
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
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