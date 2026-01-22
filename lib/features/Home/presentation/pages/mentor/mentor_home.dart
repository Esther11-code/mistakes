import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Chat/presentation/cubit/chat_cubit.dart';
import 'package:mistakes/features/Home/presentation/cubit/home_cubit.dart';

import 'package:mistakes/features/Home/presentation/widgets/src/home_appbar.dart';
import 'package:mistakes/features/Profile/presentation/cubit/mentor_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';
import '../../../../../constants/utils/app_colors.dart';
import '../../../../Dashboard/data/local/dashboard_static_repo.dart';

class MentorHome extends StatefulWidget {
  const MentorHome({super.key});

  @override
  State<MentorHome> createState() => _MentorHomeState();
}

class _MentorHomeState extends State<MentorHome> {
  @override
  void initState() {
    super.initState();
    final mentorCubit = context.read<MentorCubit>();
    final userId = context.read<HomeCubit>().user.id;

    if (userId != null) {
      mentorCubit.loadMentorDashboard(userId);
      context.read<ChatCubit>().loadConversations(
        user: context.read<HomeCubit>().user,
      );
    }

    
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<MentorCubit, MentorState>(
      builder: (context, state) {
        final readMentorCubit = context.read<MentorCubit>();
        final watchMentorCubit = context.watch<MentorCubit>();

        if (state is MentorLoadingState && watchMentorCubit.stats.isEmpty) {
          return Center(
            child: LoadingAnimationWidget.inkDrop(
              color: AppColors.background,
              size: 50.sp,
            ),
          );
        }
        return AppScaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeAppbar(size: size),
              SizedBox(height: size.height * 0.025),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final userId = context.read<AuthenticationCubit>().user.id;
                    final readAuthCubit = context.read<AuthenticationCubit>();
                    final readChatCubit = context.read<ChatCubit>();
                    if (userId != null) {
                      await readMentorCubit.loadMentorDashboard(userId);
                      readChatCubit.loadConversations(user: readAuthCubit.user);
                    }
                  },

                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: size.width * 0.04,
                                mainAxisSpacing: size.height * 0.02,
                                childAspectRatio: 1,
                              ),
                          itemCount: buildStatsList(
                            watchMentorCubit.stats,
                          ).length,
                          itemBuilder: (context, index) {
                            return StatCard(
                              stat: buildStatsList(
                                watchMentorCubit.stats,
                              )[index],
                              size: size,
                            );
                          },
                        ),
                        Visibility(
                          visible: watchMentorCubit.recentActivities.isNotEmpty,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InAppText(
                                text: "Recent Activities",
                                size: 21,
                                fontweight: FontWeight.w700,
                              ),
                              SizedBox(height: size.height * 0.02),
                              Column(
                                children: List.generate(
                                  watchMentorCubit.recentActivities.length,
                                  (index) => ActivityCard(
                                    size: size,
                                    index: index,
                                    activityTitle: watchMentorCubit
                                        .recentActivities[index]['title'],
                                    activityDescription: watchMentorCubit
                                        .recentActivities[index]['description'],
                                    dateSet: watchMentorCubit
                                        .recentActivities[index]['date'],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: watchMentorCubit.thisWeeksTasks.isNotEmpty,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InAppText(
                                text: "This Week's Tasks",
                                size: 21,
                                fontweight: FontWeight.w700,
                              ),
                              SizedBox(height: size.height * 0.015),

                              // Multiple tasks with better styling
                              Column(
                                children: List.generate(
                                  watchMentorCubit.thisWeeksTasks.length,
                                  (index) => buildTaskCard(
                                    watchMentorCubit.thisWeeksTasks[index],
                                    size,
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.02),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.4),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildTaskCard(Map<String, dynamic> task, Size size) {
    final deadline = task['deadline'] as DateTime;
    final priority = task['priority'] as String;
    final isCompleted = task['is_completed'] as bool;
    final taskType = task['type'] as String;

    Color priorityColor;
    Color priorityBg;
    switch (priority) {
      case 'high':
        priorityColor = Colors.red.shade700;
        priorityBg = Colors.red.shade50;
        break;
      case 'medium':
        priorityColor = Colors.orange.shade700;
        priorityBg = Colors.orange.shade50;
        break;
      default:
        priorityColor = Colors.green.shade700;
        priorityBg = Colors.green.shade50;
    }

    // ⭐ Different icons for different task types
    IconData taskIcon;
    String taskPrefix = '';

    switch (taskType) {
      case 'pending_request':
        taskIcon = Icons.person_add;
        taskPrefix = '👋 ';
        break;
      case 'comment_needed':
        taskIcon = Icons.comment;
        taskPrefix = '💬 ';
        break;
      case 'goal_deadline':
        taskIcon = Icons.flag;
        taskPrefix = '🎯 ';
        break;
      default:
        taskIcon = Icons.task;
    }

    return AppshadowContainer(
      margin: EdgeInsets.only(bottom: size.height * 0.015),
      padding: EdgeInsets.all(size.width * 0.04),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ⭐ Icon instead of checkbox for non-goal tasks
          taskType == 'goal_deadline'
              ? AppCheckbox(status: isCompleted)
              : Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: priorityBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(taskIcon, size: 20.sp, color: priorityColor),
                ),

          SizedBox(width: size.width * 0.03),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InAppText(
                        text: '$taskPrefix${task['title']}',
                        fontweight: FontWeight.w600,
                        size: 18,
                        color: isCompleted
                            ? AppColors.grey
                            : AppColors.lightblack,
                      ),
                    ),
                    // Priority badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.025,
                        vertical: size.height * 0.005,
                      ),
                      decoration: BoxDecoration(
                        color: priorityBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: priorityColor.withAlpha(30),
                          width: 1,
                        ),
                      ),
                      child: InAppText(
                        text: priority.toUpperCase(),
                        size: 12,
                        fontweight: FontWeight.w600,
                        color: priorityColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.008),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16.sp,
                      color: AppColors.grey,
                    ),
                    SizedBox(width: size.width * 0.015),
                    InAppText(
                      text: task['mentee_name'],
                      color: AppColors.grey,
                      size: 14,
                    ),
                    SizedBox(width: size.width * 0.03),
                    Icon(
                      Icons.calendar_today,
                      size: 16.sp,
                      color: AppColors.grey,
                    ),
                    SizedBox(width: size.width * 0.015),
                    InAppText(
                      text: taskType == 'pending_request'
                          ? 'Waiting ${task['days_waiting']} days'
                          : 'Due: ${DateFormat('MMM dd').format(deadline)}',
                      color: AppColors.grey,
                      size: 14,
                    ),
                  ],
                ),

                // ⭐ Show progress bar for comment_needed tasks
                if (taskType == 'comment_needed') ...[
                  SizedBox(height: size.height * 0.008),
                  LinearProgressIndicator(
                    value: (task['progress_percentage'] ?? 0) / 100,
                    backgroundColor: AppColors.inactive,
                    valueColor: AlwaysStoppedAnimation<Color>(priorityColor),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.size,
    required this.index,
    this.activityTitle,
    this.activityDescription,
    this.dateSet,
  });

  final Size size;
  final int index;
  final String? activityTitle, activityDescription, dateSet;

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      color: AppColors
          .darkRainbowColors[index % AppColors.darkRainbowColors.length],
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      child: AppshadowContainer(
        padding: EdgeInsets.all(size.width * 0.03),
        color: AppColors
            .lightRainbowColors[index % AppColors.lightRainbowColors.length],
        margin: EdgeInsets.only(left: size.width * 0.025),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Add icon on the left
            Container(
              padding: EdgeInsets.all(size.width * 0.03),
              decoration: BoxDecoration(
                color: AppColors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.emoji_events, // Trophy for goal
                color: AppColors.white,
                size: 28,
              ),
            ),
            SizedBox(width: size.width * 0.02),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InAppText(
                        text: activityTitle ?? "Goal Set",
                        fontweight: FontWeight.w700,
                        size: 20,
                        color: AppColors.white,
                      ),
                      // Add a badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.02,
                          vertical: size.height * 0.005,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withAlpha(90),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InAppText(
                          text: dateSet ?? "Today",
                          color: AppColors.white,
                          size: 14,
                          fontweight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.008),
                  InAppText(
                    text:
                        activityDescription ??
                        "Set SMART goals: Specific, Measurable, Achievable, Relevant, Time-bound",
                    color: AppColors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<MentorStat> buildStatsList(Map<String, int> stats) {
  return [
    MentorStat(
      count: stats['activeMentees'] ?? 0,
      label: 'Active Mentees',
      icon: Icons.people,
      color: Colors.blue,
    ),
    MentorStat(
      count: stats['pendingRequests'] ?? 0,
      label: 'Pending Requests',
      icon: Icons.pending_actions,
      color: Colors.orange,
    ),
    MentorStat(
      count: stats['completedMentorships'] ?? 0,
      label: 'Completed',
      icon: Icons.check_circle,
      color: Colors.green,
    ),
    MentorStat(
      count: stats['totalHours'] ?? 0,
      label: 'Total Hours',
      icon: Icons.schedule,
      color: Colors.purple,
    ),
  ];
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.stat, required this.size});

  final MentorStat stat;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [stat.color, stat.color.withAlpha(70)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: stat.color.withAlpha(40),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(size.width * 0.025),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(stat.icon, color: Colors.white, size: 28),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InAppText(
                  text: '${stat.count}',
                  size: 32,
                  fontweight: FontWeight.bold,
                  color: Colors.white,
                  height: 1,
                ),
                SizedBox(height: size.height * 0.005),
                InAppText(
                  text: stat.label,
                  size: 14,
                  fontweight: FontWeight.w500,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
