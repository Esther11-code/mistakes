import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    // Load mentor data when page loads
    final mentorCubit = context.read<MentorCubit>();
    final userId = context.read<HomeCubit>().user.id;

    if (userId != null) {
      mentorCubit.loadMentorDashboard(userId);
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
          return Center(child: CircularProgressIndicator());
        }
        return AppScaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeAppbar(size: size),
              SizedBox(height: size.height * 0.025),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final userId = context.read<HomeCubit>().user.id;
                      if (userId != null) {
                        await readMentorCubit.loadMentorDashboard(userId);
                      }
                    },
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
                            children: [
                              InAppText(
                                text: "This Week's Tasks",
                                size: 21,
                                fontweight: FontWeight.w700,
                              ),
                              SizedBox(height: size.height * 0.02),

                              // Multiple tasks with better styling
                              Column(
                                children: List.generate(
                                  watchMentorCubit.thisWeeksTasks.length,
                                  (index) => AppshadowContainer(
                                    margin: EdgeInsets.only(
                                      bottom: size.height * 0.015,
                                    ),
                                    padding: EdgeInsets.all(size.width * 0.04),
                                    color: Colors.white,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppCheckbox(
                                          status: index == 0,
                                        ), // First one checked
                                        SizedBox(width: size.width * 0.03),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: InAppText(
                                                      text: index == 0
                                                          ? "Goal Review"
                                                          : index == 1
                                                          ? "Mentee Check-in"
                                                          : "Progress Report",
                                                      fontweight:
                                                          FontWeight.w600,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  // Priority badge
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal:
                                                              size.width *
                                                              0.025,
                                                          vertical:
                                                              size.height *
                                                              0.005,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: index == 0
                                                          ? Colors.red.shade50
                                                          : index == 1
                                                          ? Colors
                                                                .orange
                                                                .shade50
                                                          : Colors
                                                                .green
                                                                .shade50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      border: Border.all(
                                                        color: index == 0
                                                            ? Colors
                                                                  .red
                                                                  .shade300
                                                            : index == 1
                                                            ? Colors
                                                                  .orange
                                                                  .shade300
                                                            : Colors
                                                                  .green
                                                                  .shade300,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: InAppText(
                                                      text: index == 0
                                                          ? "High"
                                                          : index == 1
                                                          ? "Medium"
                                                          : "Low",
                                                      size: 16,
                                                      fontweight:
                                                          FontWeight.w600,
                                                      color: index == 0
                                                          ? Colors.red.shade700
                                                          : index == 1
                                                          ? Colors
                                                                .orange
                                                                .shade700
                                                          : Colors
                                                                .green
                                                                .shade700,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.calendar_today,
                                                    size: 15.sp,
                                                    color: AppColors.grey,
                                                  ),
                                                  SizedBox(
                                                    width: size.width * 0.015,
                                                  ),
                                                  InAppText(
                                                    text:
                                                        "Due: ${index == 0
                                                            ? 'Friday, 25th Aug'
                                                            : index == 1
                                                            ? 'Saturday, 26th Aug'
                                                            : 'Sunday, 27th Aug'}",
                                                    color: AppColors.grey,
                                                    size: 16,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
        padding: EdgeInsets.all(size.width * 0.04),
        color: AppColors
            .lightRainbowColors[index % AppColors.lightRainbowColors.length],
        margin: EdgeInsets.only(left: size.width * 0.025),
        child: Row(
          children: [
            // Add icon on the left
            Container(
              padding: EdgeInsets.all(size.width * 0.03),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.emoji_events, // Trophy for goal
                color: Colors.white,
                size: 28,
              ),
            ),
            SizedBox(width: size.width * 0.04),
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
                        color: Colors.white,
                      ),
                      // Add a badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                          vertical: size.height * 0.005,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(90),
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
