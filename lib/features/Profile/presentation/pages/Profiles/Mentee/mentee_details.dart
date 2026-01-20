import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Chat/presentation/cubit/chat_cubit.dart';
import 'package:mistakes/features/Goal/pages/cubit/goal_cubit.dart';
import 'package:mistakes/features/Profile/presentation/cubit/mentor_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';
import 'package:mistakes/config/detail/route_name.dart';

class MenteeDetails extends StatelessWidget {
  const MenteeDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchProfileCubit = context.watch<MentorCubit>();
    final mentee = watchProfileCubit
        .selectedMenteeDetails; // You'll need to add this to ProfileCubit

    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(
            size: size,
            title: "Mentee Details",
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: size.height * 0.03),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Card
                    AppshadowContainer(
                      color: AppColors.white,
                      padding: EdgeInsets.all(size.width * 0.03),
                      shadowcolour: AppColors.lightgrey.withAlpha(100),
                      child: Column(
                        children: [
                          mentee?["profile_photo_url"] != null
                              ? AppNetwokImage(
                                  height: size.height * 0.15,
                                  width: size.height * 0.15,
                                  imageUrl: mentee?["profile_photo_url"] ?? "",
                                  isCircular: true,
                                )
                              : CircleAvatar(
                                  backgroundColor: AppColors.filledColor,
                                  radius: size.height * 0.07,
                                  child: Icon(
                                    Icons.person,
                                    size: 50.sp,
                                    color: AppColors.white,
                                  ),
                                ),
                          SizedBox(height: size.height * 0.02),
                          InAppText(
                            text: mentee?["full_name"] ?? "Mentee Name",
                            size: 20,
                            fontweight: FontWeight.bold,
                          ),
                          SizedBox(height: size.height * 0.01),
                          AppshadowContainer(
                            alignment: Alignment.center,
                            color: AppColors.inactive,
                            border: true,
                            borderColor: AppColors.background,
                            width: size.width * 0.4,
                            padding: EdgeInsets.all(size.width * 0.02),
                            child: InAppText(
                              text: "Mentee",
                              size: 16,
                              color: AppColors.blue,
                              fontweight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                    // Learning Goals
                    InAppText(
                      text: "Learning Goals",
                      size: 20,
                      fontweight: FontWeight.w600,
                    ),
                    SizedBox(height: size.height * 0.01),
                    AppshadowContainer(
                      color: AppColors.white,
                      padding: EdgeInsets.all(size.width * 0.03),
                      shadowcolour: AppColors.lightgrey.withAlpha(100),
                      child: InAppText(
                        textAlign: TextAlign.justify,
                        maxline: 10,
                        text:
                            mentee?["learning_goals"] ??
                            "No learning goals set yet",
                        color: AppColors.blackColor,
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                    // Areas of Interest
                    InAppText(
                      text: "Areas of Interest",
                      size: 20,
                      fontweight: FontWeight.w600,
                    ),
                    SizedBox(height: size.height * 0.01),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: size.width * 0.02,
                      runSpacing: size.height * 0.02,
                      children: List.generate(
                        mentee?["area_of_interest"]?.length ?? 0,
                        (index) => IntrinsicWidth(
                          child: AppshadowContainer(
                            radius: size.height * 0.05,
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                              vertical: size.height * 0.01,
                            ),
                            border: true,
                            borderColor: AppColors.background,
                            color: AppColors.inactive,
                            child: InAppText(
                              text: mentee?["area_of_interest"]?[index] ?? "",
                              color: AppColors.blue,
                              fontweight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                    // Progress Overview
                    InAppText(
                      text: "Progress Overview",
                      size: 20,
                      fontweight: FontWeight.w600,
                    ),
                    SizedBox(height: size.height * 0.01),
                    AppshadowContainer(
                      color: AppColors.white,
                      padding: EdgeInsets.all(size.width * 0.03),
                      shadowcolour: AppColors.lightgrey.withAlpha(100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            "Goals",
                            context
                                .watch<GoalCubit>()
                                .allGoals
                                .length
                                .toString(),
                            AppColors.blue,
                          ),
                          _buildStatItem(
                            "Completed",
                            context
                                .watch<GoalCubit>()
                                .allGoals
                                .where((goal) => goal.status == "completed")
                                .length
                                .toString(),
                            AppColors.green,
                          ),
                          _buildStatItem(
                            "In Progress",
                            context
                                .watch<GoalCubit>()
                                .allGoals
                                .where((goal) => goal.status == "active")
                                .length
                                .toString(),
                            AppColors.orange,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),
                  ],
                ),
              ),
            ),
          ),

          // Action Button
          AppButton(
            onTap: () {
              // Navigate to chat with this mentee
              final chatCubit = context.read<ChatCubit>();
              chatCubit.startConversationWith(
                otherUserId: mentee?["id"] ?? "",
                currentUserIsMentor: true,
                user: context.read<AuthenticationCubit>().user,
              );
              Navigator.pushNamed(context, Routename.menteeChat);
            },
            buttonColor: AppColors.blue,
            width: size.width * 0.9,
            height: size.height * 0.06,
            textSize: 18,
            label: "Message Mentee",
          ),
          SizedBox(height: size.height * 0.03),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        InAppText(
          text: value,
          color: color,
          size: 24,
          fontweight: FontWeight.w700,
        ),
        InAppText(text: label, size: 14, color: AppColors.grey),
      ],
    );
  }
}
