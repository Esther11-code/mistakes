import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mistakes/features/Authentication/data/model/user_model.dart';
import 'package:mistakes/features/Chat/data/chat_repo.dart';
import 'package:mistakes/features/Chat/data/models/message.dart';
import 'package:mistakes/features/Chat/data/models/message_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatRepo chatRepo;

  ChatCubit(this.chatRepo) : super(ChatInitial());

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

  // State
  String selectedConversationId = '';
  String selectedUserId = '';
  String selectedUserName = '';
  String? selectedUserAvatar;
  bool selectedUserIsOnline = false;

  // Load conversations list
  loadConversations() async {
    emit(ChatLoadingState());
    try {
      conversations = await chatRepo.getConversations(userId: user.id!);
      filteredConversations = conversations;
      log('Conversations loaded: ${conversations.length}');
      emit(ChatLoadedState());
    } catch (e) {
      log('Error loading conversations: $e');
      emit(ChatErrorState(error: e.toString()));
      emit(ChatLoadedState());
    }
  }

  // Search conversations
  searchConversations(String query) {
    emit(ChatLoadingState());
    log('Searching: $query');
    if (query.isEmpty) {
      filteredConversations = conversations;
    } else {
      filteredConversations = conversations.where((conv) {
        return conv.userName.toLowerCase().contains(query.toLowerCase()) ||
            conv.lastMessage.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    log('Filtered conversations: ${filteredConversations.length}');
    emit(ChatLoadedState());
  }

  // Clear search
  clearSearch() {
    emit(ChatLoadingState());
    searchController.clear();
    filteredConversations = conversations;
    log('Search cleared');
    emit(ChatLoadedState());
  }

  // Select conversation and navigate
  selectConversation(ConversationModel conversation) {
    emit(ChatLoadingState());
    selectedConversationId = conversation.id;
    selectedUserId = conversation.userId;
    selectedUserName = conversation.userName;
    selectedUserAvatar = conversation.userAvatar;
    selectedUserIsOnline = conversation.isOnline;
    log('Selected conversation: ${conversation.id}');

    // Mark as read
    markAsRead(conversation.id);

    emit(ChatNavigateState());
  }

  // Mark conversation as read
  markAsRead(String conversationId) async {
    try {
      await chatRepo.markAsRead(conversationId: conversationId);

      // Update local data
      final index = conversations.indexWhere(
        (conv) => conv.id == conversationId,
      );
      if (index != -1) {
        conversations[index] = conversations[index].copyWith(unreadCount: 0);
      }

      final filteredIndex = filteredConversations.indexWhere(
        (conv) => conv.id == conversationId,
      );
      if (filteredIndex != -1) {
        filteredConversations[filteredIndex] =
            filteredConversations[filteredIndex].copyWith(unreadCount: 0);
      }

      log('Marked as read: $conversationId');
    } catch (e) {
      log('Error marking as read: $e');
    }
  }

  // Load messages for selected conversation
  loadMessages() async {
    emit(ChatLoadingState());
    try {
      currentChatMessages = await chatRepo.getMessages(
        conversationId: selectedConversationId,
      );
      log('Messages loaded: ${currentChatMessages.length}');
      emit(ChatLoadedState());
      scrollToBottom();
    } catch (e) {
      log('Error loading messages: $e');
      emit(ChatErrorState(error: e.toString()));
      emit(ChatLoadedState());
    }
  }

  // Send message
  sendMessage() async {
    final messageText = messageController.text.trim();

    if (messageText.isEmpty) {
      log('Cannot send empty message');
      return;
    }

    emit(ChatLoadingState());

    try {
      final message = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: selectedConversationId,
        senderId: user.id!,
        receiverId: selectedUserId,
        message: messageText,
        timestamp: DateTime.now(),
        isRead: false,
        type: MessageType.text,
      );

      // Add to local list immediately
      currentChatMessages.add(message);
      messageController.clear();

      log('Sending message: $messageText');
      emit(ChatLoadedState());
      scrollToBottom();

      // Send to backend
      await chatRepo.sendMessage(message: message);
      log('Message sent successfully');
    } catch (e) {
      log('Error sending message: $e');
      emit(ChatErrorState(error: e.toString()));
      emit(ChatLoadedState());
    }
  }

  // Format time for messages
  String formatTime(DateTime time) {
    final hour = time.hour > 12
        ? time.hour - 12
        : time.hour == 0
        ? 12
        : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  // Check if message is sent by current user
  bool isMyMessage(MessageModel message) {
    return message.senderId == user.id;
  }

  // Scroll to bottom
  scrollToBottom() {
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

  // Get user initials for avatar
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

  // Update state
  updateState() {
    emit(ChatLoadingState());
    emit(ChatLoadedState());
  }

  // Clear all data
  void clear() {
    searchController.clear();
    messageController.clear();
    conversations.clear();
    filteredConversations.clear();
    currentChatMessages.clear();
    selectedConversationId = '';
    selectedUserId = '';
    selectedUserName = '';
    selectedUserAvatar = null;
    selectedUserIsOnline = false;
  }

  @override
  Future<void> close() {
    searchController.dispose();
    messageController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    return super.close();
  }
}
