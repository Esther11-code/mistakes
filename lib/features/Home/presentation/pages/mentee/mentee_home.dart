import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Home/presentation/pages/home.dart';
import 'package:mistakes/features/Home/presentation/widgets/src/home_appbar.dart';
import 'package:mistakes/global%20widgets/export.dart';

class MenteeHome extends StatelessWidget {
  const MenteeHome({super.key});

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
