import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart' hide Config;

import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/data/model/user_model.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Chat/presentation/cubit/chat_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../widgets/chat_page_widgets.dart';

class MenteChatPage extends StatefulWidget {
  const MenteChatPage({super.key});

  @override
  State<MenteChatPage> createState() => _MenteChatPageState();
}

class _MenteChatPageState extends State<MenteChatPage>
    with WidgetsBindingObserver {
  late final ChatCubit _chatCubit;
  late final UserModel _user;

  bool showEmojiPicker = false;

  @override
  void initState() {
    super.initState();
    _chatCubit = context.read<ChatCubit>();
    _user = context.read<AuthenticationCubit>().user;

    WidgetsBinding.instance.addObserver(this);
    _chatCubit.loadConversations(user: _user);
    _chatCubit.updateOnlineStatus(true, user: _user);
    _chatCubit.loadMessages(user: _user);
  }

  @override
  void dispose() {
    _chatCubit.updateOnlineStatus(false, user: _user);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _chatCubit.updateOnlineStatus(true, user: _user);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        _chatCubit.updateOnlineStatus(false, user: _user);
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchChatCubit = context.watch<ChatCubit>();
    final readChatCubit = context.read<ChatCubit>();

    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatErrorState) {
          Fluttertoast.showToast(
            msg: state.error,
            gravity: ToastGravity.TOP,
            backgroundColor: AppColors.errorColor,
          );
        }
      },
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          return AppScaffold(
            isloading:
                state is ChatLoadingState &&
                watchChatCubit.currentChatMessages.isEmpty,
            body: Column(
              children: [
                ChatAppBar(
                  userName: watchChatCubit.selectedUserName,
                  userAvatar: watchChatCubit.selectedUserAvatar,
                  isOnline: watchChatCubit.selectedUserIsOnline,
                  userRole: watchChatCubit.selectedUserRole,
                  size: size,
                ),

                Expanded(
                  child: watchChatCubit.currentChatMessages.isEmpty
                      ? ChatEmptyState(size: size)
                      : MessagesList(
                          size: size,
                          messages: watchChatCubit.currentChatMessages,
                          scrollController: watchChatCubit.scrollController,
                          currentUserId:
                              context.watch<AuthenticationCubit>().user.id ??
                              "",
                        ),
                ),

                Container(
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
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                            ),
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
                                    onTap: () {
                                      setState(() {
                                        showEmojiPicker = false;
                                      });
                                    },
                                    controller:
                                        watchChatCubit.messageController,
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
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.emoji_emotions_outlined,
                                    color: AppColors.filledColor,
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      showEmojiPicker = !showEmojiPicker;
                                    });
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
                ),
                if (showEmojiPicker) buildEmojiPicker(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildEmojiPicker() {
    final readChatCubit = context.read<ChatCubit>();
    final messageController = readChatCubit.messageController;
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          messageController.text += emoji.emoji;
          messageController.selection = TextSelection.fromPosition(
            TextPosition(offset: messageController.text.length),
          );
        },
        config: Config(
          height: 256,
          checkPlatformCompatibility: true,
          emojiViewConfig: EmojiViewConfig(
            // Issue: https://github.com/flutter/flutter/issues/28894
            emojiSizeMax:
                28 *
                (foundation.defaultTargetPlatform == TargetPlatform.iOS
                    ? 1.20
                    : 1.0),
          ),
          viewOrderConfig: const ViewOrderConfig(
            top: EmojiPickerItem.categoryBar,
            middle: EmojiPickerItem.emojiView,
            bottom: EmojiPickerItem.searchBar,
          ),
          skinToneConfig: const SkinToneConfig(),
          categoryViewConfig: const CategoryViewConfig(),
          bottomActionBarConfig: const BottomActionBarConfig(),
          searchViewConfig: const SearchViewConfig(),
        ),
      ),
    );
  }
}
