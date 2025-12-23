import 'package:flutter/material.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../../../constants/utils/app_colors.dart';

class MentorshipRequest extends StatelessWidget {
  const MentorshipRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(title: 'Mentorship Requests', size: size),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: Column(
                  children: [
                    AppshadowContainer(
                      margin: EdgeInsets.only(bottom: size.height * 0.02),
                      padding: EdgeInsets.all(size.width * 0.04),
                      shadowcolour: AppColors.lightgrey.withAlpha(100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.filledColor,
                                radius: size.height * 0.04,
                                child: Icon(
                                  Icons.person,
                                  size: 30,
                                  color: AppColors.white,
                                ),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: "John Doe",
                                    size: 22,
                                    fontweight: FontWeight.w700,
                                  ),
                                  AppText(text: "Career Development"),
                                  AppText(
                                    text: "Requested 20th Aug 2024",
                                    size: 16,
                                    color: AppColors.grey,
                                  ),
                                ],
                              ),
                              AppshadowContainer(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.04,
                                  vertical: size.height * 0.01,
                                ),
                                border: true,
                                borderRadius: BorderRadius.circular(
                                  size.width * 0.1,
                                ),
                                borderColor: AppColors.orange.withAlpha(100),
                                color: AppColors.orange.withAlpha(75),
                                child: AppText(
                                  text: "New",
                                  color: AppColors.orange,
                                  fontweight: FontWeight.w500,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.01),
                          AppshadowContainer(
                            padding: EdgeInsets.all(size.width * 0.03),
                            color: AppColors.grey.withAlpha(25),
                            child: AppText(
                              text:
                                  "\"I would like to request mentorship on career development and skill enhancement.\"",
                              size: 16,
                            ),
                          ),
                          SizedBox(height: size.height * 0.015),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppButton(
                                buttonColor: AppColors.filledColor,

                                onTap: () {},
                                label: "Accept",
                                width: size.width * 0.40,
                              ),
                              SizedBox(width: size.width * 0.03),
                              AppButton(
                                border: true,
                                bordercolor: AppColors.errorColor,
                                buttonColor: AppColors.white,
                                onTap: () {},
                                label: "Decline",
                                width: size.width * 0.40,
                                labelColor: AppColors.errorColor,
                              ),
                            ],
                          ),
                        ],
                      ),
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
