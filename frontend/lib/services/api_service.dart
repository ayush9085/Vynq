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

  Future<String?> userId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<bool> isAuthenticated() async {
    return (await token()) != null;
  }

  Future<Map<String, String>> _authHeaders() async {
    final t = await token();
    return {
      if (t != null) 'Authorization': 'Bearer $t',
      'Content-Type': 'application/json',
    };
  }

  // ── Auth ──

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

  // ── User ──

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
    final headers = await _authHeaders();

    final response = await http.post(
      Uri.parse('$baseUrl/api/users/onboarding'),
      headers: headers,
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

  Future<UserProfile> myProfile() async {
    final headers = await _authHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/api/users/me'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response));
    }

    return UserProfile.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  // ── Matches ──

  Future<List<MatchItem>> findMatches() async {
    final headers = await _authHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/api/matches/find?limit=20'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response));
    }

    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => MatchItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Chat ──

  Future<ChatMessage> sendMessage({
    required String receiverId,
    required String content,
  }) async {
    final headers = await _authHeaders();

    final response = await http.post(
      Uri.parse('$baseUrl/api/chat/send'),
      headers: headers,
      body: jsonEncode({
        'receiver_id': receiverId,
        'content': content,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response));
    }

    return ChatMessage.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<List<ChatMessage>> getConversation(String otherUserId) async {
    final headers = await _authHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/api/chat/conversation/$otherUserId'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response));
    }

    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Conversation>> getConversations() async {
    final headers = await _authHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/api/chat/conversations'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response));
    }

    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Icebreakers ──

  Future<List<String>> getIcebreakers(String matchUserId) async {
    final headers = await _authHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/api/extras/icebreakers/$matchUserId'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return List<String>.from(data['icebreakers'] as List);
  }

  // ── Analytics ──

  Future<void> recordSwipe({
    required String targetUserId,
    required String action,
  }) async {
    final headers = await _authHeaders();

    await http.post(
      Uri.parse('$baseUrl/api/extras/swipe'),
      headers: headers,
      body: jsonEncode({
        'target_user_id': targetUserId,
        'action': action,
      }),
    );
  }

  Future<SwipeStats> getSwipeStats() async {
    final headers = await _authHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/api/extras/analytics'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      return SwipeStats.fromJson({});
    }

    return SwipeStats.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  // ── Report / Block ──

  Future<String> reportUser({
    required String reportedUserId,
    required String reason,
  }) async {
    final headers = await _authHeaders();

    final response = await http.post(
      Uri.parse('$baseUrl/api/extras/report'),
      headers: headers,
      body: jsonEncode({
        'reported_user_id': reportedUserId,
        'reason': reason,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(_errorFromResponse(response));
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['message'] as String;
  }

  Future<void> blockUser(String targetUserId) async {
    final headers = await _authHeaders();

    await http.post(
      Uri.parse('$baseUrl/api/extras/block/$targetUserId'),
      headers: headers,
    );
  }

  // ── Compatibility Matrix ──

  Future<Map<String, dynamic>> getCompatibilityMatrix() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/extras/compatibility-matrix'),
    );

    if (response.statusCode != 200) return {};

    return jsonDecode(response.body) as Map<String, dynamic>;
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
