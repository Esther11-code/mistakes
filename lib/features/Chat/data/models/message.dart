// conversation.dart
import 'chat_user.dart';
import 'message_model.dart';

class Conversation {
  final String id;
  final ChatUser user;
  final List<ChatMessage> messages;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final bool isMuted;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.user,
    this.messages = const [],
    this.lastMessage,
    this.unreadCount = 0,
    this.isMuted = false,
    this.isPinned = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Copy with method
  Conversation copyWith({
    String? id,
    ChatUser? user,
    List<ChatMessage>? messages,
    ChatMessage? lastMessage,
    int? unreadCount,
    bool? isMuted,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      user: user ?? this.user,
      messages: messages ?? this.messages,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      isMuted: isMuted ?? this.isMuted,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // From JSON
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      user: ChatUser.fromJson(json['user'] as Map<String, dynamic>),
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lastMessage: json['lastMessage'] != null
          ? ChatMessage.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
      isMuted: json['isMuted'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'messages': messages.map((e) => e.toJson()).toList(),
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
      'isMuted': isMuted,
      'isPinned': isPinned,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Conversation(id: $id, user: ${user.name}, unreadCount: $unreadCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Conversation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  static List<ChatMessage> chatMessages = [
    ChatMessage(
      message: "Hey! How are you doing?",
      isSent: false,
      time: "10:30 AM",
      isRead: true,
    ),
    ChatMessage(
      message: "I'm doing great! Just finished that project we talked about",
      isSent: true,
      time: "10:32 AM",
      isRead: true,
    ),
    ChatMessage(
      message: "That's awesome! How did it turn out?",
      isSent: false,
      time: "10:33 AM",
      isRead: true,
    ),
    ChatMessage(
      message: "Really well! The client loved it 😊",
      isSent: true,
      time: "10:35 AM",
      isRead: true,
    ),
    ChatMessage(
      message: "I'm so happy to hear that! You worked really hard on it",
      isSent: false,
      time: "10:36 AM",
      isRead: true,
    ),
  ];
}
