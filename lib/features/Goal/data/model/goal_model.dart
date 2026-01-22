class GoalModel {
  final String id;
  final String menteeId;
  final String? matchId;
  final String title;
  final String description;
  final String category; 
  final int progressPercentage; 
  final String status; 
  final DateTime? deadline;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;

  GoalModel({
    required this.id,
    required this.menteeId,
    this.matchId,
    required this.title,
    required this.description,
    required this.category,
    this.progressPercentage = 0,
    this.status = 'active',
    this.deadline,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'],
      menteeId: json['mentee_id'],
      matchId: json['match_id'],
      title: json['title'],
      description: json['description'] ?? '',
      category: json['category'],
      progressPercentage: json['progress_percentage'] ?? 0,
      status: json['status'] ?? 'active',
      deadline: json['deadline'] != null 
          ? DateTime.parse(json['deadline']) 
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mentee_id': menteeId,
      'match_id': matchId,
      'title': title,
      'description': description,
      'category': category,
      'progress_percentage': progressPercentage,
      'status': status,
      'deadline': deadline?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  GoalModel copyWith({
    String? id,
    String? menteeId,
    String? matchId,
    String? title,
    String? description,
    String? category,
    int? progressPercentage,
    String? status,
    DateTime? deadline,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    return GoalModel(
      id: id ?? this.id,
      menteeId: menteeId ?? this.menteeId,
      matchId: matchId ?? this.matchId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}