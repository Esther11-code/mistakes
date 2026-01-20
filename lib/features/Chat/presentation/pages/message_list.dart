// lib/features/Chat/presentation/pages/message_list_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Chat/data/models/message.dart';
import 'package:mistakes/features/Chat/presentation/cubit/chat_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

class MessageListPage extends StatefulWidget {
  const MessageListPage({super.key});

  @override
  State<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    final chatCubit = context.read<ChatCubit>();
    final authCubit = context.read<AuthenticationCubit>();
    WidgetsBinding.instance.addObserver(this);

  
    chatCubit.loadConversations(user: authCubit.user);

    chatCubit.updateOnlineStatus(true, user: authCubit.user);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final chatCubit = context.read<ChatCubit>();

    switch (state) {
      case AppLifecycleState.resumed:
        // App came to foreground
        chatCubit.updateOnlineStatus(
          true,
          user: context.read<AuthenticationCubit>().user,
        );
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        // App went to background
        chatCubit.updateOnlineStatus(
          false,
          user: context.read<AuthenticationCubit>().user,
        );
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final readChatCubit = context.read<ChatCubit>();
    final watchChatCubit = context.watch<ChatCubit>();
    final watchAuthCubit = context.read<AuthenticationCubit>();

    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatLoadingState) {
          // Optional: show loading indicator
        } else if (state is ChatNavigateState) {
          readChatCubit.loadMessages(user: watchAuthCubit.user);
          Navigator.pushNamed(context, Routename.menteeChat);
        }
      },
      child: AppScaffold(
        body: Column(
          children: [
            AppbarWidget(title: 'Messages', size: size),

            ConversationSearchBar(size: size),

            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoadingState &&
                      watchChatCubit.conversations.isEmpty) {
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColors.blue,
                        size: 30.sp,
                      ),
                    );
                  }

                  if (watchChatCubit.filteredConversations.isEmpty) {
                    return ConversationEmptyState(
                      size: size,
                      hasSearch:
                          watchChatCubit.searchController.text.isNotEmpty,
                    );
                  }

                  return ConversationsList(
                    size: size,
                    conversations: watchChatCubit.filteredConversations,
                    onTap: (conversation) {
                      readChatCubit.startConversationWith(
                        otherUserId: conversation.otherUserId,
                        currentUserIsMentor: context
                            .read<AuthenticationCubit>()
                            .user
                            .isMentor,
                        user: context.read<AuthenticationCubit>().user,
                      );
                      // readChatCubit.selectConversation(
                      //   conversation,
                      //   user: context.watch<AuthenticationCubit>().user,
                      // );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ... ConversationSearchBar stays the same ...

class ConversationSearchBar extends StatelessWidget {
  final Size size;

  const ConversationSearchBar({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final readChatCubit = context.read<ChatCubit>();
    final watchChatCubit = context.watch<ChatCubit>();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.015,
      ),
      child: AppshadowContainer(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.005,
        ),
        color: AppColors.white,
        child: ApptextField(
          controller: watchChatCubit.searchController,
          hintText: "Search conversations...",
          prefixIconn: Icon(Icons.search, color: AppColors.grey, size: 20),
          suffixIcon: watchChatCubit.searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppColors.grey, size: 20),
                  onPressed: () => readChatCubit.clearSearch(),
                )
              : null,
          onChange: (value) => readChatCubit.searchConversations(value ?? ""),
        ),
      ),
    );
  }
}

// ... ConversationEmptyState stays the same ...

class ConversationsList extends StatelessWidget {
  final Size size;
  final List<ConversationModel> conversations;
  final Function(ConversationModel) onTap;

  const ConversationsList({
    super.key,
    required this.size,
    required this.conversations,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.01,
      ),
      itemCount: conversations.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: size.height * 0.01),
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return ConversationListItem(
          conversation: conversation,
          size: size,
          onTap: () => onTap(conversation),
        );
      },
    );
  }
}

class ConversationListItem extends StatelessWidget {
  final ConversationModel conversation;
  final Size size;
  final VoidCallback onTap;

  const ConversationListItem({
    super.key,
    required this.conversation,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chatCubit = context.read<ChatCubit>();
    final currentUserId = context.read<AuthenticationCubit>().user.id ?? '';

    return AppshadowContainer(
      color: AppColors.white,
      padding: EdgeInsets.all(size.width * 0.04),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            ConversationAvatar(
              size: size,
              userName: conversation.otherUserName, // UPDATED
              userAvatar: conversation.otherUserPhoto, // UPDATED
              isOnline: conversation.otherUserOnline, // UPDATED
              initials: chatCubit.getInitials(
                conversation.otherUserName,
              ), // UPDATED
            ),
            SizedBox(width: size.width * 0.03),

            Expanded(
              child: ConversationDetails(
                size: size,
                conversation: conversation,
                currentUserId: currentUserId, // ADDED
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConversationAvatar extends StatelessWidget {
  final Size size;
  final String userName;
  final String? userAvatar;
  final bool isOnline;
  final String initials;

  const ConversationAvatar({
    super.key,
    required this.size,
    required this.userName,
    this.userAvatar,
    required this.isOnline,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size.width * 0.14,
          height: size.width * 0.14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.blue.withAlpha(30),
          ),
          child: userAvatar != null && userAvatar!.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    userAvatar!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          initials,
                          style: GoogleFonts.ptSans(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blue,
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text(
                    initials,
                    style: GoogleFonts.ptSans(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue,
                    ),
                  ),
                ),
        ),
        if (isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}

class ConversationDetails extends StatelessWidget {
  final Size size;
  final ConversationModel conversation;
  final String currentUserId;

  const ConversationDetails({
    super.key,
    required this.size,
    required this.conversation,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final unreadCount = conversation.getUnreadCount(currentUserId); // UPDATED

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                conversation.otherUserName, // UPDATED
                style: GoogleFonts.ptSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightblack,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              conversation.lastMessageTime, // UPDATED - using helper method
              style: GoogleFonts.ptSans(fontSize: 12.sp, color: AppColors.grey),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.005),
        Row(
          children: [
            Expanded(
              child: Text(
                conversation
                    .displayLastMessage, // UPDATED - using helper method
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.ptSans(
                  fontSize: 14.sp,
                  color: unreadCount > 0
                      ? AppColors.lightblack
                      : AppColors.grey,
                  fontWeight: unreadCount > 0
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
            if (unreadCount > 0) ...[
              SizedBox(width: size.width * 0.02),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02,
                  vertical: size.height * 0.003,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  unreadCount.toString(),
                  style: GoogleFonts.ptSans(
                    fontSize: 12.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class ConversationEmptyState extends StatelessWidget {
  final Size size;
  final bool hasSearch;

  const ConversationEmptyState({
    super.key,
    required this.size,
    required this.hasSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasSearch ? Icons.search_off : Icons.chat_bubble_outline,
            size: 80.sp,
            color: AppColors.blackColor.withAlpha(100),
          ),
          SizedBox(height: size.height * 0.02),
          InAppText(
            text: hasSearch ? "No results found" : "No conversations yet",
            size: 18,
            color: AppColors.blackColor,
          ),
          SizedBox(height: size.height * 0.01),
          InAppText(
            text: hasSearch
                ? "Try a different search"
                : "Start a conversation to connect",
            size: 14,
            color: AppColors.blackColor,
          ),
        ],
      ),
    );
  }
}
