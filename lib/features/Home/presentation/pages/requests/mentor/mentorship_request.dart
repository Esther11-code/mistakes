import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
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
                    // Request Card
                    AppshadowContainer(
                      onTap: () {
                        Navigator.pushNamed(context, Routename.requestDetails);
                      },
                      margin: EdgeInsets.only(bottom: size.height * 0.02),
                      padding: EdgeInsets.all(size.width * 0.04),
                      shadowcolour: AppColors.blue.withAlpha(50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Row: Avatar, Info, and Badge
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Gradient Avatar
                              Container(
                                width: size.height * 0.08,
                                height: size.height * 0.08,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.blue,
                                      AppColors.filledColor,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.blue.withAlpha(50),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'JD',
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: size.width * 0.03),

                              // Name and Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: InAppText(
                                            text: "John Doe",
                                            size: 20,
                                            fontweight: FontWeight.w700,
                                            color: AppColors.blue,
                                          ),
                                        ),
                                        // New Badge
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.03,
                                            vertical: size.height * 0.006,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.orange,
                                                AppColors.orange.withAlpha(180),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.orange
                                                    .withAlpha(50),
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.fiber_new,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 4),
                                              InAppText(
                                                text: "New",
                                                color: AppColors.white,
                                                fontweight: FontWeight.w600,
                                                size: 13,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.work_outline,
                                          size: 16,
                                          color: AppColors.filledColor,
                                        ),
                                        SizedBox(width: 5),
                                        InAppText(
                                          text: "Career Development",
                                          size: 15,
                                          fontweight: FontWeight.w500,
                                          color: AppColors.filledColor,
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 14,
                                          color: AppColors.grey,
                                        ),
                                        SizedBox(width: 5),
                                        InAppText(
                                          text: "Requested 20th Aug 2024",
                                          size: 14,
                                          color: AppColors.grey,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: size.height * 0.015),
                          Container(height: 1, color: AppColors.inactive),

                          SizedBox(height: size.height * 0.015),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.blue.withAlpha(10),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.format_quote,
                                  size: 18,
                                  color: AppColors.blue,
                                ),
                              ),
                              SizedBox(width: size.width * 0.03),
                              Expanded(
                                child: InAppText(
                                  text:
                                      "I would like to request mentorship on career development and skill enhancement.",
                                  size: 15,
                                  color: AppColors.lightblack,
                                  maxline: 3,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: size.height * 0.02),
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  buttonColor: AppColors.success,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routename.acceptMentorship,
                                    );
                                  },
                                  label: "Accept",
                                  textSize: 16,
                                ),
                              ),
                              SizedBox(width: size.width * 0.03),
                              Expanded(
                                child: AppButton(
                                  border: true,
                                  bordercolor: AppColors.errorColor,
                                  buttonColor: AppColors.white,
                                  onTap: () {},
                                  label: "Decline",
                                  labelColor: AppColors.errorColor,
                                  textSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Second Request Example (Different styling)
                    AppshadowContainer(
                      onTap: () {
                        Navigator.pushNamed(context, Routename.requestDetails);
                      },
                      margin: EdgeInsets.only(bottom: size.height * 0.02),
                      padding: EdgeInsets.all(size.width * 0.04),
                      shadowcolour: AppColors.lightgrey.withAlpha(100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Different gradient for variety
                              Container(
                                width: size.height * 0.08,
                                height: size.height * 0.08,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.purple.shade400,
                                      Colors.pink.shade400,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.purple.withAlpha(50),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'SJ',
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: size.width * 0.03),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InAppText(
                                      text: "Sarah Johnson",
                                      size: 20,
                                      fontweight: FontWeight.w700,
                                      color: AppColors.blue,
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.code,
                                          size: 16,
                                          color: AppColors.filledColor,
                                        ),
                                        SizedBox(width: 5),
                                        InAppText(
                                          text: "Web Development",
                                          size: 15,
                                          fontweight: FontWeight.w500,
                                          color: AppColors.filledColor,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 14,
                                          color: AppColors.grey,
                                        ),
                                        SizedBox(width: 5),
                                        InAppText(
                                          text: "Requested 19th Aug 2024",
                                          size: 14,
                                          color: AppColors.grey,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: size.height * 0.015),

                          Container(height: 1, color: AppColors.inactive),

                          SizedBox(height: size.height * 0.015),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.blue.withAlpha(10),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.format_quote,
                                  size: 18,
                                  color: AppColors.blue,
                                ),
                              ),
                              SizedBox(width: size.width * 0.03),
                              Expanded(
                                child: InAppText(
                                  text:
                                      "Hi! I'm passionate about learning React and would love guidance from an experienced developer like you.",
                                  size: 15,
                                  color: AppColors.lightblack,
                                  maxline: 3,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: size.height * 0.02),

                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  buttonColor: AppColors.success,
                                  onTap: () {},
                                  label: "Accept",
                                  textSize: 16,
                                ),
                              ),
                              SizedBox(width: size.width * 0.03),
                              Expanded(
                                child: AppButton(
                                  border: true,
                                  bordercolor: AppColors.errorColor,
                                  buttonColor: AppColors.white,
                                  onTap: () {},
                                  label: "Decline",
                                  labelColor: AppColors.errorColor,
                                  textSize: 16,
                                ),
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
