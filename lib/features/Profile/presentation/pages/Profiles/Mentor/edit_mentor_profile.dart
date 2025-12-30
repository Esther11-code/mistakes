import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Goal/pages/Goals/add_goal.dart';
import 'package:mistakes/global%20widgets/export.dart';

class EditMentorProfile extends StatelessWidget {
  const EditMentorProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(
            title: 'Edit Profile',
            size: size,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.03),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: size.width * 0.3,
                        height: size.width * 0.3,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.grey.withAlpha(50),
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                          ),
                          child: Center(
                            child: Text(
                              'JD',
                              style: GoogleFonts.ptSans(
                                fontSize: 40.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 5,
                        child: Container(
                          padding: EdgeInsets.all(size.width * 0.02),
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.blue.withAlpha(100),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.025),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Display Name',
                          style: GoogleFonts.ptSans(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blue,
                          ),
                          children: [
                            TextSpan(
                              text: '*',
                              style: GoogleFonts.ptSans(
                                color: Colors.red,
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
                          prefixIconn: Icon(
                            Icons.person_outline,
                            color: AppColors.blue,
                            size: 20.sp,
                          ),

                          hintText: "Enter your name",
                        ),
                      ),
                      SizedBox(height: size.height * 0.015),
                      Text.rich(
                        TextSpan(
                          text: 'Title',
                          style: GoogleFonts.ptSans(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blue,
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
                          hintText: "e.g., Senior Software Engineer",

                          prefixIconn: Icon(
                            Icons.work_outline,
                            color: AppColors.blue,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.015),
                      Text.rich(
                        TextSpan(
                          text: 'About',
                          style: GoogleFonts.ptSans(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blue,
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
                          maxLine: 5,
                          hintText: "Tell others about yourself...",
                        ),
                      ),
                      SizedBox(height: size.height * 0.015),
                      InAppText(
                        text: "Years of Experience",
                        size: 20,
                        fontweight: FontWeight.w600,
                        color: AppColors.blue,
                      ),
                      SizedBox(height: size.height * 0.012),
                      AppshadowContainer(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                          vertical: size.height * 0.005,
                        ),
                        color: AppColors.white,
                        child: ApptextField(
                          keyboardType: TextInputType.number,

                          hintText: "e.g., 5",

                          prefixIconn: Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.blue,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.025),
                      InAppText(
                        text: "Skills",
                        size: 20,
                        fontweight: FontWeight.w600,
                        color: AppColors.blue,
                      ),
                      SizedBox(height: size.height * 0.008),
                      InAppText(
                        text: "Separate skills with commas",
                        size: 16,
                        color: AppColors.grey,
                      ),
                      AppshadowContainer(
                        padding: EdgeInsets.all(size.width * 0.04),
                        color: AppColors.white,
                        child: ApptextField(
                          maxLine: 3,
                          hintText:
                              "e.g., React, Node.js, JavaScript, System Design",
                        ),
                      ),

                      SizedBox(height: size.height * 0.035),
                      InfoBar(
                        size: size,
                        icon: Icons.info_outline,
                        text:
                            "A complete profile helps mentees find and connect with you more easily..Make sure to save your changes.",
                      ),
                      SizedBox(height: size.height * 0.03),
                      AppButton(
                        onTap: () {
                          // Save logic
                        },
                        width: size.width,
                        buttonColor: AppColors.blue,
                        label: 'Save Changes',
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

                      SizedBox(height: size.height * 0.03),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
