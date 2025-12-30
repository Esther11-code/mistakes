import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/export.dart';

class MentorSettings extends StatelessWidget {
  const MentorSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(title: 'Settings', size: size),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.025),

                  // Mentorship Settings Section
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.blue.withAlpha(10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.handshake_outlined,
                          color: AppColors.blue,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: size.width * 0.03),
                      InAppText(
                        text: "Mentorship Settings",
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
                        // Accepting New Requests
                        Padding(
                          padding: EdgeInsets.all(size.width * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InAppText(
                                    text: "Accepting New Requests",
                                    size: 16,
                                    fontweight: FontWeight.w600,
                                    color: AppColors.blue,
                                  ),
                                  // Toggle Switch ON
                                  Container(
                                    width: 50,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.success,
                                          AppColors.success.withAlpha(180),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.success.withAlpha(50),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          right: 2,
                                          top: 2,
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              InAppText(
                                text: "Turn off to stop receiving new mentorship requests",
                                size: 13,
                                color: AppColors.grey,
                                maxline: 2,
                              ),
                            ],
                          ),
                        ),

                        // Divider
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                          child: Container(
                            height: 1,
                            color: AppColors.inactive,
                          ),
                        ),

                        // Max Active Mentees with Slider
                        Padding(
                          padding: EdgeInsets.all(size.width * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InAppText(
                                    text: "Max Active Mentees",
                                    size: 16,
                                    fontweight: FontWeight.w600,
                                    color: AppColors.blue,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.035,
                                      vertical: size.height * 0.006,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.success,
                                          AppColors.success.withAlpha(180),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: InAppText(
                                      text: "5",
                                      size: 18,
                                      fontweight: FontWeight.w700,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.015),
                              SliderTheme(
                                data: SliderThemeData(
                                  activeTrackColor: AppColors.success,
                                  inactiveTrackColor: AppColors.inactive,
                                  thumbColor: AppColors.success,
                                  overlayColor: AppColors.success.withAlpha(50),
                                  trackHeight: 4,
                                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
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
                              InAppText(
                                text: "Currently: 5 active mentees",
                                size: 13,
                                color: AppColors.grey,
                              ),
                            ],
                          ),
                        ),

                        // Divider
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                          child: Container(
                            height: 1,
                            color: AppColors.inactive,
                          ),
                        ),

                        // Auto-Reply to Requests
                        Padding(
                          padding: EdgeInsets.all(size.width * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InAppText(
                                    text: "Auto-Reply to Requests",
                                    size: 16,
                                    fontweight: FontWeight.w600,
                                    color: AppColors.blue,
                                  ),
                                  // Toggle Switch OFF
                                  Container(
                                    width: 50,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: AppColors.inactive,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 2,
                                          top: 2,
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.1),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              InAppText(
                                text: "Send automatic response when you can't accept new mentees",
                                size: 13,
                                color: AppColors.grey,
                                maxline: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  // Notifications Section
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
                          color: Colors.purple.shade400,
                          size: 20,
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
                        // New Requests
                        Padding(
                          padding: EdgeInsets.all(size.width * 0.04),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InAppText(
                                text: "New Requests",
                                size: 16,
                                fontweight: FontWeight.w500,
                                color: AppColors.blue,
                              ),
                              Container(
                                width: 50,
                                height: 28,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.success,
                                      AppColors.success.withAlpha(180),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      right: 2,
                                      top: 2,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                          child: Container(height: 1, color: AppColors.inactive),
                        ),

                        // Mentee Messages
                        Padding(
                          padding: EdgeInsets.all(size.width * 0.04),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InAppText(
                                text: "Mentee Messages",
                                size: 16,
                                fontweight: FontWeight.w500,
                                color: AppColors.blue,
                              ),
                              Container(
                                width: 50,
                                height: 28,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.success,
                                      AppColors.success.withAlpha(180),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      right: 2,
                                      top: 2,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                          child: Container(height: 1, color: AppColors.inactive),
                        ),

                        // Goal Completions
                        Padding(
                          padding: EdgeInsets.all(size.width * 0.04),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InAppText(
                                text: "Goal Completions",
                                size: 16,
                                fontweight: FontWeight.w500,
                                color: AppColors.blue,
                              ),
                              Container(
                                width: 50,
                                height: 28,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.success,
                                      AppColors.success.withAlpha(180),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      right: 2,
                                      top: 2,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  // Account Section
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.account_circle_outlined,
                          color: AppColors.orange,
                          size: 20,
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
                        // Change Password
                        InkWell(
                          onTap: () {
                            // Navigate to change password
                          },
                          child: Padding(
                            padding: EdgeInsets.all(size.width * 0.04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.blue.withAlpha(10),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.lock_outline,
                                        color: AppColors.blue,
                                        size: 20,
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.03),
                                    InAppText(
                                      text: "Change Password",
                                      size: 16,
                                      fontweight: FontWeight.w500,
                                      color: AppColors.blue,
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

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                          child: Container(height: 1, color: AppColors.inactive),
                        ),

                        // Log Out
                        InkWell(
                          onTap: () {
                            // Log out logic
                          },
                          child: Padding(
                            padding: EdgeInsets.all(size.width * 0.04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.errorColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.logout,
                                        color: AppColors.errorColor,
                                        size: 20,
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.03),
                                    InAppText(
                                      text: "Log Out",
                                      size: 16,
                                      fontweight: FontWeight.w500,
                                      color: AppColors.errorColor,
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
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}