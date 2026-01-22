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

  final searchController = TextEditingController();
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final focusNode = FocusNode();
  List<MessageModel> currentChatMessages = [];
  String selectedConversationId = '';
  String selectedUserId = '';

  bool selectedUserIsOnline = false;
  String selectedUserRole = '';
  RealtimeChannel? messagesChannel;
  RealtimeChannel? conversationsChannel;
  String selectedUserName = '';
  String selectedUserAvatar = '';
  List<ConversationModel> conversations = [];
  List<ConversationModel> filteredConversations = [];
  String? currentUserProfileId;
  Future<void> loadConversations({required UserModel user}) async {
    if (user.id == null) {
      log('User id is null, cannot load conversations');
      return;
    }

    emit(ChatLoadingState());
    try {
      log('Loading conversations for user: ${user.id}');

      currentUserProfileId = await chatRepository.getProfileId(user.id!);

      conversations = await chatRepository.getConversations(userId: user.id!);
      filteredConversations = conversations;

      log('Conversations loaded: ${conversations.length}');
      emit(ChatLoadedState());
      _subscribeToConversations(user: user);
    } catch (e) {
      log('Error loading conversations: $e');
      emit(ChatErrorState(error:"Failed to load conversations"));
    }
  }
  void searchConversations(String query) {
    log('Searching: $query');

    if (query.isEmpty) {
      filteredConversations = conversations;
    } else {
      filteredConversations = conversations.where((conv) {
        return conv.otherUserName.toLowerCase().contains(query.toLowerCase()) ||
            (conv.lastMessage?.toLowerCase().contains(query.toLowerCase()) ??
                false);
      }).toList();
    }

    log('Filtered conversations: ${filteredConversations.length}');
    emit(ChatLoadedState());
  }
  void clearSearch() {
    searchController.clear();
    filteredConversations = conversations;
    log('Search cleared');
    emit(ChatLoadedState());
  }
  Future<void> startConversationWith({
    required String otherUserId,
    required bool currentUserIsMentor,
    required UserModel user,
  }) async {
    emit(ChatLoadingState());

    try {
      log('Starting conversation with user: $otherUserId');

      final conversation = await chatRepository.getOrCreateConversation(
        mentorId: currentUserIsMentor ? user.id! : otherUserId,
        menteeId: currentUserIsMentor ? otherUserId : user.id!,
        currentUserId: user.id!,
      );

      await selectConversation(conversation, user: user);
    } catch (e) {
      log('Error starting conversation: $e');
      emit(ChatErrorState(error: "Failed to start conversation"));
    }
  }

  Future<void> markConversationAsRead(
    String conversationId, {
    required UserModel user,
  }) async {
    try {
      await chatRepository.markMessagesAsRead(
        conversationId: conversationId,
        userId: currentUserProfileId!,
      );

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

      log('Marked conversation as read: $conversationId');
    } catch (e) {
      log('Error marking as read: $e');
    }
  }
  Future<int> getTotalUnreadCount({required UserModel user}) async {
    try {
      return await chatRepository.getTotalUnreadCount(userId: user.id!);
    } catch (e) {
      log('Error getting total unread count: $e');
      return 0;
    }
  }
  Future<void> loadMessages({required UserModel user}) async {
    if (selectedConversationId.isEmpty) {
      log('No conversation selected');
      return;
    }

    emit(ChatLoadingState());
    try {
      log('Loading messages for conversation: $selectedConversationId');

      currentChatMessages = await chatRepository.getMessages(
        conversationId: selectedConversationId,
      );

      log('Messages loaded: ${currentChatMessages.length}');
      await markConversationAsRead(selectedConversationId, user: user);

      scrollToBottom();
      _subscribeToMessages(user: user);
      emit(ChatLoadedState());
    } catch (e) {
      log('Error loading messages: $e');
      emit(ChatErrorState(error: "Failed to load messages"));
    }
  }
  Future<void> sendMessage({required UserModel user}) async {
    final messageText = messageController.text.trim();

    if (messageText.isEmpty) {
      log('Cannot send empty message');
      return;
    }

    if (selectedConversationId.isEmpty || selectedUserId.isEmpty) {
      log('No conversation or user selected');
      return;
    }
    messageController.clear();

    try {
      emit(ChatLoadingState());
      log('Sending message: $messageText');
      final optimisticMessage = MessageModel(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        conversationId: selectedConversationId,
        senderId: currentUserProfileId ?? "",
        receiverId: selectedUserId,
        content: messageText,
        messageType: MessageType.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        senderName: user.name ?? 'You',
        senderPhoto: user.profilePhotoUrl ?? '',
      );

      currentChatMessages.add(optimisticMessage);
      scrollToBottom();
      final sentMessage = await chatRepository.sendMessage(
        conversationId: selectedConversationId,
        senderId: user.id!,
        receiverId: selectedUserId,
        content: messageText,
      );
      final index = currentChatMessages.indexWhere(
        (msg) => msg.id == optimisticMessage.id,
      );
      if (index != -1) {
        currentChatMessages[index] = sentMessage;
        emit(ChatLoadedState());
      }
      loadMessages(user: user);
      log('Message sent successfully');
      loadConversations(user: user);
      emit(ChatLoadedState());
    } catch (e) {
      log('Error sending message: $e');
      currentChatMessages.removeWhere((msg) => msg.id.startsWith('temp_'));
      emit(ChatErrorState(error: 'Failed to send message'));
    }
  }

  Future<void> sendFileMessage({
    required File file,
    required MessageType messageType,
    required UserModel user,
  }) async {
    if (selectedConversationId.isEmpty || selectedUserId.isEmpty) {
      log('No conversation or user selected');
      return;
    }

    emit(ChatLoadingState());

    try {
      log('Uploading ${messageType.name}...');

      final sentMessage = await chatRepository.sendFileMessage(
        conversationId: selectedConversationId,
        senderId: user.id!,
        receiverId: selectedUserId,
        file: file,
        messageType: messageType,
      );

      currentChatMessages.add(sentMessage);

      log('File message sent successfully');
      emit(ChatLoadedState());
      scrollToBottom();
    } catch (e) {
      log('Error sending file: $e');
      emit(ChatErrorState(error: 'Failed to send file'));
    }
  }
  void _subscribeToMessages({required UserModel user}) {
    if (selectedConversationId.isEmpty) return;
    if (messagesChannel != null) {
      chatRepository.unsubscribe(messagesChannel!);
    }

    log('Subscribing to messages in conversation: $selectedConversationId');

    messagesChannel = chatRepository.subscribeToMessages(
      conversationId: selectedConversationId,
      onNewMessage: (newMessage) {
        log('New message received: ${newMessage.content}');
        if (newMessage.senderId != currentUserProfileId) {
          currentChatMessages.add(newMessage);
          emit(ChatLoadedState());
          scrollToBottom();
          if (newMessage.receiverId == currentUserProfileId) {
            markConversationAsRead(selectedConversationId, user: user);
          }
        }
      },
    );
  }

  void _subscribeToConversations({required UserModel user}) {
    if (user.id == null) return;
    if (conversationsChannel != null) {
      chatRepository.unsubscribe(conversationsChannel!);
    }

    log('Subscribing to conversation updates');

    conversationsChannel = chatRepository.subscribeToConversations(
      userId: user.id!,
      onConversationUpdate: (updatedConversation) {
        log('Conversation updated: ${updatedConversation.id}');
        final index = conversations.indexWhere(
          (conv) => conv.id == updatedConversation.id,
        );
        if (index != -1) {
          conversations[index] = updatedConversation;
        } else {
          conversations.insert(0, updatedConversation);
        }

        if (searchController.text.isEmpty) {
          filteredConversations = conversations;
        } else {
          searchConversations(searchController.text);
        }

        emit(ChatLoadedState());
      },
    );
  }

  String formatTime(DateTime time) {
    final hour = time.hour > 12
        ? time.hour - 12
        : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  bool isMyMessage(MessageModel message, {required UserModel user}) {
    return message.senderId == currentUserProfileId;
  }
  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients &&
          scrollController.positions.length == 1) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
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

  void updateState() {
    emit(ChatLoadedState());
  }
  void clear() {
    if (messagesChannel != null) {
      chatRepository.unsubscribe(messagesChannel!);
      messagesChannel = null;
    }
    if (conversationsChannel != null) {
      chatRepository.unsubscribe(conversationsChannel!);
      conversationsChannel = null;
    }
    searchController.clear();
    messageController.clear();
    conversations.clear();
    filteredConversations.clear();
    currentChatMessages.clear();
    selectedConversationId = '';
    selectedUserId = '';
    selectedUserName = '';
    selectedUserAvatar = '';
    selectedUserIsOnline = false;
    selectedUserRole = '';
  }

 

  Future<void> selectConversation(
    ConversationModel conversation, {
    required UserModel user,
  }) async {
    emit(ChatLoadingState());

    try {
      if (user.id == null) {
        log("User id is null, cannot select conversation");
        return;
      }
      ConversationModel actualConversation = conversation;

      if (conversation.id.isEmpty) {
        if (conversation.matchId == null) {
          throw Exception('Cannot create conversation: match_id is null');
        }

        log('Creating conversation for match: ${conversation.matchId}');
        actualConversation = await chatRepository
            .getOrCreateConversationByMatchId(
              matchId: conversation.matchId!,
              currentUserId: user.id!,
            );
      }
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
        'Selected conversation: ${actualConversation.id} with ${actualConversation.otherUserName}',
      );
      if (actualConversation.lastMessage != null) {
        await markConversationAsRead(actualConversation.id, user: user);
      }

      emit(ChatNavigateState());
    } catch (e) {
      log('Error selecting conversation: $e');
      emit(ChatErrorState(error: "Failed to select conversation"));
    }
  }

  Future<void> updateOnlineStatus(
    bool isOnline, {
    required UserModel user,
  }) async {
    emit(ChatLoadingState());
    if (user.id == null) return;

    try {
      await chatRepository.updateOnlineStatus(
        userId: user.id!,
        isOnline: isOnline,
      );
      emit(ChatLoadedState());
    } catch (e) {
      log('Error updating online status: $e');
    }
  }

  Future<void> clearCurrentChat({required UserModel user}) async {
    if (selectedConversationId.isEmpty) {
      log('No conversation selected');
      return;
    }

    emit(ChatLoadingState());
    try {
      log('Clearing chat: $selectedConversationId');

      await chatRepository.clearChat(conversationId: selectedConversationId);
      currentChatMessages.clear();

      log('Chat cleared successfully');
      emit(ChatLoadedState());
    } catch (e) {
      log('Error clearing chat: $e');
      emit(ChatErrorState(error: 'Failed to clear chat'));
    }
  }

  Future<void> toggleMuteCurrentConversation({required UserModel user}) async {
    if (selectedConversationId.isEmpty) {
      log('No conversation selected');
      return;
    }

    try {
      final conversation = conversations.firstWhere(
        (conv) => conv.id == selectedConversationId,
        orElse: () => throw Exception('Conversation not found'),
      );

      final newMuteStatus = !(conversation.isMuted ?? false);

      await chatRepository.toggleMuteConversation(
        conversationId: selectedConversationId,
        isMuted: newMuteStatus,
      );
      final index = conversations.indexWhere(
        (conv) => conv.id == selectedConversationId,
      );
      if (index != -1) {
        conversations[index] = conversations[index].copyWith(
          isMuted: newMuteStatus,
        );
      }

      log('Conversation ${newMuteStatus ? "muted" : "unmuted"}');
      emit(ChatLoadedState());
    } catch (e) {
      log('Error toggling mute: $e');
      emit(ChatErrorState(error: 'Failed to toggle mute'));
    }
  }

   @override
  Future<void> close() {
    clear();
    searchController.dispose();
    messageController.dispose();
    scrollController.dispose();
    focusNode.dispose();

    return super.close();
  }
}
