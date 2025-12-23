import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/export.dart';

class AddGoal extends StatelessWidget {
  const AddGoal({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(
            onTap: () => Navigator.pop(context),
            title: "Add Goal",
            size: MediaQuery.sizeOf(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.02),
                    InfoBar(size: size, icon: Icons.info_outline),
                    Row(
                      children: [
                        AppText(
                          text: "Goal Title",
                          color: AppColors.blue,
                          fontweight: FontWeight.w600,
                          size: 18,
                        ),
                        AppText(
                          text: " *",
                          color: Colors.red,
                          fontweight: FontWeight.w600,
                          size: 18,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.01),
                    ApptextField(hintText: "Enter your goal title"),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      children: [
                        AppText(
                          text: "Goal Description",
                          color: AppColors.blue,
                          fontweight: FontWeight.w600,
                          size: 18,
                        ),
                        AppText(
                          text: " *",
                          color: Colors.red,
                          fontweight: FontWeight.w600,
                          size: 18,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.01),
                    ApptextField(
                      maxlength: 500,

                      hintText: "Enter your goal description",
                    ),
                    SizedBox(height: size.height * 0.02),
                    AppText(
                      text: "Category",
                      color: AppColors.blue,
                      fontweight: FontWeight.w600,
                      size: 18,
                    ),
                    SizedBox(height: size.height * 0.01),
                    DropdownWidget(
                      hintText: "Select Category",
                      title: "Category",
                      prefixIcon: Icons.category_outlined,
                      onSelected: (value) {},
                      values: [
                        "Health",
                        "Career",
                        "Personal Development",
                        "Finance",
                      ],
                    ),
                    SizedBox(height: size.height * 0.04),
                    AppButton(
                      onTap: () {
                        // Handle button tap
                      },
                      label: 'Add Goal',
                      buttonColor: AppColors.blue,
                    ),
                    SizedBox(height: size.height * 0.02),
                    AppText(
                      text: "Target Completion Date",
                      color: AppColors.blue,
                      fontweight: FontWeight.w600,
                    ),
                    AppText(
                      text: " *",
                      color: Colors.red,
                      fontweight: FontWeight.w600,
                      size: 18,
                    ),
                    SizedBox(height: size.height * 0.01),
                    CalendarDatePicker(
                      initialDate: DateTime(2023, 11, 9),
                      firstDate: DateTime(2023, 11, 9),
                      lastDate: DateTime(2025, 11, 9),
                      onDateChanged: (value) {},
                    ),
                    AppText(
                      text: "Success Criteria",
                      color: AppColors.blue,
                      fontweight: FontWeight.w600,
                      size: 18,
                    ),
                    SizedBox(height: size.height * 0.01),
                    ApptextField(
                      maxlength: 300,
                      hintText: "Define how you will measure success",
                    ),
                    SizedBox(height: size.height * 0.02),
                    AppButton(
                      onTap: () {
                        // Handle button tap
                      },
                      label: 'Add Goal',
                      buttonColor: AppColors.blue,
                    ),
                    SizedBox(height: size.height * 0.02),
                    AppButton(
                      onTap: () {
                        // Handle button tap
                      },
                      label: 'Cancel',
                      buttonColor: AppColors.errorColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoBar extends StatelessWidget {
  const InfoBar({super.key, required this.size, this.text, this.icon});

  final Size size;
  final String? text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      color: AppColors.background,
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      child: AppshadowContainer(
        padding: EdgeInsets.all(size.width * 0.02),
        color: AppColors.inactive,
        margin: EdgeInsets.only(left: size.width * 0.025),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: AppColors.filledColor,
              size: 23.sp,
            ),
            SizedBox(width: size.width * 0.015),
            SizedBox(
              width: size.width * 0.775,
              child: AppText(
                text:
                    text ??
                    "Set SMART goals: Specific, Measurable, Achievable, Relevant, Time-bound",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
