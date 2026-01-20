// lib/features/Rating&Reviews/data/model/mentor_review_model.dart

class MentorReviewModel {
  final String id;
  final String mentorId;
  final String menteeId;
  final String? matchId;
  final int rating; // 1-5 stars
  final String reviewText;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? menteeName;
  final String? menteeAvatar;

  MentorReviewModel({
    required this.id,
    required this.mentorId,
    required this.menteeId,
    this.matchId,
    required this.rating,
    required this.reviewText,
    required this.createdAt,
    required this.updatedAt,
    this.menteeName,
    this.menteeAvatar,
  });

  factory MentorReviewModel.fromJson(Map<String, dynamic> json) {
    return MentorReviewModel(
      id: json['id'] as String,
      mentorId: json['mentor_id'] as String,
      menteeId: json['mentee_id'] as String,
      matchId: json['match_id'] as String?,
      rating: json['rating'] as int,
      reviewText: json['review_text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      menteeName: json['mentee_name'] as String?,
      menteeAvatar: json['mentee_avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mentor_id': mentorId,
      'mentee_id': menteeId,
      'match_id': matchId,
      'rating': rating,
      'review_text': reviewText,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}