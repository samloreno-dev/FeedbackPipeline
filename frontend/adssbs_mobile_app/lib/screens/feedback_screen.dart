import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_routes.dart';
import '../services/feedback_service.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  final _feedbackService = FeedbackService();

  bool _isSubmitting = false;
  bool _isLoadingData = true;

  int? _selectedOfficeId;
  int? _selectedTypeId;

  List<Map<String, dynamic>> _offices = [];
  List<Map<String, dynamic>> _types = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoadingData = true);

    try {
      final results = await Future.wait([
        _feedbackService.getOffices(),
        _feedbackService.getTypes(),
      ]);

      if (!mounted) return;

      setState(() {
        _offices = (results[0] as List).cast<Map<String, dynamic>>();
        _types = (results[1] as List).cast<Map<String, dynamic>>();
      });
    } catch (error) {
      _showError('Unable to load data: $error');
    } finally {
      if (mounted) setState(() => _isLoadingData = false);
    }
  }

  final List<String> _bannedWords = [
    // English
    'fuck', 'shit', 'bitch', 'asshole', 'damn', 'cunt', 'dick', 'pussy',
    'bastard', 'slut', 'whore', 'retard', 'nigga', 'nigger', 'fag', 'faggot',
    'motherfucker', 'cock', 'tits', 'bullshit', 'piss', 'wanker', 'twat',
    // Tagalog
    'putangina', 'gago', 'bobo', 'tanga', 'ulol', 'pakyu', 'tangina',
    'puta', 'kantot', 'iyot', 'hinayupak', 'lintik', 'buwisit', 'tarantado',
    'leche', 'pesteng', 'pakshet', 'shunga', 'ungas', 'kupal', 'hinampak',
    'demonyo', 'bwisit', 'pucha', 'puchang', 'piste', 'yawa', 'atay',
    // Variants / leetspeak
    'fck', 'fuk', 'sh1t', 'b1tch', 'paky0u', 'g@go', 'b0b0',
  ];

  bool _containsProfanity(String text) {
    final lower = text.toLowerCase();
    for (final word in _bannedWords) {
      if (lower.contains(word)) return true;
    }
    return false;
  }

  bool _isGibberish(String text) {
    final words = text.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return true;

    int gibberishCount = 0;
    final totalWords = words.length;

    for (final word in words) {
      final clean = word.replaceAll(RegExp(r'[^\p{L}\p{N}]', unicode: true), '');
      if (clean.isEmpty) continue;
      final len = clean.length;

      if (len > 7 && !RegExp(r'[aeiouAEIOU]').hasMatch(clean)) {
        gibberishCount++;
        continue;
      }
      if (len > 15 && !RegExp(r'[aeiouAEIOU]').hasMatch(clean)) {
        gibberishCount++;
        continue;
      }
      if (len >= 5) {
        final lower = clean.toLowerCase();
        final charCounts = <String, int>{};
        for (var i = 0; i < lower.length; i++) {
          charCounts.update(lower[i], (v) => v + 1, ifAbsent: () => 1);
        }
        final maxCount = charCounts.values.reduce((a, b) => a > b ? a : b);
        if (maxCount / len >= 0.7) {
          gibberishCount++;
          continue;
        }
      }
      if (len >= 10 && RegExp(r'[^aeiouAEIOU\s]{8,}').hasMatch(clean)) {
        gibberishCount++;
        continue;
      }
    }

    if (totalWords > 0 && (gibberishCount / totalWords) > 0.3) return true;

    final letters = text.replaceAll(RegExp(r'[^\p{L}]', unicode: true), '');
    final ratio = letters.length / text.length;
    if (ratio < 0.2) return true;

    return false;
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState?.validate() != true ||
        _selectedOfficeId == null ||
        _selectedTypeId == null) {
      return;
    }

    final comment = _feedbackController.text.trim();

    if (_containsProfanity(comment)) {
      _showError('Profanity detected. Please revise your feedback.');
      return;
    }

    if (_isGibberish(comment)) {
      _showError('Gibberish or meaningless text detected. Please provide clear feedback.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final result = await _feedbackService.submitFeedback(
        officeId: _selectedOfficeId!,
        typeId: _selectedTypeId!,
        comment: comment,
      );

      if (!mounted) return;

      if (result['success']) {
        if (result['ai_available'] == true) {
          Navigator.pushReplacementNamed(context, AppRoutes.thankyou);
        } else {
          _showAiUnavailableDialog();
        }
      } else {
        _showError(result['message'] ?? 'Submission failed. Please try again.');
      }
    } catch (error) {
      _showError('Submission failed. Please try again. $error');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showAiUnavailableDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange),
            SizedBox(width: 12),
            Text('AI Analysis Unavailable'),
          ],
        ),
        content: const Text(
          'Your feedback has been saved successfully! AI analysis is temporarily unavailable (tokens used up). It will be reviewed manually shortly.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.thankyou),
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
      ),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({required String label, IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      labelStyle: const TextStyle(color: Colors.white70),
    );
  }

  Widget _buildDropdown({
    required String label,
    required int? value,
    required List<Map<String, dynamic>> items,
    required void Function(int?) onChanged,
    required String? Function(int?) validator,
  }) {
    return DropdownButtonFormField<int>(
      decoration: _inputDecoration(label: label),
      value: value,
      style: const TextStyle(color: Colors.white),
      dropdownColor: Colors.black.withOpacity(0.8),
      items: items
          .map(
            (item) => DropdownMenuItem<int>(
              value: item['id'] as int,
              child: Text(item['name']?.toString() ?? ''),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/loginbackground.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1E3A8A),
                      Color(0xFF3B82F6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // SafeArea + Glass Form Card
          SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                margin: const EdgeInsets.all(24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                      child: _isLoadingData
                          ? const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(color: Colors.white),
                                  SizedBox(height: 16),
                                  Text('Loading...', style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            )
                          : Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Logo
                                    Image.asset(
                                      'assets/images/loginlogo.png',
                                      height: 60,
                                      errorBuilder: (context, error, stackTrace) => const Icon(
                                        Icons.feedback_outlined,
                                        size: 60,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Title
                                    const Text(
                                      'Submit Feedback',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Your feedback helps us improve',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    // Office dropdown
                                    _buildDropdown(
                                      label: 'Select Office *',
                                      value: _selectedOfficeId,
                                      items: _offices,
                                      onChanged: (value) => setState(() => _selectedOfficeId = value),
                                      validator: (value) => value == null ? 'Please select an office' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    // Type dropdown
                                    _buildDropdown(
                                      label: 'Select Category *',
                                      value: _selectedTypeId,
                                      items: _types,
                                      onChanged: (value) => setState(() => _selectedTypeId = value),
                                      validator: (value) => value == null ? 'Please select a category' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    // Comment textarea
                                    TextFormField(
                                      controller: _feedbackController,
                                      maxLines: 5,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: _inputDecoration(
                                        label: 'Your Feedback *',
                                        icon: Icons.edit_outlined,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return 'Please share your feedback';
                                        }
                                        final words = value.trim().split(RegExp(r'\s+'));
                                        if (words.length < 3) {
                                          return 'Feedback should be at least 3 words';
                                        }
                                        if (words.length > 50) {
                                          return 'Feedback should be 50 words or less';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    // Submit button
                                    SizedBox(
                                      height: 52,
                                      child: ElevatedButton(
                                        onPressed: _isSubmitting ? null : _submitFeedback,
                                        child: _isSubmitting
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : const Text(
                                                'Submit Feedback',
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
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
