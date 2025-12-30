import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
                    children: [
                      CategoryChip(
                        label: "Health",
                        icon: Icons.favorite_outline,
                        isSelected: true,
                        onTap: () {},
                        size: size,
                      ),
                      CategoryChip(
                        label: "Career",
                        icon: Icons.work_outline,
                        isSelected: false,
                        onTap: () {},
                        size: size,
                      ),
                      CategoryChip(
                        label: "Personal",
                        icon: Icons.person_outline,
                        isSelected: false,
                        onTap: () {},
                        size: size,
                      ),
                      CategoryChip(
                        label: "Finance",
                        icon: Icons.account_balance_wallet_outlined,
                        isSelected: false,
                        onTap: () {},
                        size: size,
                      ),
                    ],
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
                        // Handle date selection
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
                                text: "Select a date",
                                size: 15,
                                color: AppColors.grey,
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
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

                      hintText:
                          "e.g., Build 3 Flutter apps, Pass certification exam",
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  AppButton(
                    onTap: () {
                      // Add goal logic
                    },
                    width: size.width,
                    buttonColor: AppColors.filledColor,
                    label: 'Create Goal',
                    textSize: 20,
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

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Size size;

  const CategoryChip({
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
          vertical: size.height * 0.02,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppColors.background, AppColors.filledColor],
                )
              : null,
          color: isSelected ? null : AppColors.grey.withAlpha(20),
          borderRadius: BorderRadius.circular(25),

          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.grey.withAlpha(50),
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
              size: 22.sp,
              color: isSelected ? AppColors.white : AppColors.grey,
            ),
            SizedBox(width: 6),
            InAppText(
              text: label,
              size: 20,
              fontweight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.white : AppColors.grey,
            ),
          ],
        ),
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
            Icon(icon, color: AppColors.filledColor, size: 23.sp),
            SizedBox(width: size.width * 0.015),
            SizedBox(
              width: size.width * 0.775,
              child: InAppText(
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
