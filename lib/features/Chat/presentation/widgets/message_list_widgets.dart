import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../Authentication/presentation/cubit/authentication_cubit.dart';
import '../../data/models/message.dart';
import '../cubit/chat_cubit.dart';

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
              userName: conversation.otherUserName,
              userAvatar: conversation.otherUserPhoto, 
              isOnline: conversation.otherUserOnline, 
              initials: chatCubit.getInitials(
                conversation.otherUserName,
              ), 
            ),
            SizedBox(width: size.width * 0.03),

            Expanded(
              child: ConversationDetails(
                size: size,
                conversation: conversation,
                currentUserId: currentUserId, 
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
                  child:InAppText(text: initials, fontweight: FontWeight.bold, color: AppColors.blue, size: 20),
                ),
        ),
        if (isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size.width * 0.012,
              height: size.width * 0.012,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: size.width * 0.005),
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
    final unreadCount = conversation.getUnreadCount(currentUserId); 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                conversation.otherUserName, 
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
              conversation.lastMessageTime, 
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
                    .displayLastMessage,
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