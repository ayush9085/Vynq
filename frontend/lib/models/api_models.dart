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
  final Map<String, dynamic> axisScores;
  final String typeDescription;
  final int totalKeywords;
  final int tokensAnalyzed;

  MbtiResult({
    required this.mbti,
    required this.confidence,
    required this.message,
    this.axisScores = const {},
    this.typeDescription = '',
    this.totalKeywords = 0,
    this.tokensAnalyzed = 0,
  });

  factory MbtiResult.fromJson(Map<String, dynamic> json) {
    return MbtiResult(
      mbti: json['mbti'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      message: json['message'] as String,
      axisScores: (json['axis_scores'] as Map<String, dynamic>?) ?? {},
      typeDescription: (json['type_description'] as String?) ?? '',
      totalKeywords: (json['total_keywords_detected'] as int?) ?? 0,
      tokensAnalyzed: (json['tokens_analyzed'] as int?) ?? 0,
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

// ── Chat ──

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final String timestamp;
  final String senderName;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.senderName = '',
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      content: json['content'] as String,
      timestamp: json['timestamp'] as String,
      senderName: (json['sender_name'] as String?) ?? '',
    );
  }
}

class Conversation {
  final String userId;
  final String name;
  final String mbti;
  final String lastMessage;
  final String timestamp;
  final bool isSender;

  Conversation({
    required this.userId,
    required this.name,
    required this.mbti,
    required this.lastMessage,
    required this.timestamp,
    required this.isSender,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      userId: json['user_id'] as String,
      name: json['name'] as String,
      mbti: (json['mbti'] as String?) ?? '',
      lastMessage: json['last_message'] as String,
      timestamp: json['timestamp'] as String,
      isSender: (json['is_sender'] as bool?) ?? false,
    );
  }
}

// ── Analytics ──

class SwipeStats {
  final int totalSwipes;
  final int likes;
  final int passes;
  final int superLikes;
  final double likeRate;
  final String topMatchType;
  final List<Map<String, dynamic>> swipeHistory;

  SwipeStats({
    required this.totalSwipes,
    required this.likes,
    required this.passes,
    required this.superLikes,
    required this.likeRate,
    required this.topMatchType,
    required this.swipeHistory,
  });

  factory SwipeStats.fromJson(Map<String, dynamic> json) {
    return SwipeStats(
      totalSwipes: (json['total_swipes'] as int?) ?? 0,
      likes: (json['likes'] as int?) ?? 0,
      passes: (json['passes'] as int?) ?? 0,
      superLikes: (json['super_likes'] as int?) ?? 0,
      likeRate: (json['like_rate'] as num?)?.toDouble() ?? 0,
      topMatchType: (json['top_match_type'] as String?) ?? '',
      swipeHistory: List<Map<String, dynamic>>.from(
        (json['swipe_history'] as List?) ?? [],
      ),
    );
  }
}
