import 'dart:developer';
import 'package:mistakes/features/Chat/data/models/message.dart';
import 'package:mistakes/features/Chat/data/models/message_model.dart';

class ChatRepo {
  // TODO: Add Supabase client

  Future<List<ConversationModel>> getConversations({required String userId}) async {
    try {
      log('Fetching conversations for user: $userId');
      
      // TODO: Replace with actual Supabase query
      // final response = await supabase
      //     .from('conversations')
      //     .select()
      //     .eq('user_id', userId)
      //     .order('timestamp', ascending: false);
      
      // return (response as List)
      //     .map((json) => ConversationModel.fromJson(json))
      //     .toList();

      // Dummy data for testing
      await Future.delayed(Duration(seconds: 1));
      return [
        ConversationModel(
          id: '1',
          userId: '123',
          userName: 'John Mentor',
          userAvatar: null,
          lastMessage: 'Hey! How can I help you today?',
          timestamp: DateTime.now().subtract(Duration(hours: 2)),
          unreadCount: 2,
          isOnline: true,
        ),
        ConversationModel(
          id: '2',
          userId: '456',
          userName: 'Sarah Coach',
          userAvatar: null,
          lastMessage: 'Great progress on your goals!',
          timestamp: DateTime.now().subtract(Duration(days: 1)),
          unreadCount: 0,
          isOnline: false,
        ),
      ];
    } catch (e) {
      log('Error in getConversations: $e');
      throw Exception('Failed to load conversations: $e');
    }
  }

  Future<List<MessageModel>> getMessages({required String conversationId}) async {
    try {
      log('Fetching messages for conversation: $conversationId');
      
      // TODO: Replace with actual Supabase query
      // final response = await supabase
      //     .from('messages')
      //     .select()
      //     .eq('conversation_id', conversationId)
      //     .order('timestamp', ascending: true);
      
      // return (response as List)
      //     .map((json) => MessageModel.fromJson(json))
      //     .toList();

      // Dummy data for testing
      await Future.delayed(Duration(milliseconds: 500));
      return [
        MessageModel(
          id: '1',
          conversationId: conversationId,
          senderId: '123',
          receiverId: 'current_user',
          message: 'Hey! How are you doing?',
          timestamp: DateTime.now().subtract(Duration(hours: 2)),
          isRead: true,
        ),
        MessageModel(
          id: '2',
          conversationId: conversationId,
          senderId: 'current_user',
          receiverId: '123',
          message: "I'm doing great! Just finished that project",
          timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 58)),
          isRead: true,
        ),
      ];
    } catch (e) {
      log('Error in getMessages: $e');
      throw Exception('Failed to load messages: $e');
    }
  }

  Future<void> sendMessage({required MessageModel message}) async {
    try {
      log('Sending message: ${message.message}');
      
      // TODO: Replace with actual Supabase insert
      // await supabase.from('messages').insert(message.toJson());
      
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      log('Error in sendMessage: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  Future<void> markAsRead({required String conversationId}) async {
    try {
      log('Marking conversation as read: $conversationId');
      
      // TODO: Replace with actual Supabase update
      // await supabase
      //     .from('conversations')
      //     .update({'unread_count': 0})
      //     .eq('id', conversationId);
      
      await Future.delayed(Duration(milliseconds: 300));
    } catch (e) {
      log('Error in markAsRead: $e');
      throw Exception('Failed to mark as read: $e');
    }
  }
}