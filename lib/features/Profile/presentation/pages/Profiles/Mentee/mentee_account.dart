import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/export.dart';

class MenteeAccount extends StatelessWidget {
  const MenteeAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    /*************  ✨ Windsurf Command ⭐  *************/
    /// Builds a screen with a floating white container on top of it.
    ///
    /// The floating container has an inward curve and contains a
    /// circular avatar and a text describing the user.
    ///
    /// Below the floating container, there are several settings
    /// widgets that can be used to set up the user's profile.
    ///
    /// The bottom of the screen has a log out button.
    /*******  b63a96e4-01ce-49c1-8596-6c830a55218b  *******/
    return AppScaffold(
      body: Column(
        children: [
          // Header with gradient
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: size.width * 0.04,
              right: size.width * 0.04,
              bottom: size.height * 0.02,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.blue, AppColors.filledColor],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InAppText(
                  text: "My Profile",
                  size: 24,
                  fontweight: FontWeight.w700,
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, Routename.bottomNav);
                  },
                  icon: Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Card
                  Transform.translate(
                    offset: Offset(0, -30),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                      ),
                      child: AppshadowContainer(
                        width: size.width,
                        padding: EdgeInsets.all(size.width * 0.05),
                        shadowcolour: AppColors.blue.withAlpha(50),
                        child: Column(
                          children: [
                            // Avatar with edit button
                            Stack(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.blue,
                                        AppColors.filledColor,
                                        AppColors.active,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.blue.withAlpha(100),
                                        blurRadius: 15,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.white,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                        color: AppColors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.blue,
                                          AppColors.filledColor,
                                        ],
                                      ),
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
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.02),
                            InAppText(
                              text: "John Doe",
                              size: 24,
                              fontweight: FontWeight.w700,
                              color: AppColors.blue,
                            ),
                            SizedBox(height: 4),
                            InAppText(
                              text: "john.doe@email.com",
                              size: 15,
                              color: AppColors.grey,
                            ),
                            SizedBox(height: size.height * 0.015),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.04,
                                vertical: size.height * 0.008,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.blue.withAlpha(10),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.blue.withAlpha(50),
                                ),
                              ),
                              child: InAppText(
                                text: "Interested in Technology",
                                size: 13,
                                fontweight: FontWeight.w600,
                                color: AppColors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Settings Section
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InAppText(
                          text: "Account Settings",
                          size: 20,
                          fontweight: FontWeight.w700,
                          color: AppColors.blue,
                        ),
                        SizedBox(height: size.height * 0.015),

                        AppshadowContainer(
                          padding: EdgeInsets.zero,
                          color: AppColors.white,
                          child: Column(
                            children: [
                              SettingTile(
                                icon: Icons.person_outline,
                                label: "Edit Profile",
                                color: AppColors.blue,
                                onTap: () {
                                  // Navigate to edit profile
                                },
                                size: size,
                              ),
                              Divider(height: 1, color: AppColors.inactive),
                              SettingTile(
                                icon: Icons.interests_outlined,
                                label: "Edit Interests",
                                color: Colors.purple.shade400,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routename.editInterests,
                                  );
                                },
                                size: size,
                              ),
                              Divider(height: 1, color: AppColors.inactive),
                              SettingTile(
                                icon: Icons.lock_outline,
                                label: "Change Password",
                                color: Colors.orange.shade400,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routename.changePassword,
                                  );
                                },
                                size: size,
                              ),
                              Divider(height: 1, color: AppColors.inactive),
                              SettingTile(
                                icon: Icons.bar_chart,
                                label: "Progress Dashboard",
                                color: Colors.green.shade400,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routename.progressDashboard,
                                  );
                                },
                                size: size,
                              ),
                              Divider(height: 1, color: AppColors.inactive),
                              SettingTile(
                                icon: Icons.emoji_events_outlined,
                                label: "Achievement History",
                                color: Colors.yellow.shade700,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routename.achievementHistory,
                                  );
                                },
                                size: size,
                              ),
                              Divider(height: 1, color: AppColors.inactive),
                              SettingTile(
                                icon: Icons.shield_outlined,
                                label: "Privacy Policy",
                                color: AppColors.grey,
                                onTap: () {
                                  // Navigate to privacy policy
                                },
                                size: size,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: size.height * 0.03),

                        // Log Out Button
                        AppButton(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                contentPadding: EdgeInsets.all(
                                  size.width * 0.06,
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      size: 60,
                                      color: AppColors.errorColor,
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                    InAppText(
                                      text: 'Log Out?',
                                      fontweight: FontWeight.w700,
                                      size: 22,
                                      color: AppColors.blue,
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    InAppText(
                                      text: 'Are you sure you want to log out?',
                                      size: 15,
                                      textAlign: TextAlign.center,
                                      color: AppColors.grey,
                                    ),
                                    SizedBox(height: size.height * 0.03),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AppButton(
                                            onTap: () => Navigator.pop(context),
                                            label: 'Cancel',
                                            buttonColor: AppColors.inactive,
                                            labelColor: AppColors.blue,
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.03),
                                        Expanded(
                                          child: AppButton(
                                            onTap: () {
                                              // Log out logic
                                            },
                                            label: 'Log Out',
                                            buttonColor: AppColors.errorColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          buttonColor: AppColors.errorColor,
                          label: 'Log Out',
                          width: size.width,
                          textSize: 17,
                        ),

                        SizedBox(height: size.height * 0.03),
                      ],
                    ),
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

// Setting Tile Widget
class SettingTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final Size size;

  const SettingTile({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(width: size.width * 0.04),
            Expanded(
              child: InAppText(
                text: label,
                size: 16,
                fontweight: FontWeight.w500,
                color: AppColors.blue,
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}
