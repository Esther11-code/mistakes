import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../Home/data/local/images/home_image.dart';

class MenteeChatPage extends StatefulWidget {
  final String userName;
  final String? userAvatar;
  final bool isOnline;

  const MenteeChatPage({
    super.key,
    required this.userName,
    this.userAvatar = HomeImages.avatar,
    this.isOnline = false,
  });

  @override
  State<MenteeChatPage> createState() => _MenteeChatPageState();
}

class _MenteeChatPageState extends State<MenteeChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  List<ChatMessage> messages = [
    ChatMessage(
      message: "Hey! How are you doing?",
      isSent: false,
      time: "10:30 AM",
      isRead: true,
    ),
    ChatMessage(
      message: "I'm doing great! Just finished that project we talked about",
      isSent: true,
      time: "10:32 AM",
      isRead: true,
    ),
    ChatMessage(
      message: "That's awesome! How did it turn out?",
      isSent: false,
      time: "10:33 AM",
      isRead: true,
    ),
    ChatMessage(
      message: "Really well! The client loved it 😊",
      isSent: true,
      time: "10:35 AM",
      isRead: true,
    ),
    ChatMessage(
      message: "I'm so happy to hear that! You worked really hard on it",
      isSent: false,
      time: "10:36 AM",
      isRead: true,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add(
          ChatMessage(
            message: _messageController.text.trim(),
            isSent: true,
            time: _formatTime(DateTime.now()),
            isRead: false,
          ),
        );
      });
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final showAvatar =
                    index == messages.length - 1 ||
                    messages[index + 1].isSent != message.isSent;
                // final showTime =
                //     index == 0 || index % 5 == 0; // Show time every 5 messages

                return Column(
                  children: [
                    // if (showTime && index == 0) _buildTimeStamp("Today"),
                    _buildMessageBubble(message, showAvatar),
                  ],
                );
              },
            ),
          ),
          // Message Input Area
          _buildMessageInput(),
        ],
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: AppColors.blue, size: 20),
        onPressed: () =>
            Navigator.popAndPushNamed(context, Routename.bottomNav),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.filledColor,
                backgroundImage: widget.userAvatar!.isNotEmpty
                    ? NetworkImage(widget.userAvatar!)
                    : null,
                child: widget.userAvatar!.isEmpty
                    ? Icon(Icons.person, color: AppColors.white, size: 24)
                    : null,
              ),
              if (widget.isOnline)
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
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: widget.userName,
                  size: 16,
                  fontweight: FontWeight.w600,
                  color: AppColors.blue,
                ),
                AppText(
                  text: widget.isOnline ? 'Online' : 'Offline',
                  size: 12,
                  color: widget.isOnline
                      ? Colors.green
                      : AppColors.white.withAlpha(80),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.call, color: AppColors.blue),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.more_vert, color: AppColors.blue),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildTimeStamp(String time) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(
        text: time,
        size: 12,
        color: AppColors.white.withAlpha(80),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool showAvatar) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: message.isSent
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isSent && showAvatar)
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.filledColor,
              child: Icon(Icons.person, color: AppColors.white, size: 18),
            ),
          if (!message.isSent && showAvatar) SizedBox(width: 8.w),
          if (!message.isSent && !showAvatar) SizedBox(width: 40.w),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                gradient: message.isSent
                    ? LinearGradient(
                        colors: [AppColors.blue, AppColors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: message.isSent ? null : AppColors.filledColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(message.isSent ? 20 : 4),
                  bottomRight: Radius.circular(message.isSent ? 4 : 20),
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
                  AppText(
                    text: message.message,
                    size: 15,
                    color: AppColors.white,
                    height: 1.4,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        text: message.time,
                        size: 11,
                        color: AppColors.white.withAlpha(80),
                      ),
                      if (message.isSent) ...[
                        SizedBox(width: 4.w),
                        Icon(
                          message.isRead
                              ? Icons.done_all_rounded
                              : Icons.done_rounded,
                          size: 16,
                          color: message.isRead
                              ? Colors.lightBlueAccent
                              : AppColors.white.withAlpha(80),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (message.isSent && showAvatar) SizedBox(width: 8.w),
          if (message.isSent && showAvatar)
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.blue,
              child: Icon(Icons.person, color: AppColors.white, size: 18),
            ),
          if (message.isSent && !showAvatar) SizedBox(width: 40.w),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
            // Emoji/Attachment Button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.add, color: AppColors.white, size: 24),
                onPressed: () {
                  _showAttachmentOptions();
                },
                padding: EdgeInsets.zero,
              ),
            ),
            SizedBox(width: 12.w),
            // Text Input Field
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: AppColors.white.withAlpha(80),
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        style: TextStyle(color: AppColors.blue, fontSize: 15),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: AppColors.white.withAlpha(80),
                      ),
                      onPressed: () {
                        // Add emoji picker
                      },
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Send Button
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 44,
                height: 44,
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
                child: Icon(
                  Icons.send_rounded,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
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
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  Icons.image,
                  'Gallery',
                  Colors.purple,
                  () {},
                ),
                _buildAttachmentOption(
                  Icons.camera_alt,
                  'Camera',
                  Colors.pink,
                  () {},
                ),
                _buildAttachmentOption(
                  Icons.insert_drive_file,
                  'Document',
                  Colors.blue,
                  () {},
                ),
                _buildAttachmentOption(
                  Icons.location_on,
                  'Location',
                  Colors.green,
                  () {},
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withAlpha(10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          SizedBox(height: 8.h),
          AppText(text: label, size: 12, color: AppColors.blue),
        ],
      ),
    );
  }
}

// Message Model
class ChatMessage {
  final String message;
  final bool isSent;
  final String time;
  final bool isRead;

  ChatMessage({
    required this.message,
    required this.isSent,
    required this.time,
    this.isRead = false,
  });
}

// Usage:
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (_) => ModernChatScreen(
//       userName: 'John Doe',
//       isOnline: true,
//     ),
//   ),
// );
