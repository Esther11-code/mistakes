import 'package:equatable/equatable.dart';

class ConversationModel extends Equatable {
  final String id;
  final String mentorId;
  final String menteeId;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final String? lastMessageSenderId;
  final int unreadCountMentor;
  final int unreadCountMentee;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String otherUserId;
  final String otherUserName;
  final String? matchId;
  final String otherUserPhoto;
  final bool otherUserOnline;
  final String otherUserRole; 

  const ConversationModel( {
    required this.id,
    required this.mentorId,
    required this.menteeId,
    this.matchId,
    this.lastMessage,
    this.lastMessageAt,
    this.lastMessageSenderId,
    this.unreadCountMentor = 0,
    this.unreadCountMentee = 0,
    required this.createdAt,
    required this.updatedAt,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserPhoto,
    this.otherUserOnline = false,
    required this.otherUserRole,
  });

  factory ConversationModel.fromJson(
    Map<String, dynamic> json,
    String currentUserId,
  ) {
    final isMentor = json['mentor_id'] == currentUserId;
    final otherUserId = isMentor ? json['mentee_id'] : json['mentor_id'];
    final mentor = json['mentor'] ?? {};
    final mentee = json['mentee'] ?? {};
    final otherUser = isMentor ? mentee : mentor;

    return ConversationModel(
      id: json['id'] as String,
      mentorId: json['mentor_id'] as String,
      menteeId: json['mentee_id'] as String,
      matchId: json['match_id'] as String?,
      lastMessage: json['last_message'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      lastMessageSenderId: json['last_message_sender_id'] as String?,
      unreadCountMentor: json['unread_count_mentor'] as int? ?? 0,
      unreadCountMentee: json['unread_count_mentee'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      otherUserId: otherUserId,
      otherUserName: otherUser['full_name'] as String? ?? 'Unknown User',
      otherUserPhoto: otherUser['profile_photo_url'] as String? ?? '',
      otherUserOnline: otherUser['is_online'] as bool? ?? false,
      otherUserRole: isMentor ? 'mentee' : 'mentor',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mentor_id': mentorId,
      'mentee_id': menteeId,
      'last_message': lastMessage,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'last_message_sender_id': lastMessageSenderId,
      'unread_count_mentor': unreadCountMentor,
      'unread_count_mentee': unreadCountMentee,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  bool isMentor(String currentUserId) => mentorId == currentUserId;

  bool isMentee(String currentUserId) => menteeId == currentUserId;

  int getUnreadCount(String currentUserId) {
    return isMentor(currentUserId) ? unreadCountMentor : unreadCountMentee;
  }

  bool wasLastMessageByMe(String currentUserId) {
    return lastMessageSenderId == currentUserId;
  }
  String get lastMessageTime {
    if (lastMessageAt == null) return '';

    final now = DateTime.now();
    final difference = now.difference(lastMessageAt!);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) return 'Yesterday';
      if (difference.inDays < 7) return '${difference.inDays}d ago';
      return '${lastMessageAt!.day}/${lastMessageAt!.month}/${lastMessageAt!.year}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String get displayLastMessage {
    if (lastMessage == null || lastMessage!.isEmpty) {
      return 'Start a conversation';
    }
    return lastMessage!.length > 60
        ? '${lastMessage!.substring(0, 60)}...'
        : lastMessage!;
  }

  String get userInitials {
    final names = otherUserName.split(' ');
    if (names.isEmpty) return '?';
    if (names.length == 1) return names[0][0].toUpperCase();
    return '${names[0][0]}${names[1][0]}'.toUpperCase();
  }

  ConversationModel copyWith({
    String? id,
    String? mentorId,
    String? menteeId,
    String? lastMessage,
    DateTime? lastMessageAt,
    String? lastMessageSenderId,
    int? unreadCountMentor,
    int? unreadCountMentee,
    DateTime? createdAt,
    String? matchId,
    DateTime? updatedAt,
    String? otherUserId,
    String? otherUserName,
    String? otherUserPhoto,
    bool? otherUserOnline,
    String? otherUserRole,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      mentorId: mentorId ?? this.mentorId,
      menteeId: menteeId ?? this.menteeId,
      matchId: matchId ?? this.matchId,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      unreadCountMentor: unreadCountMentor ?? this.unreadCountMentor,
      unreadCountMentee: unreadCountMentee ?? this.unreadCountMentee,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      otherUserId: otherUserId ?? this.otherUserId,
      otherUserName: otherUserName ?? this.otherUserName,
      otherUserPhoto: otherUserPhoto ?? this.otherUserPhoto,
      otherUserOnline: otherUserOnline ?? this.otherUserOnline,
      otherUserRole: otherUserRole ?? this.otherUserRole,
    );
  }

  @override
  List<Object?> get props => [
        id,
        mentorId,
        menteeId,
        lastMessage,
        matchId,
        lastMessageAt,
        unreadCountMentor,
        unreadCountMentee,
      ];
}