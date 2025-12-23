import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Home/presentation/pages/mentee/mentee_home.dart';
import 'package:mistakes/features/Home/presentation/pages/mentor/mentor_home.dart';

class HomeSetup extends StatelessWidget {
  const HomeSetup({super.key});

  @override
  Widget build(BuildContext context) {
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    return watchAuthCubit.user.role == "Mentor" ? MentorHome() : MenteeHome();
  }
}
