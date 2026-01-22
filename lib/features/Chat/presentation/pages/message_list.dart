import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Chat/presentation/cubit/chat_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../widgets/message_list_widgets.dart';

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
        chatCubit.updateOnlineStatus(
          true,
          user: context.read<AuthenticationCubit>().user,
        );
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
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


