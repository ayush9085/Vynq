class AuthResponse {
  final String accessToken;
  final String userId;

  AuthResponse({required this.accessToken, required this.userId});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] as String,
      userId: json['user_id'] as String,
    );
  }
}

class MbtiResult {
  final String mbti;
  final double confidence;
  final String message;

  MbtiResult({
    required this.mbti,
    required this.confidence,
    required this.message,
  });

  factory MbtiResult.fromJson(Map<String, dynamic> json) {
    return MbtiResult(
      mbti: json['mbti'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      message: json['message'] as String,
    );
  }
}

class MatchItem {
  final String matchUserId;
  final String name;
  final String mbti;
  final double compatibilityScore;
  final List<String> sharedInterests;
  final String explanation;
  final List<String> reasons;

  MatchItem({
    required this.matchUserId,
    required this.name,
    required this.mbti,
    required this.compatibilityScore,
    required this.sharedInterests,
    required this.explanation,
    required this.reasons,
  });

  factory MatchItem.fromJson(Map<String, dynamic> json) {
    return MatchItem(
      matchUserId: json['match_user_id'] as String,
      name: json['name'] as String,
      mbti: json['mbti'] as String,
      compatibilityScore: (json['compatibility_score'] as num).toDouble(),
      sharedInterests: List<String>.from(json['shared_interests'] as List),
      explanation: json['explanation'] as String,
      reasons: List<String>.from(json['reasons'] as List),
    );
  }
}

class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final int? age;
  final String? gender;
  final List<String> interests;
  final String? mbti;
  final double? confidence;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.age,
    this.gender,
    required this.interests,
    this.mbti,
    this.confidence,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      interests: List<String>.from(json['interests'] as List? ?? []),
      mbti: json['mbti'] as String?,
      confidence: (json['mbti_confidence'] as num?)?.toDouble(),
    );
  }
}
