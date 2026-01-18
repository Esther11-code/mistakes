import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mistakes/features/Chat/data/chat_repo.dart';
import 'package:mistakes/features/Chat/data/models/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mistakes/features/Authentication/data/model/user_model.dart';
import 'package:mistakes/features/Chat/data/models/message_model.dart';
import 'dart:io';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatRepository;

  ChatCubit(this.chatRepository) : super(ChatInitial());

  // Controllers
  final searchController = TextEditingController();
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final focusNode = FocusNode();

  // Data
  UserModel user = UserModel();
  List<ConversationModel> conversations = [];
  List<ConversationModel> filteredConversations = [];
  List<MessageModel> currentChatMessages = [];

  // Selected conversation state
  String selectedConversationId = '';
  String selectedUserId = '';
  String selectedUserName = '';
  String selectedUserAvatar = '';
  bool selectedUserIsOnline = false;
  String selectedUserRole = ''; // 'mentor' or 'mentee'

  // Real-time channels
  RealtimeChannel? _messagesChannel;
  RealtimeChannel? _conversationsChannel;

  // ==================== CONVERSATIONS ====================

  /// Load all conversations for current user
  Future<void> loadConversations({required UserModel user}) async {
    if (user.id == null) {
      log('❌ User ID is null, cannot load conversations');
      return;
    }

    emit(ChatLoadingState());
    try {
      log('📥 Loading conversations for user: ${user.id}');

      conversations = await chatRepository.getConversations(userId: user.id!);
      filteredConversations = conversations;

      log('✅ Conversations loaded: ${conversations.length}');
      emit(ChatLoadedState());

      // Subscribe to conversation updates
      _subscribeToConversations();
    } catch (e) {
      log('❌ Error loading conversations: $e');
      emit(ChatErrorState(error: e.toString()));
      emit(ChatLoadedState());
    }
  }

  /// Search conversations by name or message
  void searchConversations(String query) {
    log('🔍 Searching: $query');

    if (query.isEmpty) {
      filteredConversations = conversations;
    } else {
      filteredConversations = conversations.where((conv) {
        return conv.otherUserName.toLowerCase().contains(query.toLowerCase()) ||
            (conv.lastMessage?.toLowerCase().contains(query.toLowerCase()) ??
                false);
      }).toList();
    }

    log('✅ Filtered conversations: ${filteredConversations.length}');
    emit(ChatLoadedState());
  }

  /// Clear search
  void clearSearch() {
    searchController.clear();
    filteredConversations = conversations;
    log('✅ Search cleared');
    emit(ChatLoadedState());
  }

  /// Create or get conversation with a specific user (for starting new chats)
  Future<void> startConversationWith({
    required String otherUserId,
    required bool currentUserIsMentor,
    required UserModel user,
  }) async {
    emit(ChatLoadingState());

    try {
      log('🚀 Starting conversation with user: $otherUserId');

      final conversation = await chatRepository.getOrCreateConversation(
        mentorId: currentUserIsMentor ? user.id! : otherUserId,
        menteeId: currentUserIsMentor ? otherUserId : user.id!,
        currentUserId: user.id!,
      );

      await selectConversation(conversation, user: user);
    } catch (e) {
      log('❌ Error starting conversation: $e');
      emit(ChatErrorState(error: e.toString()));
      emit(ChatLoadedState());
    }
  }

  /// Mark conversation as read
  Future<void> markConversationAsRead(String conversationId) async {
    try {
      await chatRepository.markMessagesAsRead(
        conversationId: conversationId,
        userId: user.id!,
      );

      // Update local conversation
      final index = conversations.indexWhere(
        (conv) => conv.id == conversationId,
      );
      if (index != -1) {
        final unreadCount = conversations[index].getUnreadCount(user.id!);
        if (unreadCount > 0) {
          conversations[index] = conversations[index].isMentor(user.id!)
              ? conversations[index].copyWith(unreadCountMentor: 0)
              : conversations[index].copyWith(unreadCountMentee: 0);
        }
      }

      // Update filtered list
      final filteredIndex = filteredConversations.indexWhere(
        (conv) => conv.id == conversationId,
      );
      if (filteredIndex != -1) {
        final unreadCount = filteredConversations[filteredIndex].getUnreadCount(
          user.id!,
        );
        if (unreadCount > 0) {
          filteredConversations[filteredIndex] =
              filteredConversations[filteredIndex].isMentor(user.id!)
              ? filteredConversations[filteredIndex].copyWith(
                  unreadCountMentor: 0,
                )
              : filteredConversations[filteredIndex].copyWith(
                  unreadCountMentee: 0,
                );
        }
      }

      log('✅ Marked conversation as read: $conversationId');
    } catch (e) {
      log('❌ Error marking as read: $e');
    }
  }

  /// Get total unread message count
  Future<int> getTotalUnreadCount() async {
    try {
      return await chatRepository.getTotalUnreadCount(userId: user.id!);
    } catch (e) {
      log('❌ Error getting total unread count: $e');
      return 0;
    }
  }

  // ==================== MESSAGES ====================

  /// Load messages for selected conversation
  Future<void> loadMessages() async {
    if (selectedConversationId.isEmpty) {
      log('❌ No conversation selected');
      return;
    }

    emit(ChatLoadingState());
    try {
      log('📥 Loading messages for conversation: $selectedConversationId');

      currentChatMessages = await chatRepository.getMessages(
        conversationId: selectedConversationId,
      );

      log('✅ Messages loaded: ${currentChatMessages.length}');
      emit(ChatLoadedState());

      scrollToBottom();

      // Subscribe to new messages
      _subscribeToMessages();
    } catch (e) {
      log('❌ Error loading messages: $e');
      emit(ChatErrorState(error: e.toString()));
      emit(ChatLoadedState());
    }
  }

  /// Send text message
  Future<void> sendMessage({required UserModel user}) async {
    final messageText = messageController.text.trim();

    if (messageText.isEmpty) {
      log('❌ Cannot send empty message');
      return;
    }

    if (selectedConversationId.isEmpty || selectedUserId.isEmpty) {
      log('❌ No conversation or user selected');
      return;
    }

    // Clear input immediately for better UX
    messageController.clear();

    try {
      log('📤 Sending message: $messageText');

      // Optimistically add message to UI
      final optimisticMessage = MessageModel(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        conversationId: selectedConversationId,
        senderId: user.id!,
        receiverId: selectedUserId,
        content: messageText,
        messageType: MessageType.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        senderName: user.name ?? 'You',
        senderPhoto: user.profilePhotoUrl ?? '',
      );

      currentChatMessages.add(optimisticMessage);
      emit(ChatLoadedState());
      scrollToBottom();

      // Send to backend
      final sentMessage = await chatRepository.sendMessage(
        conversationId: selectedConversationId,
        senderId: user.id!,
        receiverId: selectedUserId,
        content: messageText,
      );

      // Replace optimistic message with real one
      final index = currentChatMessages.indexWhere(
        (msg) => msg.id == optimisticMessage.id,
      );
      if (index != -1) {
        currentChatMessages[index] = sentMessage;
        emit(ChatLoadedState());
      }

      log('✅ Message sent successfully');
    } catch (e) {
      log('❌ Error sending message: $e');

      // Remove optimistic message on error
      currentChatMessages.removeWhere((msg) => msg.id.startsWith('temp_'));

      emit(ChatErrorState(error: 'Failed to send message'));
      emit(ChatLoadedState());
    }
  }

  /// Send file or image message
  Future<void> sendFileMessage({
    required File file,
    required MessageType messageType,
  }) async {
    if (selectedConversationId.isEmpty || selectedUserId.isEmpty) {
      log('❌ No conversation or user selected');
      return;
    }

    emit(ChatLoadingState());

    try {
      log('📤 Uploading ${messageType.name}...');

      final sentMessage = await chatRepository.sendFileMessage(
        conversationId: selectedConversationId,
        senderId: user.id!,
        receiverId: selectedUserId,
        file: file,
        messageType: messageType,
      );

      currentChatMessages.add(sentMessage);

      log('✅ File message sent successfully');
      emit(ChatLoadedState());
      scrollToBottom();
    } catch (e) {
      log('❌ Error sending file: $e');
      emit(ChatErrorState(error: 'Failed to send file'));
      emit(ChatLoadedState());
    }
  }

  // ==================== REAL-TIME ====================

  /// Subscribe to new messages in current conversation
  void _subscribeToMessages() {
    if (selectedConversationId.isEmpty) return;

    // Unsubscribe from previous channel if exists
    if (_messagesChannel != null) {
      chatRepository.unsubscribe(_messagesChannel!);
    }

    log('👂 Subscribing to messages in conversation: $selectedConversationId');

    _messagesChannel = chatRepository.subscribeToMessages(
      conversationId: selectedConversationId,
      onNewMessage: (newMessage) {
        log('📨 New message received: ${newMessage.content}');

        // Only add if it's not from current user (we already added optimistically)
        if (newMessage.senderId != user.id) {
          currentChatMessages.add(newMessage);
          emit(ChatLoadedState());
          scrollToBottom();

          // Mark as read since we're in the chat
          if (newMessage.receiverId == user.id) {
            markConversationAsRead(selectedConversationId);
          }
        }
      },
    );
  }

  /// Subscribe to conversation updates
  void _subscribeToConversations() {
    if (user.id == null) return;

    // Unsubscribe from previous channel if exists
    if (_conversationsChannel != null) {
      chatRepository.unsubscribe(_conversationsChannel!);
    }

    log('👂 Subscribing to conversation updates');

    _conversationsChannel = chatRepository.subscribeToConversations(
      userId: user.id!,
      onConversationUpdate: (updatedConversation) {
        log('🔄 Conversation updated: ${updatedConversation.id}');

        // Update in conversations list
        final index = conversations.indexWhere(
          (conv) => conv.id == updatedConversation.id,
        );
        if (index != -1) {
          conversations[index] = updatedConversation;
        } else {
          // New conversation
          conversations.insert(0, updatedConversation);
        }

        // Update filtered list if needed
        if (searchController.text.isEmpty) {
          filteredConversations = conversations;
        } else {
          searchConversations(searchController.text);
        }

        emit(ChatLoadedState());
      },
    );
  }

  // ==================== UTILITY METHODS ====================

  /// Format time for message display
  String formatTime(DateTime time) {
    final hour = time.hour > 12
        ? time.hour - 12
        : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  /// Check if message is from current user
  bool isMyMessage(MessageModel message) {
    return message.senderId == user.id;
  }

  /// Scroll to bottom of chat
  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Get user initials for avatar fallback
  String getInitials(String name) {
    if (name.isEmpty) return 'U';

    final nameParts = name.trim().split(' ');

    if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    } else {
      final firstInitial = nameParts.first[0].toUpperCase();
      final lastInitial = nameParts.last[0].toUpperCase();
      return '$firstInitial$lastInitial';
    }
  }

  /// Update state (force rebuild)
  void updateState() {
    emit(ChatLoadedState());
  }

  // ==================== CLEANUP ====================

  /// Clear all data and unsubscribe
  void clear() {
    // Unsubscribe from channels
    if (_messagesChannel != null) {
      chatRepository.unsubscribe(_messagesChannel!);
      _messagesChannel = null;
    }
    if (_conversationsChannel != null) {
      chatRepository.unsubscribe(_conversationsChannel!);
      _conversationsChannel = null;
    }

    // Clear controllers
    searchController.clear();
    messageController.clear();

    // Clear data
    conversations.clear();
    filteredConversations.clear();
    currentChatMessages.clear();

    // Reset state
    selectedConversationId = '';
    selectedUserId = '';
    selectedUserName = '';
    selectedUserAvatar = '';
    selectedUserIsOnline = false;
    selectedUserRole = '';
  }

  @override
  Future<void> close() {
    // Cleanup
    clear();

    // Dispose controllers
    searchController.dispose();
    messageController.dispose();
    scrollController.dispose();
    focusNode.dispose();

    return super.close();
  }

  Future<void> selectConversation(ConversationModel conversation,{required UserModel user}) async {
    emit(ChatLoadingState());

    try {
      // ✅ Check user.id first
      if (user.id == null) {
        throw Exception('User ID is null');
      }

      // If conversation doesn't have an ID yet, create it using match_id
      ConversationModel actualConversation = conversation;

      if (conversation.id.isEmpty) {
        if (conversation.matchId == null) {
          throw Exception('Cannot create conversation: match_id is null');
        }

        log('📝 Creating conversation for match: ${conversation.matchId}');
        actualConversation = await chatRepository
            .getOrCreateConversationByMatchId(
              matchId: conversation.matchId!,
              currentUserId: user.id!,
            );
      }

      // ✅ Check if conversation was created successfully
      if (actualConversation.id.isEmpty) {
        throw Exception('Failed to create conversation');
      }

      selectedConversationId = actualConversation.id;
      selectedUserId = actualConversation.otherUserId;
      selectedUserName = actualConversation.otherUserName;
      selectedUserAvatar = actualConversation.otherUserPhoto;
      selectedUserIsOnline = actualConversation.otherUserOnline;
      selectedUserRole = actualConversation.otherUserRole;

      log(
        '✅ Selected conversation: ${actualConversation.id} with ${actualConversation.otherUserName}',
      );

      // Mark as read if there are messages
      if (actualConversation.lastMessage != null) {
        await markConversationAsRead(actualConversation.id);
      }

      emit(ChatNavigateState());
    } catch (e) {
      log('❌ Error selecting conversation: $e');
      emit(ChatErrorState(error: e.toString()));
      emit(ChatLoadedState());
    }
  }
}
