import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/export.dart';

class RequestDetails extends StatelessWidget {
  const RequestDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppbarWidget(
            title: 'Request Details',
            size: size,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.02),
                  AppshadowContainer(
                    width: size.width,
                    padding: EdgeInsets.all(size.width * 0.05),
                    shadowcolour: AppColors.lightgrey.withAlpha(100),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.pink.shade300,
                                Colors.red.shade400,
                              ],
                            ),
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Center(
                            child: Text(
                              'SJ',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.015),
                        InAppText(
                          text: "Sarah Johnson",
                          size: 24,
                          fontweight: FontWeight.w700,
                          color: AppColors.blue,
                        ),
                        SizedBox(height: size.height * 0.005),
                        InAppText(
                          text: "Aspiring Developer",
                          size: 16,
                          color: AppColors.blue.withAlpha(90),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.04,
                            vertical: size.height * 0.008,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.blue.withAlpha(10),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16.sp,
                                color: AppColors.blue,
                              ),
                              SizedBox(width: 5),
                              InAppText(
                                text: "Requested 2 hours ago",
                                size: 14,
                                color: AppColors.blue,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.blue.withAlpha(10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: AppColors.blue,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: size.width * 0.03),
                      InAppText(
                        text: "About Sarah",
                        size: 20,
                        fontweight: FontWeight.w700,
                        color: AppColors.blue,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.015),
                  AppshadowContainer(
                    padding: EdgeInsets.all(size.width * 0.05),
                    shadowcolour: AppColors.grey.withAlpha(50),
                    color: AppColors.white,
                    child: InAppText(
                      maxline: 10,
                      text:
                          "Recent graduate with a degree in Computer Science. Currently building projects to break into the tech industry. Passionate about web development and eager to learn from experienced developers.",
                      color: AppColors.lightblack,
                    ),
                  ),

                  SizedBox(height: size.height * 0.025),

                  // Why Section
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.inactive,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          color: AppColors.filledColor,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: size.width * 0.03),
                      InAppText(
                        text: "Why She Wants You",
                        size: 20,
                        fontweight: FontWeight.w700,
                        color: AppColors.blue,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.015),
                  AppshadowContainer(
                    padding: EdgeInsets.all(size.width * 0.05),
                    color: AppColors.inactive,
                    child: InAppText(
                      text:
                          "\"Hi John! I'm an aspiring software developer looking to break into React development. I've been following your articles on Medium and I'm impressed by your teaching style. I'm committed to putting in the work and would love your guidance on my journey to becoming a professional developer!\"",

                      color: AppColors.lightblack,
                    ),
                  ),

                  SizedBox(height: size.height * 0.025),

                  // Goals Section
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.flag_outlined,
                          color: Colors.green.shade600,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: size.width * 0.03),
                      InAppText(
                        text: "Her Goals",
                        size: 20,
                        fontweight: FontWeight.w700,
                        color: AppColors.blue,
                      ),
                    ],
                  ),
                  AppshadowContainer(
                    padding: EdgeInsets.all(size.width * 0.04),
                    color: AppColors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(size.width * 0.02),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.green.shade700,
                                size: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: size.width * 0.03),
                            Expanded(
                              child: InAppText(
                                text: "Learn React fundamentals",

                                color: AppColors.lightblack,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.015),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.green.shade700,
                                size: 22.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: size.width * 0.03),
                            Expanded(
                              child: InAppText(
                                text: "Build portfolio website",

                                color: AppColors.lightblack,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.015),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.green.shade700,
                                size: 25.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: size.width * 0.03),
                            Expanded(
                              child: InAppText(
                                text: "Land first developer job",

                                color: AppColors.lightblack,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.025),

                  // Interests Section
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.blue.withAlpha(10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.interests,
                          color: AppColors.filledColor,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: size.width * 0.03),
                      InAppText(
                        text: "Interests",
                        size: 20,
                        fontweight: FontWeight.w700,
                        color: AppColors.blue,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.015),
                  Wrap(
                    spacing: size.width * 0.025,
                    runSpacing: size.height * 0.012,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                          vertical: size.height * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.inactive,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blue.withAlpha(30),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: InAppText(
                          text: "Web Dev",
                          fontweight: FontWeight.w500,
                          color: AppColors.lightblack,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                          vertical: size.height * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.inactive,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blue.withAlpha(30),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: InAppText(
                          text: "React",
                          fontweight: FontWeight.w500,
                          color: AppColors.lightblack,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                          vertical: size.height * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.inactive,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blue.withAlpha(30),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: InAppText(
                          text: "JavaScript",
                          fontweight: FontWeight.w500,
                          color: AppColors.lightblack,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.04),
                  AppButton(
                    onTap: () {
                      Navigator.pushNamed(context, Routename.acceptMentorship);
                    },
                    width: size.width,
                    buttonColor: AppColors.background,
                    label: 'Accept Sarah as Mentee',
                    textSize: 17,
                  ),
                  SizedBox(height: size.height * 0.015),
                  AppButton(
                    onTap: () {
                      // Decline logic
                    },
                    width: size.width,
                    bordercolor: AppColors.errorColor,
                    label: 'Decline Request',
                    labelColor: AppColors.errorColor,
                    buttonColor: Colors.transparent,
                    textSize: 17,
                  ),

                  SizedBox(height: size.height * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
