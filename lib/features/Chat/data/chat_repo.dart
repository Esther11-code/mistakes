import 'dart:developer';
import 'dart:io';
import 'package:mistakes/features/Chat/data/models/message.dart';
import 'package:mistakes/features/Chat/data/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRepo {
  final supabase = Supabase.instance.client;
  Future<List<ConversationModel>> getConversations({
    required String userId,
  }) async {
    try {
      log('Fetching conversations for user: $userId');

      final matches = await supabase
          .from('matches')
          .select('*')
          .eq('status', 'accepted')
          .or('mentor_id.eq.$userId,mentee_id.eq.$userId')
          .order('updated_at', ascending: false);

      log('Found ${(matches as List).length} accepted matches');

      if ((matches).isEmpty) {
        return [];
      }

      final conversations = <ConversationModel>[];

      for (var match in (matches)) {
        try {
          final matchId = match['id'] as String;
          final mentorId = match['mentor_id'] as String;
          final menteeId = match['mentee_id'] as String;
          final isMentor = mentorId == userId;
          final otherUserId = isMentor ? menteeId : mentorId;
          final profiles = await supabase
              .from('profiles')
              .select('id, user_id, full_name, profile_photo_url')
              .eq('user_id', otherUserId);

          if (profiles.isEmpty) {
            log('Profile not found for user_id: $otherUserId, skipping');
            continue;
          }

          final profile = profiles[0];

          final fullName = profile['full_name'] as String?;
          final displayName = (fullName == null || fullName.trim().isEmpty)
              ? 'User ${otherUserId.substring(0, 8)}'
              : fullName;

          log('Added conversation: $displayName');

          final convs = await supabase
              .from('conversations')
              .select(
                'id, last_message, last_message_at, unread_count_mentor, unread_count_mentee',
              )
              .eq('match_id', matchId);

          final convResult = convs.isNotEmpty ? convs[0] : null;

          final conversationModel = ConversationModel(
            id: convResult?['id'] ?? '',
            matchId: matchId,
            mentorId: mentorId,
            menteeId: menteeId,
            lastMessage: convResult?['last_message'],
            lastMessageAt: convResult?['last_message_at'] != null
                ? DateTime.parse(convResult?['last_message_at'])
                : null,
            lastMessageSenderId: null,
            unreadCountMentor: convResult?['unread_count_mentor'] ?? 0,
            unreadCountMentee: convResult?['unread_count_mentee'] ?? 0,
            createdAt: DateTime.parse(match['created_at']),
            updatedAt: DateTime.parse(match['updated_at']),
            otherUserId: otherUserId,
            otherUserName: displayName,
            otherUserPhoto: profile['profile_photo_url'] ?? '',
            otherUserOnline: false,
            otherUserRole: isMentor ? 'mentee' : 'mentor',
          );

          conversations.add(conversationModel);
        } catch (e) {
          log('Error processing match: $e');
          continue;
        }
      }

      log('Loaded ${conversations.length} conversations');
      return conversations;
    } catch (e) {
      log('Error loading conversations: $e');
      throw Exception('Failed to load conversations: $e');
    }
  }

  Future<ConversationModel> getOrCreateConversationByMatchId({
    required String matchId,
    required String currentUserId,
  }) async {
    try {
      log('Getting/creating conversation for match: $matchId');
      final matches = await supabase
          .from('matches')
          .select('*')
          .eq('id', matchId);

      if (matches.isEmpty) {
        throw Exception('Match not found: $matchId');
      }

      final match = matches[0];
      final mentorAuthUserId = match['mentor_id'] as String;
      final menteeAuthUserId = match['mentee_id'] as String;
      final isMentor = mentorAuthUserId == currentUserId;
      final otherAuthUserId = isMentor ? menteeAuthUserId : mentorAuthUserId;

      log(
        'Match: mentor_auth=$mentorAuthUserId, mentee_auth=$menteeAuthUserId',
      );
      final mentorProfiles = await supabase
          .from('profiles')
          .select('id, user_id, full_name, profile_photo_url')
          .eq('user_id', mentorAuthUserId);

      if (mentorProfiles.isEmpty) {
        throw Exception(
          'Mentor profile not found for user_id: $mentorAuthUserId',
        );
      }

      final menteeProfiles = await supabase
          .from('profiles')
          .select('id, user_id, full_name, profile_photo_url')
          .eq('user_id', menteeAuthUserId);

      if (menteeProfiles.isEmpty) {
        throw Exception(
          'Mentee profile not found for user_id: $menteeAuthUserId',
        );
      }

      final mentorProfile = mentorProfiles[0];
      final menteeProfile = menteeProfiles[0];
      final mentorProfileId = mentorProfile['id'] as String;
      final menteeProfileId = menteeProfile['id'] as String;

      log('Mentor profileId: $mentorProfileId (userId: $mentorAuthUserId)');
      log('Mentee profileId: $menteeProfileId (userId: $menteeAuthUserId)');
      final otherProfile = isMentor ? menteeProfile : mentorProfile;
      final fullName = otherProfile['full_name'] as String?;
      final displayName = (fullName == null || fullName.trim().isEmpty)
          ? 'User ${otherAuthUserId.substring(0, 8)}'
          : fullName;
      final existingConvs = await supabase
          .from('conversations')
          .select('*')
          .eq('match_id', matchId);

      if (existingConvs.isNotEmpty) {
        final existing = existingConvs[0];
        log('Found existing conversation: ${existing['id']}');

        return ConversationModel(
          id: existing['id'] as String,
          matchId: matchId,
          mentorId: mentorAuthUserId,
          menteeId: menteeAuthUserId,
          lastMessage: existing['last_message'] as String?,
          lastMessageAt: existing['last_message_at'] != null
              ? DateTime.parse(existing['last_message_at'] as String)
              : null,
          lastMessageSenderId: existing['last_message_sender_id'] as String?,
          unreadCountMentor: (existing['unread_count_mentor'] as int?) ?? 0,
          unreadCountMentee: (existing['unread_count_mentee'] as int?) ?? 0,
          createdAt: DateTime.parse(existing['created_at'] as String),
          updatedAt: DateTime.parse(existing['updated_at'] as String),
          otherUserId: otherAuthUserId,
          otherUserName: displayName,
          otherUserPhoto: (otherProfile['profile_photo_url'] as String?) ?? '',
          otherUserOnline: false,
          otherUserRole: isMentor ? 'mentee' : 'mentor',
        );
      }
      log('Creating conversation with:');
      log('MentorprofileId = $mentorProfileId');
      log('MenteeProfileid = $menteeProfileId');

      final insertResult = await supabase
          .from('conversations')
          .insert({
            'match_id': matchId,
            'mentor_id': mentorProfileId,
            'mentee_id': menteeProfileId,
          })
          .select('*');

      if (insertResult.isEmpty) {
        throw Exception('Insert returned no data');
      }

      final newConv = insertResult[0];
      log('Created conversation: ${newConv['id']}');

      return ConversationModel(
        id: newConv['id'] as String,
        matchId: matchId,
        mentorId: mentorAuthUserId,
        menteeId: menteeAuthUserId,
        lastMessage: null,
        lastMessageAt: null,
        lastMessageSenderId: null,
        unreadCountMentor: 0,
        unreadCountMentee: 0,
        createdAt: DateTime.parse(newConv['created_at'] as String),
        updatedAt: DateTime.parse(newConv['updated_at'] as String),
        otherUserId: otherAuthUserId,
        otherUserName: displayName,
        otherUserPhoto: (otherProfile['profile_photo_url'] as String?) ?? '',
        otherUserOnline: false,
        otherUserRole: isMentor ? 'mentee' : 'mentor',
      );
    } catch (e, stackTrace) {
      log('Error: $e');
      log('Stack: $stackTrace');
      throw Exception('Failed: $e');
    }
  }

  Future<ConversationModel> getOrCreateConversation({
    required String mentorId,
    required String menteeId,
    required String currentUserId,
  }) async {
    try {
      log('Getting/creating conversation: mentor=$mentorId, mentee=$menteeId');
      final match = await supabase
          .from('matches')
          .select('id')
          .eq('mentor_id', mentorId)
          .eq('mentee_id', menteeId)
          .eq('status', 'accepted')
          .maybeSingle();

      if (match == null) {
        throw Exception('No accepted match found between mentor and mentee');
      }
      return await getOrCreateConversationByMatchId(
        matchId: match['id'],
        currentUserId: currentUserId,
      );
    } catch (e) {
      log('Error in getOrCreateConversation: $e');
      throw Exception('Failed loading conversation: $e');
    }
  }

  Future<int> getUnreadCount({
    required String conversationId,
    required String userId,
  }) async {
    try {
      final response = await supabase
          .from('messages')
          .select('id')
          .eq('conversation_id', conversationId)
          .eq('receiver_id', userId)
          .eq('is_read', false)
          .count(CountOption.exact);

      return response.count;
    } catch (e) {
      log('Error in getUnreadCount: $e');
      return 0;
    }
  }

  Future<int> getTotalUnreadCount({required String userId}) async {
    try {
      final response = await supabase
          .from('messages')
          .select('id')
          .eq('receiver_id', userId)
          .eq('is_read', false)
          .count(CountOption.exact);

      return response.count;
    } catch (e) {
      log('Error in getTotalUnreadCount: $e');
      return 0;
    }
  }

  Future<List<MessageModel>> getMessages({
    required String conversationId,
    int limit = 50,
  }) async {
    try {
      log('Fetching messages for conversation: $conversationId');

      final response = await supabase
          .from('messages')
          .select('''
            *,
            sender:profiles!sender_id(
              full_name, profile_photo_url, is_online
            )
          ''')
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: false)
          .limit(limit);

      log('Fetched ${(response as List).length} messages');
      return (response)
          .map((json) => MessageModel.fromJson(json))
          .toList()
          .reversed
          .toList();
    } catch (e) {
      log('Error in getMessages: $e');
      throw Exception('Failed to load messages: $e');
    }
  }

  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    try {
      log('Sending message: $content');
      final senderProfileId = await getProfileId(senderId);
      final receiverProfileId = await getProfileId(receiverId);
      final message = await supabase
          .from('messages')
          .insert({
            'conversation_id': conversationId,
            'sender_id': senderProfileId,
            'receiver_id': receiverProfileId,
            'content': content,
            'message_type': 'text',
          })
          .select('''
          *,
          sender:profiles!sender_id(
            full_name, profile_photo_url, is_online
          )
        ''')
          .single();

      log('Message sent: ${message['id']}');
      return MessageModel.fromJson(message);
    } catch (e) {
      log('Error in sendMessage: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  Future<MessageModel> sendFileMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required File file,
    required MessageType messageType,
  }) async {
    try {
      log('Uploading ${messageType.name}');
      final senderProfileId = await getProfileId(senderId);
      final receiverProfileId = await getProfileId(receiverId);
      final bucket = messageType == MessageType.image
          ? 'chat-images'
          : 'chat-files';
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final filePath = '$senderId/$fileName';

      await supabase.storage.from(bucket).upload(filePath, file);
      final fileUrl = supabase.storage.from(bucket).getPublicUrl(filePath);
      final fileSize = await file.length();

      log('File uploaded: $fileUrl');
      final message = await supabase
          .from('messages')
          .insert({
            'conversation_id': conversationId,
            'sender_id': senderProfileId,
            'receiver_id': receiverProfileId,
            'content': messageType == MessageType.image
                ? 'Sent an image'
                : 'Sent a file',
            'message_type': messageType.value,
            'file_url': fileUrl,
            'file_name': file.path.split('/').last,
            'file_size': fileSize,
          })
          .select('''
          *,
          sender:profiles!sender_id(
            full_name, profile_photo_url, is_online
          )
        ''')
          .single();

      log('File message sent: ${message['id']}');
      return MessageModel.fromJson(message);
    } catch (e) {
      log('Error in sendFileMessage: $e');
      throw Exception('Failed to send file: $e');
    }
  }

  Future<void> markMessagesAsRead({
    required String conversationId,
    required String userId,
  }) async {
    try {
      log('Marking messages as read in conversation: $conversationId');

      await supabase
          .from('messages')
          .update({
            'is_read': true,
            'read_at': DateTime.now().toIso8601String(),
          })
          .eq('conversation_id', conversationId)
          .eq('receiver_id', userId)
          .eq('is_read', false);

      log('Messages marked as read');
    } catch (e) {
      log('Error in markMessagesAsRead: $e');
      throw Exception('Failed to mark messages as read: $e');
    }
  }

  Future<void> deleteMessage({required String messageId}) async {
    try {
      log('Deleting message: $messageId');

      await supabase.from('messages').delete().eq('id', messageId);

      log('Message deleted');
    } catch (e) {
      log('Error in deleteMessage: $e');
      throw Exception('Failed to delete message: $e');
    }
  }

  RealtimeChannel subscribeToMessages({
    required String conversationId,
    required Function(MessageModel) onNewMessage,
  }) {
    log('Subscribing to messages in conversation: $conversationId');

    return supabase
        .channel('messages:$conversationId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) async {
            log('New message received: ${payload.newRecord['id']}');
            final message = await supabase
                .from('messages')
                .select('''
                  *,
                  sender:profiles!sender_id(
                    full_name, profile_photo_url, is_online
                  )
                ''')
                .eq('id', payload.newRecord['id'])
                .single();

            onNewMessage(MessageModel.fromJson(message));
          },
        )
        .subscribe();
  }

  RealtimeChannel subscribeToConversations({
    required String userId,
    required Function(ConversationModel) onConversationUpdate,
  }) {
    log('Subscribing to conversations for user: $userId');

    return supabase
        .channel('conversations:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'conversations',
          callback: (payload) async {
            log('Conversation updated: ${payload.newRecord['id']}');
            final mentorId = payload.newRecord['mentor_id'];
            final menteeId = payload.newRecord['mentee_id'];

            if (mentorId != userId && menteeId != userId) {
              return;
            }
            final conv = await supabase
                .from('conversations')
                .select('''
                  *,
                  mentor:profiles!conversations_mentor_id_fkey(
                    id, full_name, profile_photo_url, is_online
                  ),
                  mentee:profiles!conversations_mentee_id_fkey(
                    id, full_name, profile_photo_url, is_online
                  )
                ''')
                .eq('id', payload.newRecord['id'])
                .single();

            onConversationUpdate(ConversationModel.fromJson(conv, userId));
          },
        )
        .subscribe();
  }

  Future<void> unsubscribe(RealtimeChannel channel) async {
    try {
      // ignore: invalid_use_of_internal_member
      log('Unsubscribing from channel: ${channel.presence}');
      await supabase.removeChannel(channel);
    } catch (e) {
      log('Error unsubscribing: $e');
    }
  }

  Future<void> updateOnlineStatus({
    required String userId,
    required bool isOnline,
  }) async {
    try {
      await supabase
          .from('profiles')
          .update({
            'is_online': isOnline,
            'last_seen': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId);

      log('Updated online status: $isOnline');
    } catch (e) {
      log('Error updating online status: $e');
    }
  }

  Future<String> getProfileId(String authUserId) async {
    try {
      final profiles = await supabase
          .from('profiles')
          .select('id')
          .eq('user_id', authUserId)
          .single();

      return profiles['id'] as String;
    } catch (e) {
      log('Error getting profile ID for user: $authUserId');
      rethrow;
    }
  }
  Future<void> clearChat({required String conversationId}) async {
    try {
      log('Clearing chat: $conversationId');

      await supabase
          .from('messages')
          .delete()
          .eq('conversation_id', conversationId);

      log('Chat cleared successfully');
    } catch (e) {
      log('Error clearing chat: $e');
      throw Exception('Failed to clear chat: $e');
    }
  }
  Future<void> toggleMuteConversation({
    required String conversationId,
    required bool isMuted,
  }) async {
    try {
      log(
        '${isMuted ? "Muting" : "Unmuting"} conversation: $conversationId',
      );

      await supabase
          .from('conversations')
          .update({'is_muted': isMuted})
          .eq('id', conversationId);

      log('Conversation ${isMuted ? "muted" : "unmuted"}');
    } catch (e) {
      log('Error toggling mute: $e');
      throw Exception('Failed to toggle mute: $e');
    }
  }
}
