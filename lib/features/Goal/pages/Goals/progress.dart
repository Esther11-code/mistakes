import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Goal/pages/cubit/goal_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../widgets/progress_widget.dart';

class ProgressDashboard extends StatelessWidget {
  const ProgressDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final goalCubit = context.read<GoalCubit>();
    if (goalCubit.allGoals.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        goalCubit.user = context.read<AuthenticationCubit>().user;
        goalCubit.loadGoals(context);
      });
    }

    return const ProgressDashboardView();
  }
}

class ProgressDashboardView extends StatelessWidget {
  const ProgressDashboardView({super.key});

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

        if (state is GoalProgressUpdatedState) {
          Fluttertoast.showToast(
            msg: "Progress updated successfully!",
            gravity: ToastGravity.TOP,
            backgroundColor: AppColors.success,
          );
        }
      },
      child: AppScaffold(
        body: Column(
          children: [
            AppbarWidget(
              title: 'Progress Dashboard',
              size: size,
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: size.height * 0.02),

            Expanded(
              child: BlocBuilder<GoalCubit, GoalState>(
                builder: (context, state) {
                  if (state is GoalLoadingState &&
                      watchGoalCubit.allGoals.isEmpty) {
                    return Center(
                      child: LoadingAnimationWidget.inkDrop(
                        color: AppColors.filledColor,
                        size: 50.sp,
                      ),
                    );
                  }
                  if (watchGoalCubit.allGoals.isEmpty) {
                    return EmptyGoalsState(size: size);
                  }
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0.025),
                        OverallProgressCard(
                          size: size,
                          overallProgress:
                              watchGoalCubit.overallProgressPercentage,
                          completedGoals: watchGoalCubit.completedGoalsCount,
                          totalGoals: watchGoalCubit.allGoals.length,
                          activeGoals: watchGoalCubit.activeGoalsCount,
                        ),

                        SizedBox(height: size.height * 0.03),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(size.width * 0.03),
                              decoration: BoxDecoration(
                                color: Colors.green.withAlpha(10),
                                borderRadius: BorderRadius.circular(
                                  size.width * 0.05,
                                ),
                              ),
                              child: Icon(
                                Icons.flag_outlined,
                                color: Colors.green.shade600,
                                size: 25.sp,
                              ),
                            ),
                            SizedBox(width: size.width * 0.03),
                            InAppText(
                              text: "Update Progress",
                              size: 20,
                              fontweight: FontWeight.w700,
                              color: AppColors.blue,
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.015),
                        ...List.generate(watchGoalCubit.allGoals.length, (
                          index,
                        ) {
                          final goal = watchGoalCubit.allGoals[index];
                          return GoalProgressCard(
                            goal: goal,
                            size: size,
                            onProgressUpdate: (newProgress) {
                              readGoalCubit.updateProgress(
                                context: context,

                                goal.id,
                                newProgress,
                              );
                            },
                          );
                        }),
                        SizedBox(height: size.height * 0.03),
                      ],
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
