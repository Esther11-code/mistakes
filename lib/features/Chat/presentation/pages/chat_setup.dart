import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Chat/presentation/pages/mentee/chat.dart';
import 'package:mistakes/features/Chat/presentation/pages/mentor/mentor_chat.dart';

class ChatSetup extends StatelessWidget {
  const ChatSetup({super.key});

  @override
  Widget build(BuildContext context) {
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    return watchAuthCubit.user.role == "Mentor"
        ? const MentorChatPage()
        : MenteeChatPage(userName: "Stacy");
  }
}
