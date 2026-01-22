import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Dashboard/pages/cubit/dashboard_cubit.dart';
import 'package:mistakes/features/Goal/pages/cubit/goal_cubit.dart';
import 'package:mistakes/features/Profile/presentation/cubit/mentor_cubit.dart';
import 'package:mistakes/global%20widgets/widgets/app_container_withshadow.dart';
import 'package:mistakes/global%20widgets/widgets/app_scaffold.dart';
import 'package:mistakes/global%20widgets/widgets/app_text.dart';
import 'package:mistakes/global%20widgets/widgets/appbar.dart';

import '../widgets/mentee_dashboard_widgets.dart';

class MenteeDashboard extends StatelessWidget {
  const MenteeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isRole = context.watch<AuthenticationCubit>().user.role;
    final watchGoalCubit = context.watch<GoalCubit>();
    final watchDashboardCubit = context.watch<DashboardCubit>();
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    final watchMentorCubit = context.watch<MentorCubit>();
    final user = watchAuthCubit.user;

    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(
            title: 'Dashboard',
            size: size,
            onTap: () {
              watchAuthCubit.user.isMentee ? null : Navigator.pop(context);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.025),
                  Container(
                    width: size.width,
                    padding: EdgeInsets.all(size.width * 0.05),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.background, AppColors.filledColor],
                      ),
                      borderRadius: BorderRadius.circular(size.width * 0.04),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey.withAlpha(50),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            watchMentorCubit.currentMentorAvatar != null ||
                                    watchDashboardCubit
                                            .selectedMentee
                                            ?.avatarUrl !=
                                        null
                                ? CircleAvatar(
                                    radius: size.height * 0.04,
                                    backgroundImage: NetworkImage(
                                      watchAuthCubit.user.isMentee
                                          ? "${watchMentorCubit.currentMentorAvatar}"
                                          : "${watchDashboardCubit.selectedMentee?.avatarUrl}",
                                    ),
                                  )
                                : Container(
                                    width: size.height * 0.08,
                                    height: size.height * 0.08,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.white,
                                        width: 3,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: AppColors.white,
                                      child: Icon(
                                        Icons.person,
                                        color: AppColors.blue,
                                        size: 30.sp,
                                      ),
                                    ),
                                  ),
                            SizedBox(width: size.width * 0.04),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InAppText(
                                    text: watchAuthCubit.user.isMentee
                                        ? "${watchMentorCubit.currentMentorName}"
                                        : "${watchDashboardCubit.selectedMentee?.name}",

                                    fontweight: FontWeight.w800,
                                    size: 20,
                                    color: AppColors.white,
                                  ),
                                  SizedBox(height: size.height * 0.005),
                                  InAppText(
                                    text: watchAuthCubit.user.isMentee
                                        ? "${watchMentorCubit.currentMentorExpertise}"
                                        : "${watchDashboardCubit.selectedMentee?.expertise}",
                                    fontweight: FontWeight.w500,
                                    size: 15,
                                    color: AppColors.white,
                                  ),
                                  SizedBox(height: size.height * 0.005),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.03,
                                      vertical: size.height * 0.006,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.white.withAlpha(20),
                                      borderRadius: BorderRadius.circular(
                                        size.width * 0.02,
                                      ),
                                      border: Border.all(
                                        color: AppColors.white.withAlpha(30),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 12.sp,
                                          color: AppColors.white,
                                        ),
                                        SizedBox(width: size.width * 0.01),
                                        InAppText(
                                          text:
                                              "${watchDashboardCubit.monthsTogether} months together",
                                          color: AppColors.white,
                                          fontweight: FontWeight.w600,
                                          size: 13,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.025),
                        Container(
                          padding: EdgeInsets.all(size.width * 0.04),
                          decoration: BoxDecoration(
                            color: AppColors.white.withAlpha(15),
                            borderRadius: BorderRadius.circular(
                              size.width * 0.03,
                            ),
                            border: Border.all(
                              color: AppColors.white.withAlpha(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InAppText(
                                    text: "Overall Progress",
                                    color: AppColors.white,

                                    fontweight: FontWeight.w600,
                                  ),
                                  InAppText(
                                    text:
                                        "${watchGoalCubit.overallProgressPercentage.toString()}%",
                                    fontweight: FontWeight.w900,
                                    color: AppColors.white,
                                    size: 22,
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.015),
                              Container(
                                height: size.height * 0.01,
                                width: size.width,
                                decoration: BoxDecoration(
                                  color: AppColors.blue.withAlpha(70),
                                  borderRadius: BorderRadius.circular(
                                    size.width * 0.03,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    FractionallySizedBox(
                                      widthFactor:
                                          watchGoalCubit
                                              .overallProgressPercentage /
                                          100,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.white,
                                              AppColors.white.withAlpha(90),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            size.width * 0.03,
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
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DashboardOptionCard(
                        size: size,
                        icon: Icons.message_outlined,
                        label: "Messages",
                        color: Colors.blue.shade400,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routename.conversationList,
                          );
                        },
                      ),
                      DashboardOptionCard(
                        size: size,
                        icon: Icons.track_changes,
                        label: "Goals",
                        color: Colors.purple.shade400,
                        onTap: () {
                          Navigator.pushNamed(context, Routename.goalSetUp);
                        },
                      ),
                      DashboardOptionCard(
                        size: size,
                        icon: Icons.bar_chart,
                        label: "Progress",
                        color: Colors.orange.shade400,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routename.progressDashboard,
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.03),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(size.width * 0.04),
                        decoration: BoxDecoration(
                          color: AppColors.blue.withAlpha(10),
                          borderRadius: BorderRadius.circular(
                            size.width * 0.03,
                          ),
                        ),
                        child: Icon(
                          Icons.analytics_outlined,
                          color: AppColors.blue,
                          size: 25.sp,
                        ),
                      ),
                      SizedBox(width: size.width * 0.03),
                      InAppText(
                        text: "Mentorship Stats",
                        size: 20,
                        fontweight: FontWeight.w700,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.015),

                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: size.width * 0.03,
                      mainAxisSpacing: size.height * 0.015,
                    ),
                    itemCount: watchAuthCubit.user.isMentor
                        ? watchDashboardCubit.menteeStats.length
                        : 4,
                    itemBuilder: (context, index) {
                      final statColors = [
                        [Colors.blue.shade400, Colors.blue.shade600],
                        [Colors.purple.shade400, Colors.purple.shade600],
                        [Colors.orange.shade400, Colors.orange.shade600],
                        [Colors.green.shade400, Colors.green.shade600],
                      ];
                      final stats = watchDashboardCubit.menteeStats[index];
                      return Container(
                        padding: EdgeInsets.all(size.width * 0.04),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: statColors[index % statColors.length],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: statColors[index % statColors.length][0]
                                  .withAlpha(30),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InAppText(
                              text: watchAuthCubit.user.isMentor
                                  ? "${stats['stat']}"
                                  : index == 0
                                  ? "${watchGoalCubit.activeGoalsCount}"
                                  : index == 1
                                  ? "${watchGoalCubit.completedGoalsCount}"
                                  : index == 2
                                  ? "${watchDashboardCubit.monthsTogether}"
                                  : "${watchGoalCubit.overallProgressPercentage}%",

                              color: AppColors.white,
                              size: 30,
                              fontweight: FontWeight.w900,
                            ),
                            SizedBox(height: size.height * 0.01),
                            InAppText(
                              text: stats['title'],
                              textAlign: TextAlign.center,

                              fontweight: FontWeight.w600,
                              color: AppColors.white,
                              maxline: 2,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  if (isRole == "mentor") ...[
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(size.width * 0.03),
                          decoration: BoxDecoration(
                            color: Colors.green.withAlpha(10),
                            borderRadius: BorderRadius.circular(
                              size.width * 0.03,
                            ),
                          ),
                          child: Icon(
                            Icons.flag_outlined,
                            color: Colors.green.shade600,
                            size: 25.sp,
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        BlocBuilder<DashboardCubit, DashboardState>(
                          builder: (context, state) {
                            if (watchDashboardCubit.recentGoals.isEmpty) {
                              return Column(
                                children: [
                                  InAppText(
                                    text: "Recent Goals",
                                    size: 20,
                                    fontweight: FontWeight.w700,
                                    color: AppColors.blue,
                                  ),
                                  SizedBox(height: size.height * 0.015),
                                  InAppText(
                                    text: "No recent goals available.",
                                    size: 16,
                                    color: AppColors.grey,
                                  ),
                                ],
                              );
                            }
                            return Column(
                              children: [
                                InAppText(
                                  text: "Recent Goals",
                                  size: 20,
                                  fontweight: FontWeight.w700,
                                  color: AppColors.blue,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.015),
                    Column(
                      children: List.generate(
                        watchDashboardCubit.recentGoals.length,
                        (index) => GestureDetector(
                          onTap: () {
                            final readDashboardCubit = context
                                .read<DashboardCubit>();
                            readDashboardCubit.setSelectedRecentGoal(
                              recentGoals:
                                  watchDashboardCubit.recentGoals[index],
                            );
                          },
                          child: RecentGoals(
                            recentGoals: watchDashboardCubit.recentGoals[index],
                            size: size,
                            goalTitle:
                                watchDashboardCubit.recentGoals[index]['title'],
                            status: watchDashboardCubit
                                .recentGoals[index]['status'],
                            progress: watchDashboardCubit
                                .recentGoals[index]['progress_percentage'],
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isRole == "mentee") ...[
                    BlocListener<DashboardCubit, DashboardState>(
                      listener: (context, state) {},
                      child: Builder(
                        builder: (context) {
                          // Load on first build
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (watchDashboardCubit
                                .needAttentionItems
                                .isEmpty) {
                              watchDashboardCubit.loadNeedAttentionItems(
                                user.id!,
                              );
                            }
                          });

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(size.width * 0.04),
                                    decoration: BoxDecoration(
                                      color: AppColors.orange.withAlpha(10),
                                      borderRadius: BorderRadius.circular(
                                        size.width * 0.03,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.history,
                                      color: AppColors.orange,
                                      size: 25.sp,
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.03),
                                  InAppText(
                                    text:
                                        "Need Attention (${watchDashboardCubit.needAttentionItems.length})",
                                    size: 20,
                                    fontweight: FontWeight.w700,
                                    color: AppColors.blue,
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.015),

                              if (watchDashboardCubit
                                  .needAttentionItems
                                  .isEmpty)
                                AppshadowContainer(
                                  padding: EdgeInsets.all(size.width * 0.06),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline,
                                        size: 50.sp,
                                        color: Colors.green.shade400,
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      InAppText(
                                        text: "All caught up!",
                                        fontweight: FontWeight.w600,
                                        size: 18,
                                        color: AppColors.blue,
                                      ),
                                      SizedBox(height: size.height * 0.005),
                                      InAppText(
                                        text: "No items need your attention",
                                        size: 14,
                                        color: AppColors.grey,
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Column(
                                  children: watchDashboardCubit
                                      .needAttentionItems
                                      .take(5)
                                      .map((item) {
                                        return AppshadowContainer(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              item['route'],
                                            );
                                          },
                                          shadowcolour: AppColors.lightgrey
                                              .withAlpha(50),
                                          padding: EdgeInsets.all(
                                            size.width * 0.04,
                                          ),
                                          margin: EdgeInsets.only(
                                            bottom: size.height * 0.012,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: size.height * 0.06,
                                                height: size.height * 0.06,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      item['color'],
                                                      item['color'].withAlpha(
                                                        70,
                                                      ),
                                                    ],
                                                  ),
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: item['color']
                                                          .withAlpha(20),
                                                      blurRadius: 8,
                                                      offset: Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  item['icon'],
                                                  color: AppColors.white,
                                                  size: 25.sp,
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.04,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    InAppText(
                                                      text: item['title'],
                                                      color: AppColors.blue,

                                                      fontweight:
                                                          FontWeight.w700,
                                                    ),
                                                    SizedBox(height: 4),
                                                    InAppText(
                                                      text: item['subtitle'],
                                                      size: 16,
                                                      fontweight:
                                                          FontWeight.w500,
                                                      color: AppColors.grey,
                                                      maxline: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              InAppText(
                                                text: item['time'],
                                                size: 14,
                                                color: AppColors.grey,
                                              ),
                                              SizedBox(
                                                width: size.width * 0.02,
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 18.sp,
                                                color: AppColors.grey,
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                                      .toList(),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                  SizedBox(height: size.height * 0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
