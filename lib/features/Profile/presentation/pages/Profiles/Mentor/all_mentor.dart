import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mistakes/features/Home/presentation/cubit/home_cubit.dart';
import 'package:mistakes/features/Home/presentation/pages/home.dart';
import 'package:mistakes/global%20widgets/export.dart';

class AllMentor extends StatelessWidget {
  const AllMentor({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchHomeCubit = context.watch<HomeCubit>();
    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(title: 'All Mentors', size: size),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  watchHomeCubit.getMentors().length,
                  (index) => MentorList(
                    size: size,
                    mentorId: watchHomeCubit.getMentors()[index].id ?? " ",
                    mentorName:
                        watchHomeCubit.getMentors()[index].name ??
                        '',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
