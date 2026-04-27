import 'package:flutter/material.dart';

class RecaptchaWidget extends StatefulWidget {
  final ValueChanged<String> onVerified;

  const RecaptchaWidget({
    super.key,
    required this.onVerified,
  });

  @override
  State<RecaptchaWidget> createState() => _RecaptchaWidgetState();
}

class _RecaptchaWidgetState extends State<RecaptchaWidget> {
  bool _verified = false;

  void _verify() {
    const token = 'local-test-token';
    setState(() {
      _verified = true;
    });
    widget.onVerified(token);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'CAPTCHA Verification',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _verified
                ? 'Verification complete.'
                : 'Click the button below to verify before submitting.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: _verified ? null : _verify,
              icon: Icon(_verified ? Icons.verified : Icons.verified_user),
              label: Text(_verified ? 'Verified' : 'Verify CAPTCHA'),
            ),
          ),
        ],
      ),
    );
  }
}
