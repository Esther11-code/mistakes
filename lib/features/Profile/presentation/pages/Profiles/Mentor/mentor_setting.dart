import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Home/presentation/pages/home.dart';
import 'package:mistakes/global%20widgets/export.dart';

class MentorSettings extends StatelessWidget {
  const MentorSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(
            title: 'Settings',
            size: size,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.025),
                    AppshadowContainer(
                      padding: EdgeInsets.zero,
                      color: AppColors.white,
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InAppText(
                                    text: "Accepting New Requests",
                                    fontweight: FontWeight.w600,
                                  ),
                                  Switch(
                                    activeColor: AppColors.background,
                                    value: true,
                                    onChanged: (value) {},
                                  ),
                                ],
                              ),
                              InAppText(
                                text:
                                    "Turn off to stop receiving new mentorship requests",
                                size: 16,
                                color: AppColors.grey,
                                maxline: 2,
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.02),
                          AppDivider(),
                          SizedBox(height: size.height * 0.02),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InAppText(
                                    text: "Max Active Mentees",

                                    fontweight: FontWeight.w600,
                                  ),
                                  AppshadowContainer(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.035,
                                      vertical: size.height * 0.006,
                                    ),
                                    color: AppColors.filledColor,
                                    child: InAppText(
                                      text: "5",
                                      size: 18,
                                      fontweight: FontWeight.w700,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.01),
                              SliderTheme(
                                data: SliderThemeData(
                                  padding: EdgeInsets.zero,
                                  activeTrackColor: AppColors.filledColor,
                                  inactiveTrackColor: AppColors.inactive,
                                  thumbColor: AppColors.filledColor,
                                  overlayColor: AppColors.filledColor.withAlpha(
                                    50,
                                  ),
                                  trackHeight: 4,
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 10,
                                  ),
                                ),
                                child: Slider(
                                  value: 5,
                                  min: 1,
                                  max: 10,
                                  divisions: 9,
                                  onChanged: (value) {
                                    // Handle slider change with Cubit
                                  },
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                              InAppText(
                                text: "Currently: 5 active mentees",
                                size: 16,
                                color: AppColors.grey,
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.025),
                          AppDivider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InAppText(
                                text: "Auto-Reply to Requests",

                                fontweight: FontWeight.w600,
                              ),
                              Switch(
                                activeColor: AppColors.background,
                                value: false,
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                          InAppText(
                            text:
                                "Send automatic response when you can't accept new mentees",
                            size: 15,
                            color: AppColors.grey,
                            maxline: 2,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(size.width * 0.02),
                          decoration: BoxDecoration(
                            color: Colors.purple.withAlpha(10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.notifications_outlined,
                            color: Colors.purple.shade400,
                            size: 25.sp,
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        InAppText(
                          text: "Notifications",
                          size: 20,
                          fontweight: FontWeight.w700,
                          color: AppColors.blue,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.015),
                    AppshadowContainer(
                      padding: EdgeInsets.zero,
                      color: AppColors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InAppText(
                                text: "New Requests",

                                fontweight: FontWeight.w500,
                                color: AppColors.blue,
                              ),
                              Switch(
                                activeColor: AppColors.background,
                                value: false,
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                          AppDivider(),
                          SizedBox(height: size.height * 0.015),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InAppText(
                                text: "Mentee Messages",

                                fontweight: FontWeight.w500,
                                color: AppColors.blue,
                              ),
                              Switch(
                                activeColor: AppColors.background,
                                value: true,
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.015),
                          AppDivider(),
                          SizedBox(height: size.height * 0.015),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InAppText(
                                text: "Goal Completions",

                                fontweight: FontWeight.w500,
                                color: AppColors.blue,
                              ),
                              Switch(
                                activeColor: AppColors.background,
                                value: true,
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.035),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(size.width * 0.02),
                          decoration: BoxDecoration(
                            color: AppColors.orange.withAlpha(10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.account_circle_outlined,
                            color: AppColors.orange,
                            size: 25.sp,
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        InAppText(
                          text: "Account",
                          size: 20,
                          fontweight: FontWeight.w700,
                          color: AppColors.blue,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.015),
                    AppshadowContainer(
                      padding: EdgeInsets.zero,
                      color: AppColors.white,
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.02),
                          GestureDetector(
                            onTap: () {
                              // Navigate to change password
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                        size.width * 0.02,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.blue.withAlpha(10),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.lock_outline,
                                        color: AppColors.blue,
                                        size: 25.sp,
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.03),
                                    InAppText(
                                      text: "Change Password",
                                      fontweight: FontWeight.w500,
                                      color: AppColors.blue,
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20.sp,
                                  color: AppColors.grey,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.015),
                          AppDivider(),
                          SizedBox(height: size.height * 0.025),
                          GestureDetector(
                            onTap: () {
                              // Log out logic
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                        size.width * 0.02,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.errorColor.withAlpha(
                                          10,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.logout,
                                        color: AppColors.errorColor,
                                        size: 25.sp,
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.03),
                                    InAppText(
                                      text: "Log Out",
                                      fontweight: FontWeight.w500,
                                      color: AppColors.errorColor,
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20.sp,
                                  color: AppColors.grey,
                                ),
                              ],
                            ),
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
        ],
      ),
    );
  }
}
