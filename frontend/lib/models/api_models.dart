class AuthResponse {
  final String accessToken;
  final String userId;

  AuthResponse({
    required this.accessToken,
    required this.userId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'],
      userId: json['user_id'],
    );
  }
}

class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final int? age;
  final String? gender;
  final List<String> interests;
  final String? bio;
  final String? location;
  final String? mbti;
  final double? mbtiConfidence;
  final String? createdAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.age,
    this.gender,
    this.interests = const [],
    this.bio,
    this.location,
    this.mbti,
    this.mbtiConfidence,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      age: json['age'],
      gender: json['gender'],
      interests: List<String>.from(json['interests'] ?? []),
      bio: json['bio'],
      location: json['location'],
      mbti: json['mbti'],
      mbtiConfidence: (json['mbti_confidence'] ?? 0).toDouble(),
      createdAt: json['created_at'],
    );
  }
}

class MBTIResult {
  final String mbtiType;
  final double confidence;
  final String message;

  MBTIResult({
    required this.mbtiType,
    required this.confidence,
    required this.message,
  });

  factory MBTIResult.fromJson(Map<String, dynamic> json) {
    return MBTIResult(
      mbtiType: json['mbti'],
      confidence: (json['confidence'] ?? 0).toDouble(),
      message: json['message'] ?? 'MBTI prediction complete',
    );
  }
}

class AssessmentQuestion {
  final int id;
  final String text;
  final String category;

  AssessmentQuestion({
    required this.id,
    required this.text,
    required this.category,
  });

  factory AssessmentQuestion.fromJson(Map<String, dynamic> json) {
    return AssessmentQuestion(
      id: json['id'],
      text: json['text'],
      category: json['category'],
    );
  }
}

class Match {
  final String matchUserId;
  final String name;
  final int? age;
  final String? gender;
  final String mbti;
  final List<String> interests;
  final double compatibilityScore;
  final List<String> matchReasons;
  final String? userBio;

  Match({
    required this.matchUserId,
    required this.name,
    this.age,
    this.gender,
    required this.mbti,
    this.interests = const [],
    required this.compatibilityScore,
    this.matchReasons = const [],
    this.userBio,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      matchUserId: json['match_user_id'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      mbti: json['mbti'],
      interests: List<String>.from(json['interests'] ?? []),
      compatibilityScore: (json['compatibility_score'] ?? 0).toDouble(),
      matchReasons: List<String>.from(json['match_reasons'] ?? []),
      userBio: json['user_bio'],
    );
  }
}

class ErrorResponse {
  final String error;
  final String? detail;
  final int statusCode;

  ErrorResponse({
    required this.error,
    this.detail,
    required this.statusCode,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      error: json['error'] ?? 'Unknown error',
      detail: json['detail'],
      statusCode: json['status_code'] ?? 500,
    );
  }
}
