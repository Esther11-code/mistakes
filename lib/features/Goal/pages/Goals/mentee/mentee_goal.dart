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
import '../../widgets/mentee_goal_widget.dart';

class MenteeGoal extends StatelessWidget {
  const MenteeGoal({super.key});

  @override
  Widget build(BuildContext context) {
    final goalCubit = context.read<GoalCubit>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (goalCubit.allGoals.isEmpty) {
        goalCubit.user = context.read<AuthenticationCubit>().user;
        goalCubit.loadGoals(context);
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
                              await readGoalCubit.loadGoals(context);
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
        backgroundColor: AppColors.white,
        title: InAppText(
          textAlign: TextAlign.center,
          text: "Delete Goal",
          size: 20,
          fontweight: FontWeight.w700,
          color: AppColors.blue,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InAppText(
              textAlign: TextAlign.center,
              text: "Are you sure you want to delete '$goalTitle'?",
              size: 16,
            ),
            SizedBox(height: size.height * 0.009),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
          ],
        ),
      ),
    );
  }
}

