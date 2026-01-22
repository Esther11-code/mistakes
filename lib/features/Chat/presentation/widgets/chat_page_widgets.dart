import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/features/Authentication/data/model/user_model.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Chat/presentation/cubit/chat_cubit.dart';
import 'package:mistakes/features/Home/presentation/cubit/home_cubit.dart';
import 'package:mistakes/features/Profile/presentation/cubit/mentor_cubit.dart';
import 'package:mistakes/features/Profile/presentation/cubit/profile_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../constants/utils/app_colors.dart';
import '../../data/models/message_model.dart';

class ChatAppBar extends StatelessWidget {
  final String userName;
  final String? userAvatar;
  final bool isOnline;
  final String userRole; // NEW
  final Size size;

  const ChatAppBar({
    super.key,
    required this.userName,
    this.userAvatar,
    required this.isOnline,
    required this.userRole,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final readChatCubit = context.read<ChatCubit>();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.01,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.background),
            onPressed: () => Navigator.pop(context),
          ),
          ChatUserAvatar(
            userName: userName,
            userAvatar: userAvatar,
            isOnline: isOnline,
            size: size,
            initials: readChatCubit.getInitials(userName),
          ),
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InAppText(
                  text: userName,
                  size: 18,
                  fontweight: FontWeight.w600,
                  color: AppColors.blue,
                ),
                Row(
                  children: [
                    InAppText(
                      text: isOnline ? 'Online' : 'Offline',
                      size: 12,
                      color: isOnline ? Colors.green : AppColors.grey,
                    ),
                    if (userRole.isNotEmpty) ...[
                      InAppText(text: ' • ', size: 14, color: AppColors.grey),
                      InAppText(
                        text: userRole == 'mentor' ? 'Mentor' : 'Mentee',
                        size: 12,
                        color: AppColors.grey,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.blue),
            onPressed: () {
              showChatOptionsMenu(context, size);
            },
          ),
        ],
      ),
    );
  }
}

class ChatUserAvatar extends StatelessWidget {
  final String userName;
  final String? userAvatar;
  final bool isOnline;
  final Size size;
  final String initials;

  const ChatUserAvatar({
    super.key,
    required this.userName,
    this.userAvatar,
    required this.isOnline,
    required this.size,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size.width * 0.12,
          height: size.width * 0.12,
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
                        child: InAppText(text: initials, color: AppColors.blue),
                      );
                    },
                  ),
                )
              : Center(
                  child: InAppText(
                    text: initials,
                    fontweight: FontWeight.bold,
                    color: AppColors.blue,
                  ),
                ),
        ),

        if (isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size.width * 0.03,
              height: size.width * 0.03,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white,
                  width: size.width * 0.002,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class ChatEmptyState extends StatelessWidget {
  final Size size;

  const ChatEmptyState({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80.sp,
            color: AppColors.blue.withAlpha(100),
          ),
          SizedBox(height: size.height * 0.02),
          InAppText(text: "No messages yet", color: AppColors.blue),
          SizedBox(height: size.height * 0.01),
          InAppText(
            text: "Start the conversation!",
            size: 16,
            color: AppColors.blue,
          ),
        ],
      ),
    );
  }
}

class MessagesList extends StatelessWidget {
  final Size size;
  final List<MessageModel> messages;
  final ScrollController scrollController;
  final String currentUserId;

  const MessagesList({
    super.key,
    required this.size,
    required this.messages,
    required this.scrollController,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final readChatCubit = context.read<ChatCubit>();
    final watchChatCubit = context.watch<ChatCubit>();

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.02,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMyMessage = watchChatCubit.isMyMessage(
          message,
          user: context.read<AuthenticationCubit>().user,
        );
        final showAvatar =
            index == messages.length - 1 ||
            (index < messages.length - 1 &&
                readChatCubit.isMyMessage(
                      messages[index + 1],
                      user: context.read<AuthenticationCubit>().user,
                    ) !=
                    isMyMessage);

        return MessageBubble(
          message: message,
          isMyMessage: isMyMessage,
          showAvatar: showAvatar,
          size: size,
          time: readChatCubit.formatTime(message.createdAt),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMyMessage;
  final bool showAvatar;
  final Size size;
  final String time;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMyMessage,
    required this.showAvatar,
    required this.size,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.015),
      child: Row(
        mainAxisAlignment: isMyMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMyMessage && showAvatar)
            MessageAvatar(
              size: size,
              color: AppColors.filledColor,
              avatarUrl: message.senderPhoto,
              initials: _getInitials(message.senderName),
            ),
          if (!isMyMessage && showAvatar) SizedBox(width: size.width * 0.02),
          if (!isMyMessage && !showAvatar) SizedBox(width: size.width * 0.1),

          Flexible(child: _buildMessageContent(context)),

          if (isMyMessage && showAvatar) SizedBox(width: size.width * 0.02),
          if (isMyMessage && showAvatar)
            MessageAvatar(
              size: size,
              color: AppColors.blue,
              avatarUrl: message.senderPhoto,
              initials: _getInitials(message.senderName),
            ),
          if (isMyMessage && !showAvatar) SizedBox(width: size.width * 0.1),
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (message.messageType) {
      case MessageType.image:
        return _buildImageMessage(context);
      case MessageType.file:
        return _buildFileMessage(context);
      case MessageType.text:
      default:
        return _buildTextMessage(context);
    }
  }

  Widget _buildTextMessage(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.015,
      ),
      decoration: BoxDecoration(
        color: isMyMessage ? AppColors.blue : AppColors.filledColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(isMyMessage ? 20 : 4),
          bottomRight: Radius.circular(isMyMessage ? 4 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InAppText(text: message.content, color: AppColors.white, size: 16),
          SizedBox(height: size.height * 0.005),
          _buildMessageFooter(),
        ],
      ),
    );
  }

  Widget _buildImageMessage(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: size.width * 0.7),
      decoration: BoxDecoration(
        color: isMyMessage ? AppColors.blue : AppColors.filledColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(isMyMessage ? 20 : 4),
          bottomRight: Radius.circular(isMyMessage ? 4 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              message.fileUrl!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                    color: AppColors.blue,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: Icon(Icons.broken_image, size: 50),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: _buildMessageFooter(),
          ),
        ],
      ),
    );
  }

  Widget _buildFileMessage(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.015,
      ),
      decoration: BoxDecoration(
        color: isMyMessage ? AppColors.blue : AppColors.filledColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(isMyMessage ? 20 : 4),
          bottomRight: Radius.circular(isMyMessage ? 4 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.insert_drive_file, color: AppColors.white, size: 24),
              SizedBox(width: size.width * 0.02),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InAppText(
                      text: message.fileName ?? 'File',
                      color: AppColors.white,
                    ),
                    if (message.fileSize != null)
                      InAppText(
                        text: message.formattedFileSize,
                        size: 14,
                        color: AppColors.white.withAlpha(80),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.005),
          _buildMessageFooter(),
        ],
      ),
    );
  }

  Widget _buildMessageFooter() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InAppText(text: time, size: 12, color: AppColors.white.withAlpha(80)),
        if (isMyMessage) ...[
          SizedBox(width: 4),
          Icon(
            message.isRead ? Icons.done_all_rounded : Icons.done_rounded,
            size: 18.sp,
            color: message.isRead
                ? Colors.lightBlueAccent
                : AppColors.white.withAlpha(80),
          ),
        ],
      ],
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final nameParts = name.trim().split(' ');
    if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    }
    return '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase();
  }
}

class MessageAvatar extends StatelessWidget {
  final Size size;
  final Color color;
  final String? avatarUrl;
  final String initials;

  const MessageAvatar({
    super.key,
    required this.size,
    required this.color,
    this.avatarUrl,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: color,
      backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
          ? NetworkImage(avatarUrl!)
          : null,
      child: avatarUrl == null || avatarUrl!.isEmpty
          ? InAppText(text: initials, size: 14, fontweight: FontWeight.bold)
          : null,
    );
  }
}

class ChatMessageInput extends StatelessWidget {
  final Size size;

  const ChatMessageInput({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final readChatCubit = context.read<ChatCubit>();
    final watchChatCubit = context.watch<ChatCubit>();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.015,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            AttachmentButton(
              size: size,
              onPressed: () {
                showAttachmentOptions(context, size, readChatCubit);
              },
            ),
            SizedBox(width: size.width * 0.03),

            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.filledColor,
                    width: size.width * 0.002,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: watchChatCubit.messageController,
                        focusNode: watchChatCubit.focusNode,
                        decoration: InputDecoration(
                          hintText: 'Enter a message',
                          hintStyle: GoogleFonts.ptSans(
                            color: AppColors.filledColor,
                            fontSize: 15.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: size.height * 0.015,
                          ),
                        ),
                        style: GoogleFonts.ptSans(
                          color: AppColors.blue,
                          fontSize: 15.sp,
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: AppColors.filledColor,
                      ),
                      onPressed: () {
                        // TODO: emoji picker
                      },
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: size.width * 0.03),
            SendMessageButton(
              size: size,
              onPressed: () => readChatCubit.sendMessage(
                user: context.read<AuthenticationCubit>().user,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttachmentButton extends StatelessWidget {
  final Size size;
  final VoidCallback onPressed;

  const AttachmentButton({
    super.key,
    required this.size,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.11,
      height: size.width * 0.11,
      decoration: BoxDecoration(
        color: AppColors.background,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.add, color: AppColors.white, size: 22.sp),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class SendMessageButton extends StatelessWidget {
  final Size size;
  final VoidCallback onPressed;

  const SendMessageButton({
    super.key,
    required this.size,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size.width * 0.11,
        height: size.width * 0.11,
        decoration: BoxDecoration(
          color: AppColors.background,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.blue.withAlpha(30),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(Icons.send_rounded, color: AppColors.white, size: 20),
      ),
    );
  }
}

void showAttachmentOptions(
  BuildContext context,
  Size size,
  ChatCubit chatCubit,
) {
  final readAuthCubit = context.read<AuthenticationCubit>();
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.03,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.inactive,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AttachmentOption(
                icon: Icons.image,
                label: 'Gallery',
                color: Colors.purple,
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    chatCubit.sendFileMessage(
                      user: readAuthCubit.user,
                      file: File(image.path),
                      messageType: MessageType.image,
                    );
                  }
                },
              ),
              AttachmentOption(
                icon: Icons.camera_alt,
                label: 'Camera',
                color: Colors.pink,
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final readAuthCubit = context.read<AuthenticationCubit>();
                  final image = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) {
                    chatCubit.sendFileMessage(
                      user: readAuthCubit.user,
                      file: File(image.path),
                      messageType: MessageType.image,
                    );
                  }
                },
              ),
              AttachmentOption(
                icon: Icons.insert_drive_file,
                label: 'Document',
                color: Colors.blue,
                onTap: () async {
                  Navigator.pop(context);
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: [
                      'pdf',
                      'doc',
                      'docx',
                      'txt',
                      'xls',
                      'xlsx',
                    ],
                  );

                  if (result != null && result.files.single.path != null) {
                    chatCubit.sendFileMessage(
                      user: readAuthCubit.user,
                      file: File(result.files.single.path!),
                      messageType: MessageType.file,
                    );
                  }
                },
              ),
              AttachmentOption(
                icon: Icons.location_on,
                label: 'Location',
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: "Location sharing coming soon",
                    backgroundColor: AppColors.blue,
                  );
                },
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
        ],
      ),
    ),
  );
}

class AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const AttachmentOption({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size.width * 0.15,
            height: size.width * 0.15,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28.sp),
          ),
          SizedBox(height: size.height * 0.01),
          InAppText(text: label, size: 14, color: AppColors.blue),
        ],
      ),
    );
  }
}

void showChatOptionsMenu(BuildContext context, Size size) {
  final readChatCubit = context.read<ChatCubit>();
  final conversation = readChatCubit.conversations.firstWhere(
    (conv) => conv.id == readChatCubit.selectedConversationId,
    orElse: () => readChatCubit.conversations.first,
  );
  final isMuted = conversation.isMuted ?? false;
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.02,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size.width * 0.2,
            height: size.height * 0.006,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          ListTile(
            leading: Icon(Icons.person, color: AppColors.blue, size: 28.sp),
            title: InAppText(text: 'View Profile', size: 20),
            onTap: context.read<AuthenticationCubit>().user.isMentee
                ? () {
                    final readHomeCubit = context.read<HomeCubit>();
                    final mentor = readHomeCubit.allUsers.firstWhere(
                      (user) => user.id == readChatCubit.selectedUserId,
                      orElse: () => UserModel(),
                    );
                    Navigator.pop(context);
                    context.read<MentorCubit>().loadMenteeMentor(
                      context.read<AuthenticationCubit>().user.id ?? "",
                    );
                    final move = Navigator.pushNamed(
                      context,
                      Routename.mentorDetails,
                    );
                    context.read<ProfileCubit>().setSelectedMentor(mentor);
                    Future.delayed(Duration(seconds: 5), () {
                      move;
                    });
                  }
                : () {
                    Navigator.pop(context);
                    context.read<MentorCubit>().loadMenteeDetails(
                      readChatCubit.selectedUserId,
                    );
                    Navigator.pushNamed(context, Routename.menteeDetails);
                  },
          ),
          ListTile(
            leading: Icon(
              Icons.notifications_off,
              color: AppColors.blue,
              size: 28.sp,
            ),
            title: InAppText(text: 'Mute Notifications', size: 20),
            onTap: () {
              Navigator.pop(context);
              readChatCubit.toggleMuteCurrentConversation(
                user: context.read<AuthenticationCubit>().user,
              );
              Fluttertoast.showToast(
                msg: isMuted ? "Notifications enabled" : "Notifications muted",
                backgroundColor: AppColors.blue,
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete,
              color: AppColors.errorColor,
              size: 28.sp,
            ),
            title: InAppText(
              text: 'Clear Chat',
              size: 20,
              color: AppColors.errorColor,
            ),
            onTap: () {
              Navigator.pop(context);
              _showClearChatConfirmation(context, readChatCubit);
            },
          ),
        ],
      ),
    ),
  );
}

void _showClearChatConfirmation(BuildContext context, ChatCubit chatCubit) {
  final size = MediaQuery.sizeOf(context);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.white,
      title: InAppText(
        text: 'Clear Chat',
        fontweight: FontWeight.bold,
        size: 20,
        color: AppColors.errorColor,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InAppText(
            textAlign: TextAlign.center,
            text:
                'Are you sure you want to delete all messages? This action cannot be undone.',
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: InAppText(text: 'Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  chatCubit.clearCurrentChat(
                    user: context.read<AuthenticationCubit>().user,
                  );
                  Fluttertoast.showToast(
                    msg: "Chat cleared",
                    backgroundColor: AppColors.blue,
                  );
                },
                child: InAppText(text: 'Clear', color: AppColors.errorColor),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
