import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/page%20route/page_route.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/export.dart';

class ProfileSetUp extends StatelessWidget {
  const ProfileSetUp({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppScaffold(
      color: AppColors.background,
      body: Column(
        children: [
          CustomAppbar(
            onTap: () =>
                Navigator.popAndPushNamed(context, Routename.bottomNav),
            title: "Profile",
            containerColor: Colors.transparent,
            shadowColor: Colors.transparent,
            iconColor1: AppColors.white,
            iconColor2: AppColors.white,
            textColor: AppColors.white,
          ),
          SizedBox(height: size.height * 0.18),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // White container with inward curve
                ClipPath(
                  clipper: InwardCurveClipper(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: AppColors.white),
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height * 0.12,
                        ), // Space for floating container
                        // Your other content goes here
                        AppText(
                          text: "Set up your profile",
                          color: AppColors.blue,
                          size: 20,
                          fontweight: FontWeight.w600,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ProfileSettingWidget(
                                  size: size,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routename.changePassword,
                                    );
                                  },
                                ),
                                ProfileSettingWidget(
                                  size: size,
                                  label: "Edit Interests",
                                  icon: CupertinoIcons.pencil,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routename.editInterests,
                                    );
                                  },
                                ),
                                ProfileSettingWidget(
                                  size: size,
                                  label: "Appointment and History",
                                  icon: CupertinoIcons.clock,
                                ),
                                ProfileSettingWidget(
                                  size: size,
                                  label: "Privacy Policy",
                                  icon: CupertinoIcons.shield_lefthalf_fill,
                                ),
                              ],
                            ),
                          ),
                        ),
                        AppButton(
                          onTap: () {
                            // Navigate to next page or perform action
                          },

                          buttonColor: Colors.red[700],
                          label: 'Log Out',
                        ),
                        SizedBox(height: size.height * 0.05),
                      ],
                    ),
                  ),
                ),
                // Floating white container
                Positioned(
                  top: -100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AppshadowContainer(
                      color: AppColors.white,
                      height: size.height * 0.2,
                      width: size.width * 0.9,
                      shadowcolour: AppColors.lightgrey.withAlpha(100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: size.height * 0.04,
                          ), // Space for circular avatar
                          AppText(
                            text: "Hello User",
                            color: AppColors.blue,
                            size: 20,
                            fontweight: FontWeight.w600,
                          ),
                          AppText(
                            text: "Set up your profile",
                            color: AppColors.blue,
                            size: 14,
                          ),
                          AppText(
                            text: "I am Interested in Technology",
                            color: AppColors.blue,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Circular avatar on top of white container
                Positioned(
                  top:
                      -size.height *
                      0.17, // Half of avatar size above the white container
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: size.height * 0.13,
                      height: size.height * 0.13,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: size.width * 0.005,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.lightgrey.withAlpha(100),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Icon(
                          Icons.person,
                          size: size.height * 0.06,
                          color: AppColors.blue,
                        ),
                        // Or use an image:
                        // child: Image.network(
                        //   'profile_image_url',
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileSettingWidget extends StatelessWidget {
  const ProfileSettingWidget({
    super.key,
    required this.size,
    this.label,
    this.icon,
    this.onTap,
  });

  final Size size;
  final String? label;
  final IconData? icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size.width * 0.02),
      shadowcolour: AppColors.lightgrey.withAlpha(100),
      border: true,
      borderColor: AppColors.background,
      padding: EdgeInsets.all(size.width * 0.03),
      margin: EdgeInsets.only(top: size.height * 0.02),
      color: AppColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AppshadowContainer(
                color: AppColors.white,
                shadowcolour: AppColors.lightgrey.withAlpha(100),
                padding: EdgeInsets.all(size.width * 0.02),
                child: Icon(
                  icon ?? Icons.lock,
                  size: 30.sp,
                  color: AppColors.blue,
                ),
              ),
              SizedBox(width: size.width * 0.03),
              AppText(
                text: label ?? "Change Password",
                color: AppColors.blue,
                fontweight: FontWeight.w500,
              ),
            ],
          ),
          Icon(
            CupertinoIcons.chevron_right,
            size: 25.sp,
            color: AppColors.blue,
            weight: size.width * 0.05,
          ),
        ],
      ),
    );
  }
}

// Custom clipper for inward curve at the top
class InwardCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0); // Start at top left

    // Create inward curve using quadratic bezier
    path.quadraticBezierTo(
      size.width / 2,
      80, // Control point (dips down in the middle)
      size.width,
      0, // End point at top right
    );

    path.lineTo(size.width, size.height); // Right side
    path.lineTo(0, size.height); // Bottom
    path.close(); // Back to start
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
