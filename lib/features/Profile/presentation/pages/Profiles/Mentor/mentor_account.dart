import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Dashboard/pages/cubit/dashboard_cubit.dart';
import 'package:mistakes/features/Home/presentation/pages/home.dart';
import 'package:mistakes/global%20widgets/export.dart';

class MentorAccount extends StatelessWidget {
  const MentorAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    return AppScaffold(
      body: Column(
        children: [
          CustomAppbar(
            onTap: () =>
                Navigator.popAndPushNamed(context, Routename.bottomNav),
            title: "Profile",
            shadowColor: AppColors.grey.withAlpha(50),
            iconColor1: AppColors.background,
            iconColor2: AppColors.background,
          ),
          SizedBox(height: size.height * 0.03),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppshadowContainer(
                      color: AppColors.white,
                      padding: EdgeInsets.all(size.width * 0.03),
                      shadowcolour: AppColors.lightgrey.withAlpha(100),
                      child: Column(
                        children: [
                          watchAuthCubit.user.profilePhotoUrl != null
                              ? AppNetwokImage(
                                  height: size.width * 0.3,
                                  width: size.width * 0.3,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      watchAuthCubit.user.profilePhotoUrl ?? "",
                                  isCircular: true,
                                )
                              : CircleAvatar(
                                  backgroundColor: AppColors.filledColor,
                                  radius: size.height * 0.07,
                                  child: Icon(
                                    Icons.person,
                                    size: 50.sp,
                                    color: AppColors.white,
                                  ),
                                ),
                          SizedBox(height: size.height * 0.02),
                          InAppText(
                            text: watchAuthCubit.user.name ?? "Mentor Name",
                            size: 20,
                            fontweight: FontWeight.bold,
                          ),
                          InAppText(
                            text:
                                watchAuthCubit.user.expertise ??
                                "Mentor Expertise",
                            size: 16,
                          ),
                          SizedBox(height: size.height * 0.02),
                          AppshadowContainer(
                            alignment: Alignment.center,
                            color: AppColors.inactive,
                            border: true,
                            borderColor: AppColors.background,
                            width: size.width * 0.5,
                            padding: EdgeInsets.all(size.width * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: AppColors.yellow,
                                  size: 20.sp,
                                ),
                                InAppText(
                                  text: "Expert",
                                  size: 16,
                                  color: AppColors.blue,
                                  fontweight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          AppDivider(),
                          SizedBox(height: size.height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  InAppText(
                                    text: context
                                        .watch<DashboardCubit>()
                                        .allMentees
                                        .length
                                        .toString(),
                                    color: AppColors.blue,
                                    size: 18,
                                    fontweight: FontWeight.w600,
                                  ),
                                  InAppText(text: "Mentees", size: 16),
                                ],
                              ),
                              Column(
                                children: [
                                  InAppText(
                                    text:
                                        "${watchAuthCubit.user.yearsExperience ?? 0} yrs",
                                    color: AppColors.blue,
                                    size: 18,
                                    fontweight: FontWeight.w600,
                                  ),
                                  InAppText(text: "Experience", size: 16),
                                ],
                              ),
                              Column(
                                children: [
                                  InAppText(
                                    text: "95%",
                                    color: AppColors.blue,
                                    size: 18,
                                    fontweight: FontWeight.w600,
                                  ),
                                  InAppText(text: "Success", size: 16),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.02),
                          AppButton(
                            textSize: 18,
                            label: "Edit Profile",
                            buttonColor: AppColors.blue,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routename.editMentorProfile,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    InAppText(
                      text: "About Mentor",
                      size: 20,
                      fontweight: FontWeight.w600,
                    ),
                    SizedBox(height: size.height * 0.01),
                    AppshadowContainer(
                      color: AppColors.white,
                      padding: EdgeInsets.all(size.width * 0.03),
                      shadowcolour: AppColors.lightgrey.withAlpha(100),
                      child: InAppText(
                        textAlign: TextAlign.justify,
                        maxline: 10,
                        text:
                            watchAuthCubit.user.bio ??
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    InAppText(
                      text: "Skills & Expertise",
                      size: 20,
                      fontweight: FontWeight.w600,
                    ),
                    SizedBox(height: size.height * 0.01),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: size.width * 0.02,
                      runSpacing: size.height * 0.02,
                      children: List.generate(
                        watchAuthCubit.user.interests?.length ?? 0,
                        (index) => IntrinsicWidth(
                          child: AppshadowContainer(
                            radius: size.height * 0.05,
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                              vertical: size.height * 0.01,
                            ),
                            border: true,
                            borderColor: AppColors.background,
                            color: AppColors.inactive,
                            child: InAppText(
                              text: watchAuthCubit.user.interests?[index] ?? "",
                              color: AppColors.blue,
                              fontweight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routename.mentorSettings);
                      },
                      child: Row(
                        children: [
                          InAppText(
                            text: "Settings",
                            size: 20,
                            fontweight: FontWeight.w600,
                          ),
                          Spacer(),
                          InAppText(text: "View All", size: 16),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    AppshadowContainer(
                      padding: EdgeInsets.zero,
                      color: AppColors.white,
                      shadowcolour: AppColors.lightgrey.withAlpha(100),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(size.width * 0.04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                        size.width * 0.03,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.success.withAlpha(10),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.notifications_active_outlined,
                                        color: AppColors.success,
                                        size: 25.sp,
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.03),
                                    InAppText(
                                      text: "Accepting Requests",
                                      fontweight: FontWeight.w500,
                                      color: AppColors.blue,
                                    ),
                                  ],
                                ),
                                Switch(
                                  activeThumbColor: AppColors.success,
                                  value: true,
                                  onChanged: (value) {},
                                ),
                              ],
                            ),
                          ),
                          SettingsDivider(size: size),
                          Padding(
                            padding: EdgeInsets.all(size.width * 0.04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                        size.width * 0.03,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.blue.withAlpha(10),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.group_outlined,
                                        color: AppColors.blue,
                                        size: 25.sp,
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.03),
                                    InAppText(
                                      text: "Max Active Mentees",
                                      fontweight: FontWeight.w500,
                                      color: AppColors.blue,
                                    ),
                                  ],
                                ),
                                AppshadowContainer(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.04,
                                    vertical: size.height * 0.008,
                                  ),
                                  color: AppColors.blue,
                                  child: InAppText(
                                    text: "5",
                                    size: 18,
                                    fontweight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SettingsDivider(size: size),
                          Padding(
                            padding: EdgeInsets.all(size.width * 0.04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                        size.width * 0.03,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.orange.withAlpha(10),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.lock_outline,
                                        color: AppColors.orange,
                                        size: 25.sp,
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.03),
                                    InAppText(
                                      text: "Privacy Settings",
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
                          SettingsDivider(size: size),
                          Padding(
                            padding: EdgeInsets.all(size.width * 0.04),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routename.notification,
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(
                                          size.width * 0.03,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.purple.withAlpha(10),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      child: Container(height: 1, color: AppColors.inactive),
    );
  }
}
