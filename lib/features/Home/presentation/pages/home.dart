import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/features/Home/data/local/images/home_image.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../constants/utils/app_colors.dart';
import '../widgets/src/home_appbar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeAppbar(size: size),
          SizedBox(height: size.height * 0.025),
          // const AppDivider(),
          SizedBox(height: size.height * 0.02),
          HomeCarousel(size: size),
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: const ApptextField(
              size: 21,
              title: 'What do you need?',
              prefixIcon: Icons.search,
              hintText: 'Example : Mentors, Years..',
            ),
          ),
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'Suggested Mentors',
                  color: AppColors.blue,
                  fontweight: FontWeight.w500,
                  size: 21,
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, Routename.allMentors),
                  child: const AppText(text: 'View All', size: 16),
                ),
              ],
            ),
          ),
          10.verticalSpace,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(5, (index) => MentorList(size: size)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MentorList extends StatelessWidget {
  const MentorList({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      onTap: () => Navigator.pushNamed(context, Routename.mentorDetails),
      shadowcolour: AppColors.inactive.withAlpha(100),
      border: true,
      color: AppColors.white,
      borderColor: AppColors.background.withAlpha(100),
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.01,
      ),
      padding: EdgeInsets.all(size.width * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppshadowContainer(
                    child: Image.asset(
                      HomeImages.avatar,
                      height: size.height * 0.08,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.yellow, size: 25.sp),
                      5.horizontalSpace,
                      const AppText(
                        text: '4.8',
                        size: 16,
                        fontweight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(width: size.width * 0.009),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    text: 'Chineye Okafor',
                    fontweight: FontWeight.w500,
                    size: 20,
                  ),
                  Row(
                    children: [
                      const AppText(text: 'Graphic Designer', size: 18),
                      SizedBox(width: size.width * 0.02),
                      const AppText(text: '4yrs Exp.', size: 18),
                    ],
                  ),
                  SizedBox(height: size.width * 0.01),
                  AppButton(
                    onTap: () {
                      Navigator.pushNamed(context, Routename.mentorDetails);
                    },
                    buttonColor: AppColors.background,
                    width: size.width * 0.6,
                    height: size.height * 0.05,
                    label: "View Profile",
                  ),
                ],
              ),
            ],
          ),
          Icon(Icons.favorite, color: AppColors.errorColor, size: 25.sp),
        ],
      ),
    );
  }
}

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      color: Colors.transparent,
      radius: 1000.r,
      shadowcolour: AppColors.lightgrey.withAlpha(50),
      child: Divider(
        color: AppColors.grey.withAlpha(100),
        thickness: 2.0,
        height: 6.0,
      ),
    );
  }
}
