import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Bookmark/pages/bookmark.dart';
import 'package:mistakes/features/Home/presentation/pages/requests/mentor/mentorship_request.dart';

class BookmarkSetup extends StatelessWidget {
  const BookmarkSetup({super.key});

  @override
  Widget build(BuildContext context) {
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    return watchAuthCubit.user.role == "Mentor"
        ? const MentorshipRequest()
        : const Bookmark();
  }
}
