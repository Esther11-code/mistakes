import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mistakes/config/page%20route/page_route.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Goal/pages/cubit/goal_cubit.dart';
import 'package:mistakes/features/Profile/presentation/pages/Profiles/Mentor/mentor_account.dart';
import 'package:mistakes/features/Profile/presentation/pages/profile.dart';
import 'package:mistakes/global%20widgets/export.dart';
import '../../../../../../constants/utils/app_colors.dart';

class MenteeAccount extends StatelessWidget {
  const MenteeAccount({super.key});
  void showImagePicker(BuildContext context) {
    final readAuthCubit = context.read<AuthenticationCubit>();
    final size = MediaQuery.sizeOf(context);

    showModalBottomSheet(
      backgroundColor: AppColors.white,
      barrierColor: Colors.transparent,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        return Container(
          color: AppColors.white,
          padding: EdgeInsets.all(size.width * 0.04),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.blue),
                title: InAppText(
                  text: 'Take Photo',
                  size: 18,
                  color: AppColors.blue,
                ),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await Future.delayed(Duration(milliseconds: 300));
                  if (context.mounted) {
                    await readAuthCubit.pickImage(context, ImageSource.camera);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.blue),
                title: InAppText(
                  text: 'Choose from Gallery',
                  size: 18,
                  color: AppColors.lightblack,
                ),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await Future.delayed(Duration(milliseconds: 300));
                  if (context.mounted) {
                    await readAuthCubit.pickImage(context, ImageSource.gallery);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchAuthcubit = context.watch<AuthenticationCubit>();
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AddDetailsLoaded) {
          context.read<AuthenticationCubit>().updateProfileDetails();
        }
        if (state is AuthLogoutState) {
          Fluttertoast.showToast(
            msg: "Logout Successfully",
            gravity: ToastGravity.TOP,
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routename.login,
            (route) => false,
          );
        }
      },
      child: AppScaffold(
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
                          SizedBox(height: size.height * 0.12),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(size.width * 0.03),
                                decoration: BoxDecoration(
                                  color: AppColors.blue.withAlpha(10),
                                  borderRadius: BorderRadius.circular(
                                    size.width * 0.03,
                                  ),
                                ),
                                child: Icon(
                                  Icons.settings_outlined,
                                  color: AppColors.blue,
                                  size: 25.sp,
                                ),
                              ),
                              SizedBox(width: size.width * 0.03),
                              InAppText(
                                text: "Account Settings",
                                size: 20,
                                fontweight: FontWeight.w700,
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.03),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  AppshadowContainer(
                                    padding: EdgeInsets.zero,
                                    color: AppColors.white,
                                    shadowcolour: AppColors.grey.withAlpha(50),
                                    child: Column(
                                      children: [
                                        SettingsTile(
                                          size: size,
                                          icon: Icons.interests_outlined,
                                          label: "Edit Interests",
                                          color: Colors.purple.shade400,
                                          onTap: () {
                                            context
                                                .read<GoalCubit>()
                                                .loadInterests();
                                            Navigator.pushNamed(
                                              context,
                                              Routename.editInterests,
                                            );
                                          },
                                        ),
                                        SettingsDivider(size: size),
                                        SettingsTile(
                                          size: size,
                                          icon: Icons.lock_outline,
                                          label: "Change Password",
                                          color: Colors.orange.shade400,
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              Routename.changePassword,
                                            );
                                          },
                                        ),
                                        SettingsDivider(size: size),
                                        SettingsTile(
                                          size: size,
                                          icon: Icons.bar_chart,
                                          label: "Progress Dashboard",
                                          color: Colors.green.shade400,
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              Routename.progressDashboard,
                                            );
                                          },
                                        ),
                                        SettingsDivider(size: size),
                                        SettingsTile(
                                          size: size,
                                          icon: Icons.emoji_events_outlined,
                                          label: "Achievement History",
                                          color: Colors.yellow.shade700,
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              Routename.achievementHistory,
                                            );
                                          },
                                        ),
                                        SettingsDivider(size: size),
                                        SettingsTile(
                                          size: size,
                                          icon: Icons.shield_outlined,
                                          label: "Privacy Policy",
                                          color: AppColors.grey,
                                          onTap: () {
                                            // Navigator.pushNamed(context, Routename.privacyPolicy);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.025),
                                  AppButton(
                                    onTap: () {
                                      showDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: AppColors.white,

                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.all(
                                            size.width * 0.06,
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color: AppColors.errorColor
                                                      .withAlpha(10),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.logout,
                                                  size: 50,
                                                  color: AppColors.errorColor,
                                                ),
                                              ),
                                              SizedBox(
                                                height: size.height * 0.02,
                                              ),
                                              InAppText(
                                                text: 'Log Out',
                                                fontweight: FontWeight.w700,
                                                size: 22,
                                                color: AppColors.blue,
                                              ),
                                              SizedBox(
                                                height: size.height * 0.01,
                                              ),
                                              InAppText(
                                                text:
                                                    'Are you sure you want to log out of your account?',

                                                textAlign: TextAlign.center,
                                                color: AppColors.lightblack,
                                              ),
                                              SizedBox(
                                                height: size.height * 0.03,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: AppButton(
                                                      onTap: () =>
                                                          Navigator.pop(
                                                            context,
                                                          ),
                                                      label: 'Cancel',
                                                      buttonColor: AppColors
                                                          .grey
                                                          .withAlpha(30),
                                                      labelColor:
                                                          AppColors.blackColor,
                                                      textSize: 17,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: size.width * 0.03,
                                                  ),
                                                  Expanded(
                                                    child: AppButton(
                                                      isLoading:
                                                          context
                                                                  .watch<
                                                                    AuthenticationCubit
                                                                  >()
                                                                  .state
                                                              is AuthLoadingState,
                                                      onTap: () {
                                                        final readAuthCubit =
                                                            context
                                                                .read<
                                                                  AuthenticationCubit
                                                                >();
                                                        Future.delayed(
                                                          const Duration(
                                                            milliseconds: 500,
                                                          ),
                                                          () {
                                                            readAuthCubit
                                                                .logout();
                                                          },
                                                        );

                                                        Navigator.pop(context);
                                                      },
                                                      label: 'Log Out',
                                                      buttonColor:
                                                          AppColors.errorColor,
                                                      textSize: 17,
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
                                  ),
                                  SizedBox(height: size.height * 0.03),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 16,
                                            color: AppColors.grey,
                                          ),
                                          SizedBox(width: 8),
                                          InAppText(
                                            text: "MentorVerse v1.0.0",
                                            size: 13,
                                            color: AppColors.grey,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      InAppText(
                                        text: "© 2024 All Rights Reserved",
                                        size: 12,
                                        color: AppColors.grey,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.025),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.03),
                        ],
                      ),
                    ),
                  ),
                  // Floating white container
                  Positioned(
                    top: -100,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => showImagePicker(context),
                      child: Center(
                        child: AppshadowContainer(
                          color: AppColors.white,
                          height: size.height * 0.2,
                          width: size.width * 0.9,
                          shadowcolour: AppColors.lightgrey.withAlpha(100),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: size.height * 0.04),
                              InAppText(
                                text:
                                    watchAuthcubit.user.name ?? "Esther Enyia",
                                size: 22,
                                fontweight: FontWeight.w700,
                              ),
                              SizedBox(height: size.height * 0.01),
                              InAppText(
                                text:
                                    watchAuthcubit.user.email ??
                                    "esther.eny@email.com",
                                color: AppColors.lightblack,
                                size: 16,
                              ),
                              SizedBox(height: size.height * 0.01),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.04,
                                  vertical: size.height * 0.006,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.grey.withAlpha(10),
                                  borderRadius: BorderRadius.circular(
                                    size.width * 0.03,
                                  ),
                                  border: Border.all(
                                    color: AppColors.blue.withAlpha(50),
                                  ),
                                ),
                                child: InAppText(
                                  text:
                                      "Interested in ${watchAuthcubit.user.expertise ?? "Mentoring"}",
                                  fontweight: FontWeight.w600,
                                  size: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -size.height * 0.19,
                    left: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () => showImagePicker(context),
                      child: Center(
                        child: Stack(
                          children: [
                            Container(
                              width: size.height * 0.15,
                              height: size.height * 0.15,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.filledColor,
                                    AppColors.background,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.grey.withAlpha(30),
                                    blurRadius: 15,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () => showImagePicker(context),
                                child: Container(
                                  margin: EdgeInsets.all(size.width * 0.009),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.white,
                                  ),
                                  child:
                                      watchAuthcubit.user.profilePhotoUrl !=
                                          null
                                      ? InkWell(
                                          onTap: () => showImagePicker(context),
                                          child: AppNetwokImage(
                                            height: size.height * 0.15,
                                            width: size.height * 0.15,
                                            imageUrl:
                                                watchAuthcubit
                                                    .user
                                                    .profilePhotoUrl ??
                                                "",
                                            isCircular: true,
                                          ),
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: size.height * 0.06,
                                          color: AppColors.background,
                                        ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: size.height * 0.001,
                              right: size.width * 0.02,
                              child: GestureDetector(
                                onTap: () => showImagePicker(context),
                                child: Container(
                                  padding: EdgeInsets.all(size.width * 0.03),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.background,
                                        AppColors.lightgrey,
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.grey.withAlpha(30),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () => showImagePicker(context),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: AppColors.white,
                                      size: 19.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final Size size;

  const SettingsTile({
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
              padding: EdgeInsets.all(size.width * 0.03),
              decoration: BoxDecoration(
                color: color.withAlpha(10),
                borderRadius: BorderRadius.circular(size.width * 0.02),
              ),
              child: Icon(icon, color: color, size: 25.sp),
            ),
            SizedBox(width: size.width * 0.04),
            Expanded(
              child: InAppText(text: label, fontweight: FontWeight.w500),
            ),
            Icon(Icons.arrow_forward_ios, size: 20.sp, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}
