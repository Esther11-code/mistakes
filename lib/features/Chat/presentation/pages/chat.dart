import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

                ChatMessageInput(size: size),
              ],
            ),
          );
        },
      ),
    );
  }
}
