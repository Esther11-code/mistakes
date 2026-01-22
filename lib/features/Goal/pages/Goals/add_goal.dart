import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Goal/pages/cubit/goal_cubit.dart';
import 'package:mistakes/features/Goal/pages/widgets/add_goal_widget.dart';
import 'package:mistakes/features/Profile/presentation/cubit/mentor_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

class AddGoal extends StatefulWidget {
  const AddGoal({super.key});

  @override
  State<AddGoal> createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
  @override
  void initState() {
    super.initState();
    final goalCubit = context.read<GoalCubit>();
    goalCubit.loadInterests();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchGoalCubit = context.watch<GoalCubit>();
    final readGoalCubit = context.read<GoalCubit>();
    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(
            onTap: () => Navigator.pop(context),
            title: "Add Goal",
            size: size,
          ),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.025),
                  Container(
                    width: size.width,
                    padding: EdgeInsets.all(size.width * 0.04),
                    decoration: BoxDecoration(
                      color: AppColors.inactive,
                      borderRadius: BorderRadius.circular(size.width * 0.05),
                      border: Border(
                        left: BorderSide(
                          color: AppColors.background,
                          width: size.width * 0.03,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.blue,
                          size: 25.sp,
                        ),
                        SizedBox(width: size.width * 0.03),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InAppText(
                                text: "SMART Goals",
                                fontweight: FontWeight.w700,
                              ),
                              SizedBox(height: size.height * 0.01),
                              InAppText(
                                text:
                                    "Set goals that are Specific, Measurable, Achievable, Relevant, and Time-bound",
                                size: 16,
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
                  Text.rich(
                    TextSpan(
                      text: 'Goal Title',
                      style: GoogleFonts.ptSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      children: [
                        TextSpan(
                          text: '*',
                          style: GoogleFonts.ptSans(
                            color: AppColors.errorColor,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.012),
                  AppshadowContainer(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                      vertical: size.height * 0.005,
                    ),
                    color: AppColors.white,
                    child: ApptextField(
                      controller: watchGoalCubit.titleController,
                      hintText: "e.g., Learn Flutter Development",
                      prefixIconn: Icon(
                        Icons.flag_outlined,
                        color: AppColors.blue,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),
                  Text.rich(
                    TextSpan(
                      text: 'Category',
                      style: GoogleFonts.ptSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      children: [
                        TextSpan(
                          text: '*',
                          style: GoogleFonts.ptSans(
                            color: AppColors.errorColor,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.012),
                  Wrap(
                    spacing: size.width * 0.025,
                    runSpacing: size.height * 0.012,
                    children: List.generate(
                      watchGoalCubit.goalCategories.length,
                      (index) {
                        final category = watchGoalCubit.goalCategories[index];
                        final isSelected =
                            watchGoalCubit.selectedCategory == category;

                        return CategoryChip(
                          label:
                              category[0].toUpperCase() + category.substring(1),
                          isSelected: isSelected,
                          onTap: () {
                            readGoalCubit.changeCategory(category);
                          },
                          size: size,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),
                  Text.rich(
                    TextSpan(
                      text: 'Description',
                      style: GoogleFonts.ptSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      children: [
                        TextSpan(
                          text: '*',
                          style: GoogleFonts.ptSans(
                            color: AppColors.errorColor,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppshadowContainer(
                    padding: EdgeInsets.all(size.width * 0.04),
                    color: AppColors.white,
                    child: ApptextField(
                      controller: watchGoalCubit.descriptionController,
                      maxLine: 4,
                      maxlength: 500,
                      hintText: "Describe what you want to achieve...",
                    ),
                  ),

                  SizedBox(height: size.height * 0.02),
                  Text.rich(
                    TextSpan(
                      text: 'Target Completion Date',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      children: [
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: AppColors.errorColor,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.012),
                  GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.blue,
                                onPrimary: Colors.white,
                                onSurface: AppColors.lightblack,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        readGoalCubit.setDeadline(picked);
                      }
                    },
                    child: AppshadowContainer(
                      padding: EdgeInsets.all(size.width * 0.04),
                      color: AppColors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: AppColors.blue,
                                size: 20,
                              ),
                              SizedBox(width: size.width * 0.03),
                              InAppText(
                                text: watchGoalCubit.selectedDeadline != null
                                    ? "${watchGoalCubit.selectedDeadline!.day}/${watchGoalCubit.selectedDeadline!.month}/${watchGoalCubit.selectedDeadline!.year}"
                                    : "Select a date",
                                size: 15,
                                color: watchGoalCubit.selectedDeadline != null
                                    ? AppColors.blackColor
                                    : AppColors.grey,
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18.sp,
                            color: AppColors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.025),
                  InAppText(
                    text: "Success Criteria",
                    size: 20,
                    fontweight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: size.height * 0.008),
                  InAppText(
                    text: "How will you know you've achieved this goal?",
                    size: 16,
                    color: AppColors.grey,
                  ),
                  SizedBox(height: size.height * 0.012),
                  AppshadowContainer(
                    padding: EdgeInsets.all(size.width * 0.04),
                    color: AppColors.white,
                    child: ApptextField(
                      maxLine: 3,
                      maxlength: 300,
                      controller: watchGoalCubit.successCriteriaController,
                      hintText:
                          "e.g., Build 3 Flutter apps, Pass certification exam",
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  BlocListener<GoalCubit, GoalState>(
                    listener: (context, state) {
                      if (state is GoalCreatedState) {
                        Fluttertoast.showToast(msg: 'Goal created successfully!');
                       
                        Navigator.pop(context);
                      } 
                    },
                    child: Visibility(
                      visible: context
                          .watch<AuthenticationCubit>()
                          .user
                          .isMentee,
                      child: AppButton(
                        isLoading: watchGoalCubit.state is GoalLoadingState,
                        onTap: () {
                          if (watchGoalCubit.titleController.text
                              .trim()
                              .isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please enter a goal title'),
                                backgroundColor: AppColors.errorColor,
                              ),
                            );
                            return;
                          }

                          if (watchGoalCubit.descriptionController.text
                              .trim()
                              .isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please enter a description'),
                                backgroundColor: AppColors.errorColor,
                              ),
                            );
                            return;
                          }

                          if (watchGoalCubit.selectedDeadline == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please select a target date'),
                                backgroundColor: AppColors.errorColor,
                              ),
                            );
                            return;
                          }
                          readGoalCubit.createGoal(
                            context: context,
                            matchId:
                                context
                                    .read<MentorCubit>()
                                    .currentMentorMatchId ??
                                "",
                          );
                        },
                        width: size.width,
                        buttonColor: AppColors.filledColor,
                        label: 'Create Goal',
                        textSize: 20,
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.015),
                  AppButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    width: size.width,
                    bordercolor: AppColors.errorColor,
                    label: 'Cancel',
                    labelColor: AppColors.errorColor,
                    buttonColor: Colors.transparent,
                    textSize: 20,
                  ),

                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

