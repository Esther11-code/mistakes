class MenteeModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final String status; // 'active' or 'inactive'
  final int overallProgress;
  final int goalsCompleted;
  final int totalGoals;
  final String? expertise;
  final DateTime lastActive;
  final int unreadMessages;
  final bool needsAction;
  final bool isOnTrack;
  final String matchId; // For navigation to conversations

  MenteeModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.expertise,
    required this.status,
    required this.overallProgress,
    required this.goalsCompleted,
    required this.totalGoals,
    required this.lastActive,
    required this.unreadMessages,
    required this.needsAction,
    required this.isOnTrack,
    required this.matchId,
  });

  // Copy with method for updates
  MenteeModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? status,
    int? overallProgress,
    int? goalsCompleted,
    int? totalGoals,
    String? expertise,
    DateTime? lastActive,
    int? unreadMessages,
    bool? needsAction,
    bool? isOnTrack,
    String? matchId,
  }) {
    return MenteeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      expertise: expertise ?? this.expertise,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
      overallProgress: overallProgress ?? this.overallProgress,
      goalsCompleted: goalsCompleted ?? this.goalsCompleted,
      totalGoals: totalGoals ?? this.totalGoals,
      lastActive: lastActive ?? this.lastActive,
      unreadMessages: unreadMessages ?? this.unreadMessages,
      needsAction: needsAction ?? this.needsAction,
      isOnTrack: isOnTrack ?? this.isOnTrack,
      matchId: matchId ?? this.matchId,
    );
  }
}
