import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../../../constants/utils/app_colors.dart' show AppColors;

class MyRequest extends StatelessWidget {
  const MyRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(
            title: 'My Request',
            size: size,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  10,
                  (index) => MyRequestContainer(size: size),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyRequestContainer extends StatelessWidget {
  const MyRequestContainer({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      margin: EdgeInsets.symmetric(
        vertical: size.height * 0.01,
        horizontal: size.width * 0.04,
      ),
      padding: EdgeInsets.all(size.width * 0.04),
      shadowcolour: AppColors.lightgrey.withAlpha(100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppshadowContainer(
                padding: EdgeInsets.all(size.width * 0.02),
                width: size.width * 0.15,
                height: size.width * 0.15,
                color: AppColors.filledColor,
                child: Icon(
                  Icons.person,
                  color: AppColors.white,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: "Mentor Name",
                    fontweight: FontWeight.w800,
                    size: 18,
                  ),
                  AppText(
                    text: "Mentor Name",
                    fontweight: FontWeight.w500,
                    size: 16,
                  ),
                  AppText(
                    text: "Requested on 2 days ago",
                    fontweight: FontWeight.w400,
                    color: AppColors.blue.withAlpha(100),
                    size: 16,
                  ),
                ],
              ),
              AppshadowContainer(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.height * 0.009,
                ),
                borderRadius: BorderRadius.circular(
                  size.width * 0.07,
                ),
                border: true,
                borderColor: AppColors.orange.withAlpha(100),
                color: AppColors.orange.withAlpha(75),
                child: AppText(
                  text: "Ongoing",
                  color: AppColors.orange,
                  fontweight: FontWeight.w500,
                  size: 16,
                ),
              ),
            ],
          ),
          AppshadowContainer(
            margin: EdgeInsets.only(top: size.height * 0.02),
            padding: EdgeInsets.all(size.width * 0.03),
            color: AppColors.grey.withAlpha(40),
            child: AppText(
              text:
                  "\"I would like to improve my skills in UI/UX design and learn more about user research methodologies.\"",
              size: 16,
              fontweight: FontWeight.w400,
            ),
          ),
          AppshadowContainer(
            margin: EdgeInsets.only(top: size.height * 0.02),
            padding: EdgeInsets.all(size.width * 0.02),
            color: AppColors.green.withAlpha(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info,
                  color: AppColors.success,
                  size: 20.sp,
                ),
                SizedBox(width: size.width * 0.02),
                AppText(
                  color: AppColors.success,
                  text:
                      "Your request is being reviewed by mentor.",
                  size: 16,
                  fontweight: FontWeight.w400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
