import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Bookmark/cubit/bookmark_cubit.dart';
import 'package:mistakes/features/Home/presentation/cubit/home_cubit.dart';
import 'package:mistakes/features/Home/presentation/pages/home.dart';
import 'package:mistakes/global%20widgets/export.dart';

class AllMentor extends StatefulWidget {
  const AllMentor({super.key});

  @override
  State<AllMentor> createState() => _AllMentorState();
}

class _AllMentorState extends State<AllMentor> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadMentors();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchHomeCubit = context.watch<HomeCubit>();

    return AppScaffold(
      isloading: watchHomeCubit.state is UserSearchLoadingState,
      body: Column(
        children: [
          AppbarWidget(title: 'All Mentors', size: size),
          SizedBox(height: size.height * 0.02),

          Expanded(
            child: watchHomeCubit.filteredUsers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.no_accounts,
                          size: 60.sp,
                          color: AppColors.inactive,
                        ),
                        SizedBox(height: 16),
                        Text('No mentors available'),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: watchHomeCubit.filteredUsers.map((mentor) {
                        return MentorList(
                          onBookmarkTap: () {
                            final userId = context
                                .read<AuthenticationCubit>()
                                .user
                                .id;
                            if (userId != null) {
                              context
                                  .read<BookmarksCubit>()
                                  .toggleMentorBookmark(
                                    menteeId: userId,
                                    mentorId: mentor.id ?? "0",
                                  );
                            }
                          },
                          size: size,
                          mentorId: mentor.id ?? "0",
                          mentorName: mentor.name ?? "Unknown",
                          expertise: mentor.expertise ?? "Expertise", // ⭐ Added
                          yoe: (mentor.yearsExperience ?? 0)
                              .toString(), // ⭐ Added
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
