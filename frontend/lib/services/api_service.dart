import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/api_models.dart';

class ApiService {
  static const _tokenKey = 'vynk_token';
  static const _userIdKey = 'vynk_user_id';

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    return 'http://10.0.2.2:8000';
  }

  Future<void> saveAuth(AuthResponse auth) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, auth.accessToken);
    await prefs.setString(_userIdKey, auth.userId);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
  }

  Future<String?> token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<bool> isAuthenticated() async {
    return (await token()) != null;
  }

  Future<AuthResponse> register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(_errorFromResponse(response));
    }

    final auth = AuthResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    await saveAuth(auth);
    return auth;
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response));
    }

    final auth = AuthResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    await saveAuth(auth);
    return auth;
  }

  Future<List<String>> assessmentQuestions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/assessment-questions'),
    );
    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response));
    }

    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => (e as Map<String, dynamic>)['text'] as String)
        .toList();
  }

  Future<MbtiResult> completeOnboarding({
    required int age,
    required String gender,
    required List<String> interests,
    required Map<String, String> responses,
  }) async {
    final authToken = await token();
    if (authToken == null) {
      throw Exception('Please log in again');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/users/onboarding'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'age': age,
        'gender': gender,
        'interests': interests,
        'responses': responses,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response));
    }

    return MbtiResult.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<List<MatchItem>> findMatches() async {
    final authToken = await token();
    if (authToken == null) throw Exception('Please log in again');

    final response = await http.get(
      Uri.parse('$baseUrl/api/matches/find?limit=20'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response));
    }

    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => MatchItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<UserProfile> myProfile() async {
    final authToken = await token();
    if (authToken == null) throw Exception('Please log in again');

    final response = await http.get(
      Uri.parse('$baseUrl/api/users/me'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response));
    }

    return UserProfile.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  String _errorFromResponse(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['detail']?.toString() ?? 'Request failed';
    } catch (_) {
      return 'Request failed';
    }
  }
}
