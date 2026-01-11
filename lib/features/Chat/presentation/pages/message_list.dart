import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Chat/data/models/message.dart';
import 'package:mistakes/features/Chat/presentation/cubit/chat_cubit.dart';

import 'package:mistakes/global%20widgets/export.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageListPage extends StatelessWidget {
  const MessageListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final readChatCubit = context.read<ChatCubit>();
    final watchChatCubit = context.watch<ChatCubit>();

    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatLoadingState) {
         
        } else if (state is ChatNavigateState) {
          readChatCubit.loadMessages();
          Navigator.pushNamed(context, Routename.chatSetup);
        }
      },
      child: AppScaffold(
        body: Column(
          children: [
            AppbarWidget(
              title: 'Messages',
              size: size,
              onTap: () => Navigator.pop(context),
            ),

            ConversationSearchBar(size: size),

            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoadingState &&
                      watchChatCubit.conversations.isEmpty) {
                    Center(
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
                      readChatCubit.selectConversation(conversation);
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

    return AppshadowContainer(
      color: AppColors.white,
      padding: EdgeInsets.all(size.width * 0.04),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            ConversationAvatar(
              size: size,
              userName: conversation.userName,
              userAvatar: conversation.userAvatar,
              isOnline: conversation.isOnline,
              initials: chatCubit.getInitials(conversation.userName),
            ),
            SizedBox(width: size.width * 0.03),

            Expanded(
              child: ConversationDetails(
                size: size,
                conversation: conversation,
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
          child: userAvatar != null
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

  const ConversationDetails({
    super.key,
    required this.size,
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                conversation.userName,
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
              timeago.format(conversation.timestamp),
              style: GoogleFonts.ptSans(fontSize: 12.sp, color: AppColors.grey),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.005),
        Row(
          children: [
            Expanded(
              child: Text(
                conversation.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.ptSans(
                  fontSize: 14.sp,
                  color: conversation.unreadCount > 0
                      ? AppColors.lightblack
                      : AppColors.grey,
                  fontWeight: conversation.unreadCount > 0
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
            if (conversation.unreadCount > 0) ...[
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
                  conversation.unreadCount.toString(),
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
