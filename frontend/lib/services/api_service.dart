import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/api_models.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';
  static const String authTokenKey = 'vynk_auth_token';
  static const String userIdKey = 'vynk_user_id';
  static const String onboardingCompleteKey = 'vynk_onboarding_completed';

  // Get auth token from storage
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(authTokenKey);
  }

  // Save auth token
  static Future<void> saveAuthToken(String token, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(authTokenKey, token);
    await prefs.setString(userIdKey, userId);
  }

  // Clear auth data
  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(authTokenKey);
    await prefs.remove(userIdKey);
    await prefs.remove(onboardingCompleteKey);
  }

  // Check if onboarding is completed
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(onboardingCompleteKey) ?? false;
  }

  // Mark onboarding as completed
  static Future<void> markOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onboardingCompleteKey, true);
  }

  // Get user ID from storage
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  // Helper method to get headers
  Future<Map<String, String>> _getHeaders({String? token}) async {
    final authToken = token ?? await getAuthToken();
    return {
      'Content-Type': 'application/json',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };
  }

  // ========== Authentication ==========

  Future<AuthResponse> register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = AuthResponse.fromJson(jsonDecode(response.body));
        await saveAuthToken(data.accessToken, data.userId);
        return data;
      } else {
        final error = ErrorResponse.fromJson(jsonDecode(response.body));
        throw Exception(error.detail ?? error.error);
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = AuthResponse.fromJson(jsonDecode(response.body));
        await saveAuthToken(data.accessToken, data.userId);
        return data;
      } else {
        final error = ErrorResponse.fromJson(jsonDecode(response.body));
        throw Exception(error.detail ?? error.error);
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    await clearAuth();
  }

  // ========== Assessment & Onboarding ==========

  Future<List<AssessmentQuestion>> getAssessmentQuestions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/assessment-questions'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((q) => AssessmentQuestion.fromJson(q)).toList();
      } else {
        throw Exception('Failed to fetch questions');
      }
    } catch (e) {
      throw Exception('Failed to fetch assessment questions: $e');
    }
  }

  Future<MBTIResult> completeOnboarding({
    required int age,
    required String gender,
    required List<String> interests,
    required Map<String, String> responses,
  }) async {
    try {
      final token = await getAuthToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.post(
        Uri.parse('$baseUrl/users/onboarding'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'age': age,
          'gender': gender,
          'interests': interests,
          'responses': responses,
        }),
      );

      if (response.statusCode == 200) {
        return MBTIResult.fromJson(jsonDecode(response.body));
      } else {
        final error = ErrorResponse.fromJson(jsonDecode(response.body));
        throw Exception(error.detail ?? error.error);
      }
    } catch (e) {
      throw Exception('Onboarding failed: $e');
    }
  }

  // ========== User Profile ==========

  Future<User> getProfile(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch profile');
      }
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  Future<User> getMyProfile() async {
    try {
      final userId = await getUserId();
      if (userId == null) throw Exception('Not authenticated');
      return getProfile(userId);
    } catch (e) {
      throw Exception('Failed to fetch my profile: $e');
    }
  }

  // ========== Matching ==========

  Future<List<Match>> findMatches({int limit = 10}) async {
    try {
      final token = await getAuthToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/matches/find?limit=$limit'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((m) => Match.fromJson(m)).toList();
      } else if (response.statusCode == 400) {
        // User hasn't completed onboarding
        throw Exception('Please complete onboarding first');
      } else {
        throw Exception('Failed to find matches');
      }
    } catch (e) {
      throw Exception('Failed to find matches: $e');
    }
  }

  Future<Match> getMatchDetails(String matchUserId) async {
    try {
      final token = await getAuthToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/matches/$matchUserId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return Match.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch match details');
      }
    } catch (e) {
      throw Exception('Failed to fetch match details: $e');
    }
  }

  Future<void> recordMatch(String matchUserId) async {
    try {
      final token = await getAuthToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.post(
        Uri.parse('$baseUrl/matches/record-match/$matchUserId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to record match');
      }
    } catch (e) {
      // Don't throw - this is just for analytics
      debugPrint('Failed to record match: $e');
    }
  }

  // ========== Health Check ==========

  Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/../health'),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
