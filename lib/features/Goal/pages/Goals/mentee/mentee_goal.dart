import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/config/page%20route/page_route.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Goal/pages/cubit/goal_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';
import '../../../../../constants/utils/app_colors.dart';

class MenteeGoal extends StatelessWidget {
  const MenteeGoal({super.key});

  @override
  Widget build(BuildContext context) {
    final goalCubit = context.read<GoalCubit>();

    // Load goals when screen opens if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (goalCubit.allGoals.isEmpty) {
        goalCubit.user = context.read<AuthenticationCubit>().user;
        goalCubit.loadGoals();
      }
    });

    return const MenteeGoalView();
  }
}

class MenteeGoalView extends StatelessWidget {
  const MenteeGoalView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final readGoalCubit = context.read<GoalCubit>();
    final watchGoalCubit = context.watch<GoalCubit>();

    return BlocListener<GoalCubit, GoalState>(
      listener: (context, state) {
        if (state is GoalErrorState) {
          Fluttertoast.showToast(
            msg: "Failed to load goals",
            gravity: ToastGravity.TOP,
            backgroundColor: AppColors.errorColor,
          );
        }

        if (state is GoalCreatedState) {
          Fluttertoast.showToast(
            msg: "Goal created successfully!",
            gravity: ToastGravity.TOP,
            backgroundColor: AppColors.success,
          );
        }

        if (state is GoalDeletedState) {
          Fluttertoast.showToast(
            msg: "Goal deleted successfully!",
            gravity: ToastGravity.TOP,
            backgroundColor: AppColors.orange,
          );
        }
      },
      child: AppScaffold(
        color: AppColors.background,
        body: Column(
          children: [
            AppbarWidget(
              onTap: () => Navigator.pop(context),
              title: "My Goals",
              size: size,
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              textColor: AppColors.white,
              iconColor: AppColors.white,
            ),
            SizedBox(height: size.height * 0.03),

            // Filter Tabs (All, Ongoing, Completed)
            GoalFilterTabs(size: size),

            SizedBox(height: size.height * 0.025),

            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Add Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InAppText(
                          text:
                              "${watchGoalCubit.goalFilterOptions[watchGoalCubit.selectedGoalFilterIndex]} Goals",
                          color: AppColors.blue,
                          size: 18,
                          fontweight: FontWeight.w600,
                        ),
                        Visibility(
                          visible: context
                              .watch<AuthenticationCubit>()
                              .user
                              .isMentee,
                          child: AppButton(
                            width: size.width * 0.3,
                            height: size.height * 0.05,
                            buttonColor: AppColors.blue,
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: AppColors.white,
                                  size: 20.sp,
                                ),
                                SizedBox(width: size.width * 0.01),
                                InAppText(
                                  text: "Add Goal",
                                  color: AppColors.white,
                                  fontweight: FontWeight.w500,
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, Routename.addGoal);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),

                    // Goals List
                    Expanded(
                      child: BlocBuilder<GoalCubit, GoalState>(
                        builder: (context, state) {
                          if (state is GoalLoadingState &&
                              watchGoalCubit.allGoals.isEmpty) {
                            return Center(
                              child: LoadingAnimationWidget.hexagonDots(
                                color: AppColors.background,
                                size: 50.sp,
                              ),
                            );
                          }

                          if (watchGoalCubit.filteredGoals.isEmpty) {
                            return EmptyGoalsView(
                              size: size,
                              filterType:
                                  watchGoalCubit
                                      .goalFilterOptions[watchGoalCubit
                                      .selectedGoalFilterIndex],
                            );
                          }

                          return RefreshIndicator(
                            color: AppColors.blue,
                            onRefresh: () async {
                              await readGoalCubit.loadGoals();
                            },
                            child: ListView.builder(
                              itemCount: watchGoalCubit.filteredGoals.length,
                              itemBuilder: (context, index) {
                                final goal =
                                    watchGoalCubit.filteredGoals[index];
                                return GoalCard(
                                  goal: goal,
                                  size: size,
                                  onTap: () {
                                    readGoalCubit.setSelectedGoalIndex(index);
                                    // Navigate to goal details or edit
                                    Navigator.pushNamed(
                                      context,
                                      Routename.progressDashboard,
                                    );
                                  },
                                  onDelete: () {
                                    _showDeleteConfirmation(
                                      context,
                                      size,
                                      goal.id,
                                      goal.title,
                                      readGoalCubit,
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Size size,
    String goalId,
    String goalTitle,
    GoalCubit cubit,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: InAppText(
          text: "Delete Goal?",
          size: 18,
          fontweight: FontWeight.bold,
          color: AppColors.blue,
        ),
        content: InAppText(
          text: "Are you sure you want to delete '$goalTitle'?",
          size: 14,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: InAppText(text: "Cancel", color: AppColors.grey),
          ),
          TextButton(
            onPressed: () {
              cubit.deleteGoal(goalId);
              Navigator.pop(context);
            },
            child: InAppText(
              text: "Delete",
              color: AppColors.errorColor,
              fontweight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class GoalFilterTabs extends StatelessWidget {
  final Size size;

  const GoalFilterTabs({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final readGoalCubit = context.read<GoalCubit>();
    final watchGoalCubit = context.watch<GoalCubit>();

    return AppshadowContainer(
      border: true,
      borderColor: AppColors.inactive.withAlpha(100),
      color: Colors.transparent,
      width: size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          watchGoalCubit.goalFilterOptions.length,
          (int index) => AppshadowContainer(
            color: watchGoalCubit.selectedGoalFilterIndex == index
                ? AppColors.inactive.withAlpha(30)
                : Colors.transparent,
            onTap: () => readGoalCubit.changeGoalFilter(index),
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.015,
              horizontal: size.width * 0.04,
            ),
            child: InAppText(
              text: watchGoalCubit.goalFilterOptions[index],
              color: watchGoalCubit.selectedGoalFilterIndex == index
                  ? AppColors.white
                  : AppColors.inactive,
              fontweight: FontWeight.w500,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyGoalsView extends StatelessWidget {
  final Size size;
  final String filterType;

  const EmptyGoalsView({
    super.key,
    required this.size,
    required this.filterType,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.track_changes,
            size: 80.sp,
            color: AppColors.grey.withAlpha(100),
          ),
          SizedBox(height: size.height * 0.02),
          InAppText(
            text: "No $filterType Goals",
            size: 20,
            fontweight: FontWeight.bold,
            color: AppColors.blue,
          ),
          SizedBox(height: size.height * 0.01),
          InAppText(
            text: filterType == "All"
                ? "Create your first goal to get started"
                : "No goals in this category yet",
            size: 14,
            color: AppColors.grey,
            textAlign: TextAlign.center,
          ),
          if (filterType == "All") ...[
            SizedBox(height: size.height * 0.03),
            Visibility(
              visible: context.watch<AuthenticationCubit>().user.isMentee,
              child: AppButton(
                onTap: () => Navigator.pushNamed(context, Routename.addGoal),
                label: "Create Goal",
                buttonColor: AppColors.blue,
                width: size.width * 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class GoalCard extends StatelessWidget {
  final dynamic goal; // GoalModel type
  final Size size;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const GoalCard({
    super.key,
    required this.goal,
    required this.size,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      onTap: onTap,
      margin: EdgeInsets.only(bottom: size.height * 0.015),
      padding: EdgeInsets.all(size.width * 0.04),
      shadowcolour: AppColors.lightgrey.withAlpha(50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InAppText(
                      text: goal.title,
                      size: 20,
                      fontweight: FontWeight.w700,
                      color: AppColors.blue,
                      maxline: 2,
                    ),
                    SizedBox(height: size.height * 0.005),
                    InAppText(
                      text:
                          "${_getCategoryIcon(goal.category)} ${goal.category.toUpperCase()}",
                      size: 12,
                      color: AppColors.grey,
                      fontweight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                color: AppColors.white,
                icon: Icon(Icons.more_vert, color: AppColors.blue),
                onSelected: (value) {
                  if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          size: 18,
                          color: AppColors.errorColor,
                        ),
                        SizedBox(width: 8),
                        InAppText(text: 'Delete', color: AppColors.errorColor),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: size.height * 0.01),

          InAppText(
            text: goal.description,
            size: 14,
            color: AppColors.grey,
            maxline: 2,
          ),

          SizedBox(height: size.height * 0.015),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InAppText(text: "Progress", size: 14, color: AppColors.grey),
              InAppText(
                text: "${goal.progressPercentage}%",
                size: 16,
                fontweight: FontWeight.w800,
                color: AppColors.filledColor,
              ),
            ],
          ),

          SizedBox(height: size.height * 0.01),

          Container(
            height: size.height * 0.012,
            width: size.width,
            decoration: BoxDecoration(
              color: AppColors.grey.withAlpha(30),
              borderRadius: BorderRadius.circular(size.width * 0.02),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: goal.progressPercentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.filledColor, AppColors.blue],
                      ),
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: size.height * 0.015),

          // Footer Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.height * 0.006,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(goal.status).withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _getStatusColor(goal.status)),
                ),
                child: InAppText(
                  text: goal.status.toUpperCase(),
                  size: 12,
                  fontweight: FontWeight.bold,
                  color: _getStatusColor(goal.status),
                ),
              ),

              // Deadline
              if (goal.deadline != null)
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: AppColors.grey),
                    SizedBox(width: 4),
                    InAppText(
                      text: _formatDeadline(goal.deadline),
                      size: 12,
                      color: AppColors.grey,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'active':
        return Colors.blue;
      case 'abandoned':
        return Colors.red;
      default:
        return AppColors.grey;
    }
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'career':
        return '💼';
      case 'skill':
        return '🎯';
      case 'personal':
        return '☘️';
      default:
        return '📌';
    }
  }

  String _formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now).inDays;

    if (difference < 0) {
      return "Overdue";
    } else if (difference == 0) {
      return "Today";
    } else if (difference == 1) {
      return "Tomorrow";
    } else if (difference < 7) {
      return "$difference days";
    } else {
      return "${deadline.day}/${deadline.month}/${deadline.year}";
    }
  }
}
