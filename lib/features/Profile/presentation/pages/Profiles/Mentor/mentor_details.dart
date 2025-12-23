import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Home/presentation/pages/home.dart';
import 'package:mistakes/global%20widgets/export.dart';

class MentorDetails extends StatelessWidget {
  const MentorDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(size: size, title: "Mentor Details"),
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
                                AppText(
                                  text: "4.8 (100+ reviews)",
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
                                  AppText(
                                    text: "24",
                                    color: AppColors.blue,
                                    size: 18,
                                    fontweight: FontWeight.w600,
                                  ),
                                  AppText(text: "Mentees", size: 16),
                                ],
                              ),
                              Column(
                                children: [
                                  AppText(
                                    text: "5yrs",
                                    color: AppColors.blue,
                                    size: 18,
                                    fontweight: FontWeight.w600,
                                  ),
                                  AppText(text: "Experience", size: 16),
                                ],
                              ),
                              Column(
                                children: [
                                  AppText(
                                    text: "95%",
                                    color: AppColors.blue,
                                    size: 18,
                                    fontweight: FontWeight.w600,
                                  ),
                                  AppText(text: "Success", size: 16),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    AppText(
                      text: "About Mentor",
                      size: 20,
                      fontweight: FontWeight.w600,
                    ),
                    SizedBox(height: size.height * 0.01),
                    AppshadowContainer(
                      color: AppColors.white,
                      padding: EdgeInsets.all(size.width * 0.03),
                      shadowcolour: AppColors.lightgrey.withAlpha(100),
                      child: AppText(
                        textAlign: TextAlign.justify,
                        maxline: 10,
                        text:
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",

                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    AppText(
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
                        7,
                        (index) => IntrinsicWidth(
                          // Add this
                          child: AppshadowContainer(
                            radius: size.height * 0.05,
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                              vertical: size.height * 0.01,
                            ),
                            border: true,
                            borderColor: AppColors.background,
                            color: AppColors.inactive,
                            child: AppText(
                              text: "HTML",
                              color: AppColors.blue,
                              fontweight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, Routename.allReviews),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: 'Reviews',
                            color: AppColors.blue,
                            fontweight: FontWeight.w500,
                            size: 21,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              Routename.allReviews,
                            ),
                            child: const AppText(text: 'View All', size: 16),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.01),
                    Column(
                      children: List.generate(
                        3,
                        (index) => ReviewsContainer(size: size),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    AppButton(
                      onTap: () {
                        Navigator.pushNamed(context, Routename.bookingSuccess);
                      },
                      border: true,
                      bordercolor: AppColors.blue,
                      buttonColor: AppColors.background,
                      width: size.width * 0.9,
                      height: size.height * 0.06,
                      textSize: 18,
                      label: "Save to Favorites",
                      labelColor: AppColors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AppButton(
            onTap: () {
              Navigator.pushNamed(context, Routename.requestMentorship);
            },
            buttonColor: AppColors.blue,
            width: size.width * 0.9,
            height: size.height * 0.06,
            textSize: 18,
            label: "Request Mentor",
          ),

          SizedBox(height: size.height * 0.03),
        ],
      ),
    );
  }
}

class ReviewsContainer extends StatelessWidget {
  const ReviewsContainer({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      color: AppColors.white,
      padding: EdgeInsets.all(size.width * 0.03),
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      shadowcolour: AppColors.lightgrey.withAlpha(100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: size.height * 0.025,
                backgroundColor: AppColors.filledColor,
                child: Icon(Icons.person, size: 20.sp, color: AppColors.white),
              ),
              SizedBox(width: size.width * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "User Name",
                    size: 16,
                    color: AppColors.blue,
                    fontweight: FontWeight.w600,
                  ),
                  AppText(
                    text: "2 days ago",
                    size: 14,
                    color: AppColors.blue.withAlpha(100),
                  ),
                ],
              ),
              Spacer(),
              Icon(Icons.star, size: 20.sp, color: AppColors.yellow),
              AppText(
                text: "4.5",
                size: 16,
                color: AppColors.blue,
                fontweight: FontWeight.w600,
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),

          SizedBox(height: size.height * 0.01),
          AppDivider(),
          SizedBox(height: size.height * 0.01),
          AppText(
            text:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",

            color: AppColors.blackColor,
          ),
          SizedBox(height: size.height * 0.01),
        ],
      ),
    );
  }
}
