class MenteeModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final String status; // 'active', 'inactive', 'completed'
  final int overallProgress; // 0-100
  final int goalsCompleted;
  final int totalGoals;
  final int unreadMessages;
  final DateTime lastActive;
  final String matchId;

  MenteeModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.status,
    required this.overallProgress,
    required this.goalsCompleted,
    required this.totalGoals,
    this.unreadMessages = 0,
    required this.lastActive,
    required this.matchId,
  });

  factory MenteeModel.fromJson(Map<String, dynamic> json) {
    return MenteeModel(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatar_url'],
      status: json['status'],
      overallProgress: json['overall_progress'] ?? 0,
      goalsCompleted: json['goals_completed'] ?? 0,
      totalGoals: json['total_goals'] ?? 0,
      unreadMessages: json['unread_messages'] ?? 0,
      lastActive: DateTime.parse(json['last_active']),
      matchId: json['match_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
      'status': status,
      'overall_progress': overallProgress,
      'goals_completed': goalsCompleted,
      'total_goals': totalGoals,
      'unread_messages': unreadMessages,
      'last_active': lastActive.toIso8601String(),
      'match_id': matchId,
    };
  }

  bool get needsAction {
    return unreadMessages > 0 ||
        overallProgress < 50 ||
        (totalGoals > 0 && goalsCompleted < totalGoals * 0.5) ||
        DateTime.now().difference(lastActive).inDays > 7;
  }

  bool get isOnTrack {
    return !needsAction && overallProgress >= 50 && status == 'active';
  }
}
