// lib/features/Chat/data/repositories/chat_repository.dart

import 'package:mistakes/features/Chat/data/models/message.dart';

import 'models/chat_user.dart';
import 'models/message_model.dart';

class ChatRepository {
  // Static data - replace with API calls later
  static final ChatUser currentUser = ChatUser(
    id: 'me',
    name: 'Me',
    isOnline: true,
  );

  static final ChatUser otherUser = ChatUser(
    id: 'user_1',
    name: 'Sarah Johnson',
    avatar: null,
    isOnline: true,
    status: 'Senior Developer',
    email: 'sarah.johnson@email.com',
  );

  // Get conversation with a user
  Future<Conversation> getConversation(String userId) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // TODO: Replace with actual API call
    // final response = await http.get('api/conversations/$userId');

    return Conversation(
      id: 'conv_$userId',
      user: otherUser,
      messages: Conversation.chatMessages,
      lastMessage: Conversation.chatMessages.isNotEmpty
          ? Conversation.chatMessages.last
          : null,
      unreadCount: 0,
    );
  }

  // Send a message
  Future<ChatMessage> sendMessage(String conversationId, String text) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // final response = await http.post('api/conversations/$conversationId/messages', body: {'message': text});

    final now = DateTime.now();
    return ChatMessage(
      message: text,
      isSent: true,
      time: _formatTime(now),
      isRead: false,
      timestamp: now,
    );
  }

  // Mark messages as read
  Future<void> markAsRead(
    String conversationId,
    List<String> messageIds,
  ) async {
    await Future.delayed(Duration(milliseconds: 200));

    // TODO: Replace with actual API call
    // await http.post('api/conversations/$conversationId/read', body: {'messageIds': messageIds});
  }

  // Helper method
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
