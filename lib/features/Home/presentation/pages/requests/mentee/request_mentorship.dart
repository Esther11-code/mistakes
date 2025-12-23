import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';

import '../../../../../../constants/utils/app_colors.dart';
import '../../../../../../global widgets/export.dart';

class RequestMentorship extends StatelessWidget {
  const RequestMentorship({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(
            size: size,
            title: "Request Mentorship",
            onTap: () => Navigator.pop(context),
          ),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(
                  children: [
                    AppshadowContainer(
                      color: AppColors.white,
                      padding: EdgeInsets.all(size.width * 0.03),
                      shadowcolour: AppColors.lightgrey.withAlpha(100),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.filledColor,

                            radius: size.height * 0.07,

                            child: Icon(
                              Icons.person,
                              size: 50.sp,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          AppText(
                            text: "Mentor Name",
                            size: 20,
                            fontweight: FontWeight.bold,
                          ),
                          AppText(text: "Mentor Expertise", size: 16),
                          SizedBox(height: size.height * 0.009),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    AppshadowContainer(
                      shadowcolour: AppColors.lightgrey.withAlpha(100),
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.02,
                        horizontal: size.width * 0.04,
                      ),
                      child: ApptextField(
                        labelColor: AppColors.blue,
                        size: 16,
                        title: "Describe your mentorship needs",
                        maxLine: 5,
                        hintText: "I would like to improve my skills in...",
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    AppshadowContainer(
                      padding: EdgeInsets.all(size.width * 0.03),
                      shadowcolour: AppColors.lightgrey.withAlpha(100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: "My Goals",
                            fontweight: FontWeight.w700,
                            size: 20,
                          ),
                          SizedBox(height: size.height * 0.01),
                          Wrap(
                            spacing: size.width * 0.02,
                            runSpacing: size.height * 0.01,

                            children: List.generate(
                              4,
                              (index) => AppshadowContainer(
                                border: true,
                                borderColor: AppColors.filledColor,
                                padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.008,
                                  horizontal: size.width * 0.03,
                                ),
                                color: AppColors.filledColor.withAlpha(50),
                                child: AppText(
                                  text: "Goal ${index + 1}",
                                  color: AppColors.filledColor,
                                  fontweight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    AppButton(
                      onTap: () {
                        Navigator.pushNamed(context, Routename.myRequests);
                      },
                      label: "Send Request",
                      buttonColor: AppColors.filledColor,
                      width: size.width * 0.9,
                    ),
                    SizedBox(height: size.height * 0.01),
                    AppButton(
                      onTap: () {
                        // Handle request mentorship action
                      },
                      label: "Cancel Request",
                      buttonColor: AppColors.errorColor,
                      width: size.width * 0.9,
                    ),
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
