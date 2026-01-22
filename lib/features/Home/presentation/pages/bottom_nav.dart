import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Bookmark/pages/cubit/bookmark_cubit.dart';
import 'package:mistakes/features/Chat/presentation/cubit/chat_cubit.dart';
import 'package:mistakes/features/Dashboard/pages/cubit/dashboard_cubit.dart';
import 'package:mistakes/features/Goal/pages/cubit/goal_cubit.dart';
import 'package:mistakes/features/Home/data/local/home_static_repo.dart';
import 'package:mistakes/features/Home/presentation/cubit/home_cubit.dart';
import 'package:mistakes/features/Profile/presentation/cubit/mentor_cubit.dart';

import '../../../../constants/utils/app_colors.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final watchHome = context.watch<HomeCubit>();
    final readHome = context.read<HomeCubit>();
    final index = watchHome.bottonnavSelectedIndex;
    final size = MediaQuery.sizeOf(context);
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoadingState) {
          final chatCubit = context.read<ChatCubit>();
          chatCubit.loadConversations(user: watchAuthCubit.user);
          final dashboardCubit = context.read<DashboardCubit>();
          dashboardCubit.loadMentees(user: watchAuthCubit.user);
          final goalCubit = context.read<GoalCubit>();
          goalCubit.user = context.read<AuthenticationCubit>().user;
          goalCubit.loadGoals(context);
          context.read<ChatCubit>().loadConversations(
            user: context.read<AuthenticationCubit>().user,
          );
          final userId = context.read<AuthenticationCubit>().user.id;
          if (userId != null) {
            context.read<BookmarksCubit>().loadBookmarkedMentors(userId);
            context.read<MentorCubit>().loadMenteeMentor(userId);
            context.read<MentorCubit>().checkActiveMentor(userId);
            final goalCubit = context.read<GoalCubit>();

            if (goalCubit.allGoals.isEmpty) {
              goalCubit.user = context.read<AuthenticationCubit>().user;
              goalCubit.loadGoals(context);
            }
          }

          final mentorCubit = context.read<MentorCubit>();

          if (userId != null &&
              context.read<AuthenticationCubit>().user.isMentor) {
            mentorCubit.loadMentorDashboard(userId);
            context.read<ChatCubit>().loadConversations(
              user: context.read<HomeCubit>().user,
            );
          }
        }
        return Scaffold(
          body: watchHome.screens[index],
          extendBody: true,
          bottomNavigationBar:
              //  index == 3 || index == 2
              //     ? null
              //     :
              Theme(
                data: Theme.of(context).copyWith(
                  iconTheme: IconThemeData(
                    color: AppColors.background,
                    size: 25.sp,
                  ),
                ),
                child: Container(
                  // Add a subtle shadow above the navigation bar.
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    // borderRadius: const BorderRadius.only(
                    //   topLeft: Radius.circular(24.0),
                    //   topRight: Radius.circular(24.0),
                    // ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.lightgrey.withAlpha(100),
                        blurRadius: 8.0,
                        spreadRadius: 1.0,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: CurvedNavigationBar(
                      items: watchAuthCubit.role == "Mentor"
                          ? HomeStaticRepo.mentorBottomNavItems
                                .map((item) => Icon(item.icon))
                                .toList()
                          : HomeStaticRepo.bottomNavItems
                                .map((item) => Icon(item.icon))
                                .toList(),
                      height: size.height * 0.075,
                      backgroundColor: AppColors.background,
                      color: AppColors.white,
                      index: index,
                      onTap: (index) {
                        readHome.changebottomnavindex(index: index);
                      },
                    ),
                  ),
                ),
              ),
        );
      },
    );
  }
}
