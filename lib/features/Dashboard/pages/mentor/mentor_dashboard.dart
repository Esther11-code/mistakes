// lib/features/Dashboard/pages/mentor_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Dashboard/data/model/mentee_model.dart';
import 'package:mistakes/features/Dashboard/pages/cubit/dashboard_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

class MentorDashboard extends StatefulWidget {
  const MentorDashboard({super.key});

  @override
  State<MentorDashboard> createState() => _MentorDashboardState();
}

class _MentorDashboardState extends State<MentorDashboard> {
  @override
  void initState() {
    super.initState();
    // Load mentees when page opens
    _loadMentees();
  }

  Future<void> _loadMentees() async {
    final cubit = context.read<DashboardCubit>();
    await cubit.loadMentees(user: context.read<AuthenticationCubit>().user);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final readDashboardCubit = context.read<DashboardCubit>();
    final watchDashboardCubit = context.watch<DashboardCubit>();

    return BlocListener<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is DashboardErrorState) {
          Fluttertoast.showToast(
            msg: state.error,
            gravity: ToastGravity.TOP,
            backgroundColor: AppColors.errorColor,
          );
        }
      },
      child: AppScaffold(
        body: Column(
          children: [
            AppbarWidget(title: 'My Mentees', size: size),
            SizedBox(height: size.height * 0.02),

            Expanded(
              child: BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  // ⭐ Loading state (only show spinner if no data)
                  if (state is DashboardLoadingState &&
                      watchDashboardCubit.allMentees.isEmpty) {
                    return Center(
                      child: LoadingAnimationWidget.inkDrop(
                        color: AppColors.background,
                        size: 50.sp,
                      ),
                    );
                  }

                  // ⭐ Add pull-to-refresh
                  return RefreshIndicator(
                    onRefresh: _loadMentees,
                    child: SingleChildScrollView(
                      physics:
                          AlwaysScrollableScrollPhysics(), // ⭐ Enable pull-to-refresh even when content is short
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status Filter Tabs
                            StatusFilterTabs(size: size),

                            SizedBox(height: size.height * 0.03),

                            // Empty State
                            if (watchDashboardCubit.filteredMentees.isEmpty)
                              EmptyMenteesState(
                                size: size,
                                statusText:
                                    watchDashboardCubit
                                        .status[watchDashboardCubit
                                        .selectedStatusIndex],
                              ),

                            // Mentees List
                            ...List.generate(
                              watchDashboardCubit.filteredMentees.length,
                              (index) {
                                final mentee =
                                    watchDashboardCubit.filteredMentees[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: size.height * 0.02,
                                  ),
                                  child: MenteeCard(
                                    mentee: mentee,
                                    size: size,
                                    onTap: () {
                                      readDashboardCubit.setSelectedMenteeIndex(
                                        index,
                                      );
                                      readDashboardCubit.setSelectedMentee(
                                        mentee,
                                      );
                                      Navigator.pushNamed(
                                        context,
                                        Routename.menteeDashboard,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
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

class StatusFilterTabs extends StatelessWidget {
  final Size size;

  const StatusFilterTabs({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final readDashboardCubit = context.read<DashboardCubit>();
    final watchDashboardCubit = context.watch<DashboardCubit>();

    return AppshadowContainer(
      border: true,
      borderColor: AppColors.filledColor,
      color: Colors.transparent,
      width: size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          watchDashboardCubit.status.length,
          (int index) => AppshadowContainer(
            color: watchDashboardCubit.selectedStatusIndex == index
                ? AppColors.filledColor
                : Colors.transparent,
            onTap: () => readDashboardCubit.changeStatus(index),
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.015,
              horizontal: size.width * 0.04,
            ),
            child: InAppText(
              text: watchDashboardCubit.status[index],
              color: watchDashboardCubit.selectedStatusIndex == index
                  ? AppColors.white
                  : AppColors.grey,
              fontweight: FontWeight.w500,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyMenteesState extends StatelessWidget {
  final Size size;
  final String statusText;

  const EmptyMenteesState({
    super.key,
    required this.size,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.1),
        child: Column(
          children: [
            Icon(
              Icons.people_outline,
              size: 80.sp,
              color: AppColors.blue.withAlpha(40), // ⭐ Slightly more visible
            ),
            SizedBox(height: size.height * 0.02),
            InAppText(
              text: 'No mentees in "$statusText"',
              size: 20,
              fontweight: FontWeight.w600,
              color: AppColors.lightblack,
            ),
            SizedBox(height: size.height * 0.01),
            InAppText(
              text: statusText == 'All'
                  ? 'You don\'t have any mentees yet'
                  : 'Try selecting a different filter',
              size: 16,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class MenteeCard extends StatelessWidget {
  final MenteeModel mentee;
  final Size size;
  final VoidCallback onTap;

  const MenteeCard({
    super.key,
    required this.mentee,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      onTap: onTap,
      padding: EdgeInsets.all(size.width * 0.04),
      shadowcolour: AppColors.lightgrey.withAlpha(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: size.height * 0.04,
                backgroundColor: AppColors.filledColor,
                backgroundImage: mentee.avatarUrl != null
                    ? NetworkImage(mentee.avatarUrl!)
                    : null,
                child: mentee.avatarUrl == null
                    ? Icon(Icons.person, color: AppColors.white, size: 20.sp)
                    : null,
              ),
              SizedBox(width: size.width * 0.03),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InAppText(
                      text: mentee.name,
                      fontweight: FontWeight.w800,
                      size: 18,
                    ),
                    SizedBox(height: size.height * 0.006),

                    Row(
                      children: [
                        // Status Badge
                        AppshadowContainer(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.03,
                          ),
                          borderRadius: BorderRadius.circular(
                            size.width * 0.07,
                          ),
                          border: true,
                          borderColor: AppColors.filledColor,
                          color: AppColors.inactive,
                          child: InAppText(
                            text: mentee.status == 'active'
                                ? 'Active'
                                : 'Inactive',
                            color: AppColors.background,
                            fontweight: FontWeight.w500,
                            size: 14,
                          ),
                        ),

                        // Unread Messages Badge
                        if (mentee.unreadMessages > 0) ...[
                          SizedBox(width: size.width * 0.02),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02,
                              vertical: size.height * 0.003,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.errorColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: InAppText(
                              text: '${mentee.unreadMessages} new',
                              color: AppColors.white,
                              fontweight: FontWeight.bold,
                              size: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: size.height * 0.02),

          // Progress Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InAppText(text: "Overall Progress"),
                  InAppText(
                    text: "${mentee.overallProgress}%",
                    fontweight: FontWeight.w800,
                    color: AppColors.filledColor,
                    size: 20,
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.012),

              // Progress Bar
              AppshadowContainer(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                height: size.height * 0.025,
                width: size.width,
                borderRadius: BorderRadius.circular(size.height * 0.02),
                color: AppColors.grey.withAlpha(16),
                child: FractionallySizedBox(
                  widthFactor: mentee.overallProgress / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.filledColor,
                      borderRadius: BorderRadius.circular(size.height * 0.02),
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.012),

              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      InAppText(
                        text: "${mentee.goalsCompleted}/${mentee.totalGoals}",
                        fontweight: FontWeight.w700,
                      ),
                      InAppText(text: "Goals", color: AppColors.grey),
                    ],
                  ),
                  Column(
                    children: [
                      InAppText(
                        text: _getLastActiveText(mentee.lastActive),
                        fontweight: FontWeight.w700,
                      ),
                      InAppText(text: "Last Active", color: AppColors.grey),
                    ],
                  ),
                  Column(
                    children: [
                      InAppText(
                        text: mentee.unreadMessages.toString(),
                        fontweight: FontWeight.w700,
                      ),
                      InAppText(text: "Messages", color: AppColors.grey),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getLastActiveText(DateTime lastActive) {
    final difference = DateTime.now().difference(lastActive);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}
