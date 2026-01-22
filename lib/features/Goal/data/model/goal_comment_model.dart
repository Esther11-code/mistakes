class GoalCommentModel {
  final String id;
  final String goalId;
  final String userId;
  final String commentText;
  final int? rating; 
  final DateTime createdAt;
  final String? userName;
  final String? userAvatar;

  GoalCommentModel({
    required this.id,
    required this.goalId,
    required this.userId,
    required this.commentText,
    this.rating,
    required this.createdAt,
    this.userName,
    this.userAvatar,
  });

  factory GoalCommentModel.fromJson(Map<String, dynamic> json) {
    return GoalCommentModel(
      id: json['id'] as String,
      goalId: json['goal_id'] as String,
      userId: json['user_id'] as String,
      commentText: json['comment_text'] as String,
      rating: json['rating'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      userName: json['user_name'] as String?,
      userAvatar: json['user_avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goal_id': goalId,
      'user_id': userId,
      'comment_text': commentText,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
    };
  }

  GoalCommentModel copyWith({
    String? id,
    String? goalId,
    String? userId,
    String? commentText,
    int? rating,
    DateTime? createdAt,
    String? userName,
    String? userAvatar,
  }) {
    return GoalCommentModel(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      userId: userId ?? this.userId,
      commentText: commentText ?? this.commentText,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
    );
  }
}