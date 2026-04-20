import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
defaultValue: 'http://localhost:8080/api',
  );

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) throw Exception('No authentication token found. Please login first.');
    return token;
  }

  Future<Map<String, dynamic>> submitFeedback({required int officeId, required int typeId, required String comment}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/feedback'), 
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'}, 
        body: jsonEncode({'office_id': officeId, 'type_id': typeId, 'comment': comment.trim()})
      );
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'ai_available': data['ai_available'] ?? true,
          'feedback': data['feedback']
        };
      }
      
      final error = json.decode(response.body);
      return {'success': false, 'message': error['message'] ?? 'Failed to submit feedback: ${response.statusCode}'};
    } catch (e) {
      print('❌ Submit feedback error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<List<Map<String, dynamic>>> getOffices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/offices'), headers: {'Content-Type': 'application/json', 'Accept': 'application/json'});
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to fetch offices');
    } catch (e) {
      print('❌ Get offices error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getTypes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/feedback-types'), headers: {'Content-Type': 'application/json', 'Accept': 'application/json'});
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      throw Exception('Failed to fetch types: ${response.statusCode}');
    } catch (e) {
      print('❌ Get types error: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getFeedback({String? jwtToken}) async {
    try {
      final token = jwtToken ?? await getToken();
      final response = await http.get(Uri.parse('$baseUrl/feedback'), headers: {'Content-Type': 'application/json', 'Accept': 'application/json', 'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'] ?? [];
        return data.cast<Map<String, dynamic>>();
      }
      throw Exception('Failed to fetch feedback');
    } catch (e) {
      print('❌ Get feedback error: $e');
      return [];
    }
  }

  Future<bool> addOffice({required String officeName, String? jwtToken}) async {
    try {
      final token = jwtToken ?? await getToken();
      final response = await http.post(Uri.parse('$baseUrl/offices'), headers: {'Content-Type': 'application/json', 'Accept': 'application/json', 'Authorization': 'Bearer $token'}, body: jsonEncode({'name': officeName.trim()}));
      print('Add office response: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response.statusCode == 201;
    } catch (e) {
      print('❌ Add office ERROR: $e');
      rethrow;
    }
  }

  Future<bool> updateFeedbackStatus({required int feedbackId, required String status, String? jwtToken}) async {
    try {
      final token = jwtToken ?? await getToken();
      final response = await http.patch(Uri.parse('$baseUrl/feedback/$feedbackId'), headers: {'Content-Type': 'application/json', 'Accept': 'application/json', 'Authorization': 'Bearer $token'}, body: jsonEncode({'status': status}));
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Update status error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/login'), headers: {'Content-Type': 'application/json', 'Accept': 'application/json'}, body: jsonEncode({'email': email, 'password': password}));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'] ?? data['access_token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        return data;
      }
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Login failed');
    } catch (e) {
      print('❌ Login error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } catch (e) {
      print('❌ Logout error: $e');
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final token = await getToken();
      return token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}