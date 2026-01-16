import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Profile/presentation/cubit/profile_cubit.dart';
import '../../../../../../constants/utils/app_colors.dart';
import '../../../../../../global widgets/export.dart';

class RequestMentorship extends StatelessWidget {
  const RequestMentorship({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchProfileCubit = context.watch<ProfileCubit>();
    final readProfileCubit = context.read<ProfileCubit>();
    final selectedGoals = watchProfileCubit.selectedGoals;
    final availableGoals = watchProfileCubit.availableGoals;
    final messageController = watchProfileCubit.messageController;
    final selectedMentor = watchProfileCubit.selectedMentor;
    final menteeId = context.watch<AuthenticationCubit>().user.id ?? "";
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is RequestSentState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.width * 0.03),
              ),
              contentPadding: EdgeInsets.all(size.width * 0.06),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 150.sp,
                    color: AppColors.background,
                  ),
                  SizedBox(height: size.height * 0.02),
                  InAppText(
                    text: 'Request Sent',
                    fontweight: FontWeight.w700,
                    size: 22,
                    color: AppColors.blue,
                  ),
                  SizedBox(height: size.height * 0.01),
                  InAppText(
                    text: 'Your mentorship request has been sent successfully',
                    size: 15,
                    textAlign: TextAlign.center,
                    color: AppColors.grey,
                    maxline: 2,
                  ),
                  SizedBox(height: size.height * 0.03),
                  AppButton(
                    onTap: () {
                      Navigator.pop(context);
                      readProfileCubit.loadAllMyRequests(menteeId);
                      Navigator.pushNamed(context, Routename.myRequests);
                    },
                    width: size.width,
                    buttonColor: AppColors.background,
                    label: 'View My Requests',
                  ),
                ],
              ),
            ),
          );
        } else if (state is ProfileErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
      },
      child: AppScaffold(
        body: Column(
          children: [
            AppbarWidget(
              size: size,
              title: "Request Mentorship",
              onTap: () => Navigator.pop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.025),
                    AppshadowContainer(
                      padding: EdgeInsets.all(size.width * 0.05),
                      shadowcolour: AppColors.blue.withAlpha(50),
                      child: Column(
                        children: [
                          selectedMentor?.profilePhotoUrl != null
                              ? CircleAvatar(
                                  radius: 40.sp,
                                  backgroundImage: NetworkImage(
                                    selectedMentor?.profilePhotoUrl ?? "",
                                  ),
                                  backgroundColor: AppColors.white,
                                )
                              : Container(
                                  margin: EdgeInsets.all(size.width * 0.01),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.white,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 50.sp,
                                    color: AppColors.blue,
                                  ),
                                ),

                          SizedBox(height: size.height * 0.01),

                          InAppText(
                            text: selectedMentor?.name ?? "Mentor Name",
                            size: 24,
                            fontweight: FontWeight.w700,
                          ),
                          SizedBox(height: size.height * 0.009),

                          InAppText(
                            text: selectedMentor?.expertise ?? "Expertise Area",
                            size: 16,
                            color: AppColors.lightblack,
                          ),
                          SizedBox(height: size.height * 0.012),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StatItem(
                                icon: Icons.star,
                                value: "0",
                                size: size,
                              ),
                              SizedBox(width: size.width * 0.04),
                              HorizontalDivider(
                                size: size,
                                color: AppColors.grey.withAlpha(70),
                                width: 2,
                                height: size.height * 0.04,
                              ),
                              SizedBox(width: size.width * 0.04),
                              StatItem(
                                icon: Icons.people_outline,
                                value: "15",
                                size: size,
                              ),
                              SizedBox(width: size.width * 0.04),
                              HorizontalDivider(
                                size: size,
                                color: AppColors.grey.withAlpha(70),
                                width: 2,
                                height: size.height * 0.04,
                              ),
                              SizedBox(width: size.width * 0.04),
                              StatItem(
                                icon: Icons.work_outline,
                                value:
                                    "${selectedMentor?.yearsExperience ?? 0} yrs",
                                size: size,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      width: size.width,
                      padding: EdgeInsets.all(size.width * 0.04),
                      decoration: BoxDecoration(
                        color: AppColors.filledColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(size.width * 0.03),
                        border: Border(
                          left: BorderSide(
                            color: AppColors.filledColor,
                            width: size.width * 0.02,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.blue,
                            size: 22.sp,
                          ),
                          SizedBox(width: size.width * 0.03),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InAppText(
                                  text: "Be Specific",
                                  size: 16,
                                  fontweight: FontWeight.w700,
                                  color: AppColors.blue,
                                ),
                                SizedBox(height: size.width * 0.01),
                                InAppText(
                                  text:
                                      "Clearly describe what you want to learn and achieve",
                                  size: 14,
                                  color: AppColors.lightblack,
                                  maxline: 3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(size.width * 0.03),
                          decoration: BoxDecoration(
                            color: AppColors.blue.withAlpha(10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.edit_note,
                            color: AppColors.blue,
                            size: 25.sp,
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        InAppText(
                          text: "Why You Need Mentorship",
                          size: 20,
                          fontweight: FontWeight.w700,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.015),

                    AppshadowContainer(
                      padding: EdgeInsets.all(size.width * 0.03),
                      shadowcolour: AppColors.lightgrey.withAlpha(50),
                      child: TextField(
                        controller: messageController,
                        maxLines: 5,
                        maxLength: 500,
                        decoration: InputDecoration(
                          hintText:
                              "I would like to improve my skills in Flutter development and learn best practices for building scalable applications...",
                          hintStyle: GoogleFonts.ptSans(
                            color: AppColors.blue.withAlpha(90),
                            fontSize: 16.sp,
                          ),
                          border: InputBorder.none,
                          counterStyle: GoogleFonts.ptSans(
                            color: AppColors.grey,
                            fontSize: 14.sp,
                          ),
                        ),
                        style: GoogleFonts.ptSans(
                          fontSize: 16.sp,
                          color: AppColors.lightblack,
                          height: 1.5,
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),
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
                        InAppText(
                          text: "Select Your Goals",
                          size: 20,
                          fontweight: FontWeight.w700,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.008),
                    InAppText(
                      text: "Choose at least 2 goals",
                      size: 14,
                      color: AppColors.grey,
                    ),
                    SizedBox(height: size.height * 0.015),

                    AppshadowContainer(
                      padding: EdgeInsets.all(size.width * 0.04),
                      shadowcolour: AppColors.lightgrey.withAlpha(50),
                      child: Wrap(
                        spacing: size.width * 0.025,
                        runSpacing: size.height * 0.012,
                        children: availableGoals.map((goal) {
                          final isSelected = selectedGoals.contains(
                            goal['label'],
                          );
                          return GoalChip(
                            label: goal['label'],
                            icon: goal['icon'],
                            isSelected: isSelected,
                            onTap: () {
                              readProfileCubit.toggleGoal(goal['label']);
                            },
                            size: size,
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(height: size.height * 0.025),

                    // Selected Goals Count
                    if (selectedGoals.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(size.width * 0.04),
                        decoration: BoxDecoration(
                          color: AppColors.success.withAlpha(10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: 24.sp,
                            ),
                            SizedBox(width: size.width * 0.03),
                            InAppText(
                              text:
                                  "${selectedGoals.length} goal${selectedGoals.length > 1 ? 's' : ''} selected",
                              size: 16,
                              fontweight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: size.height * 0.04),
                    AppButton(
                      isLoading: watchProfileCubit.state is ProfileLoadingState,
                      onTap: () {
                        final readProfileCubit = context.read<ProfileCubit>();
                        readProfileCubit.validateRequest();
                        Future.delayed(const Duration(milliseconds: 500), () {
                          readProfileCubit.sendMentorshipRequest(
                            menteeId: menteeId,
                            mentorId: selectedMentor?.id ?? '',
                          );
                        });
                      },
                      label: "Send Request",
                      buttonColor: AppColors.background,
                      width: size.width,
                      textSize: 17,
                    ),

                    SizedBox(height: size.height * 0.015),

                    AppButton(
                      onTap: () => Navigator.pop(context),
                      label: "Cancel",
                      buttonColor: Colors.transparent,
                      bordercolor: AppColors.errorColor,
                      labelColor: AppColors.errorColor,
                      width: size.width,
                      textSize: 17,
                    ),

                    SizedBox(height: size.height * 0.03),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final Size size;

  const StatItem({
    super.key,
    required this.icon,
    required this.value,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.blue),
        SizedBox(width: 4),
        InAppText(
          text: value,
          size: 15,
          fontweight: FontWeight.w600,
          color: AppColors.blue,
        ),
      ],
    );
  }
}

class GoalChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Size size;

  const GoalChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.012,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [AppColors.blue, AppColors.filledColor])
              : null,
          color: isSelected ? null : AppColors.grey.withAlpha(10),
          borderRadius: BorderRadius.circular(size.width * 0.05),
          border: Border.all(
            color: isSelected ? AppColors.white : AppColors.grey.withAlpha(50),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.blue.withAlpha(50),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: isSelected ? AppColors.white : AppColors.grey,
            ),
            SizedBox(width: 6),
            InAppText(
              text: label,
              size: 16,
              fontweight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.white : AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({
    super.key,
    required this.size,
    this.width,
    this.height,
    this.color,
  });

  final Size size;
  final double? width, height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? size.width * 0.004,
      height: height ?? size.height * 0.05,
      color: color ?? AppColors.white.withAlpha(70),
    );
  }
}
