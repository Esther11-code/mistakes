import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Dashboard/data/local/dashboard_static_repo.dart';
import 'package:mistakes/features/Dashboard/pages/dashboard_setup.dart';
import 'package:mistakes/global%20widgets/widgets/app_container_withshadow.dart';
import 'package:mistakes/global%20widgets/widgets/app_scaffold.dart';
import 'package:mistakes/global%20widgets/widgets/app_text.dart';
import 'package:mistakes/global%20widgets/widgets/appbar.dart';


class MentorDashboard extends StatelessWidget {
  const MentorDashboard({super.key});

  @override
   Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(title: 'Dashboard', size: size),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppshadowContainer(
                      padding: EdgeInsets.all(size.width * 0.04),
                      shadowcolour: AppColors.lightgrey.withAlpha(100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: size.height * 0.04,
                                backgroundColor: AppColors.filledColor,
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
                                  SizedBox(height: size.height * 0.006),
                                  AppshadowContainer(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.03,
                                      // vertical: size.height * 0.009,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      size.width * 0.07,
                                    ),
                                    border: true,
                                    borderColor: AppColors.filledColor,
                                    color: AppColors.inactive,
                                    child: AppText(
                                      text: "3 months together",
                                      color: AppColors.background,
                                      fontweight: FontWeight.w500,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.02),
                          AppshadowContainer(
                            padding: EdgeInsets.all(size.width * 0.03),
                            color: AppColors.grey.withAlpha(25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(text: "Overall Progress"),
                                    AppText(
                                      text: " 70%",
                                      fontweight: FontWeight.w800,
                                      color: AppColors.filledColor,
                                      size: 20,
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * 0.02),
                                LinearProgressIndicator(
                                  value: 0.7,
                                  minHeight: size.height * 0.02,
                                  backgroundColor: AppColors.grey.withAlpha(40),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.filledColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DashboardOptions(size: size),
                        DashboardOptions(
                          size: size,
                          text: "Goals",
                          icon: Icons.track_changes,
                          onTap: () {
                            Navigator.pushNamed(context, Routename.goalSetUp);
                          },
                        ),
                        DashboardOptions(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routename.progressDashboard,
                            );
                          },
                          size: size,
                          text: "Progress",
                          icon: Icons.bar_chart,
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.02),
                    AppText(
                      color: AppColors.blue,
                      text: "Mentorship Stats",
                      size: 20,
                      fontweight: FontWeight.w700,
                    ),
                    SizedBox(height: size.height * 0.01),
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.74,
                        crossAxisSpacing: size.width * 0.04,
                        mainAxisSpacing: size.width * 0.04,
                      ),
                      itemCount: DashboardStaticRepo.stats.length,
                      itemBuilder: (context, index) {
                        return AppshadowContainer(
                          borderRadius: BorderRadius.circular(
                            size.width * 0.04,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, Routename.chat);
                          },
                          shadowcolour: AppColors.lightgrey.withAlpha(100),
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.02,
                            horizontal: size.width * 0.04,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText(
                                text: DashboardStaticRepo.stats[index].stat,
                                color: AppColors.background,
                                size: 22,
                                fontweight: FontWeight.w900,
                              ),
                              AppText(
                                text: DashboardStaticRepo.stats[index].title,
                                textAlign: TextAlign.center,
                                size: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    AppText(
                      text: "Recent Activity",
                      size: 18,
                      fontweight: FontWeight.w800,
                    ),
                    Column(
                      children: List.generate(
                        5,
                        (index) => AppshadowContainer(
                          shadowcolour: AppColors.lightgrey.withAlpha(50),
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.03,
                            vertical: size.width * 0.04,
                          ),
                          margin: EdgeInsets.symmetric(
                            vertical: size.width * 0.02,
                          ),
                          width: size.width,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: size.height * 0.03,
                                backgroundColor: AppColors.filledColor,
                                child: Icon(
                                  Icons.notifications,
                                  color: AppColors.white,
                                  size: 25.sp,
                                ),
                              ),
                              SizedBox(width: size.width * 0.03),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: 'Great Deals',
                                    color: AppColors.background,
                                    size: 20,
                                    fontweight: FontWeight.w700,
                                  ),
                                  AppText(
                                    text: '1h ago',
                                    size: 14,
                                    fontweight: FontWeight.w700,
                                    color: AppColors.blue.withAlpha(70),
                                  ),
                                ],
                              ),
                            ],
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
    );
  }
}
