import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/features/Home/presentation/widgets/src/home_appbar.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../../constants/utils/app_colors.dart';
import '../../../../Dashboard/data/local/dashboard_static_repo.dart';

class MentorHome extends StatelessWidget {
  const MentorHome({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeAppbar(size: size),
          SizedBox(height: size.height * 0.025),
          GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
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
                borderRadius: BorderRadius.circular(size.width * 0.04),
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
          10.verticalSpace,

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Recent Activities",
                      size: 21,
                      fontweight: FontWeight.w700,
                    ),
                    SizedBox(height: size.height * 0.02),
                    Column(
                      children: List.generate(
                        5,
                        (index) => AppshadowContainer(
                          color: AppColors.background,
                          margin: EdgeInsets.only(bottom: size.height * 0.02),
                          child: AppshadowContainer(
                            padding: EdgeInsets.all(size.width * 0.02),
                            color: AppColors.inactive,
                            margin: EdgeInsets.only(left: size.width * 0.025),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      text: "Goal Set",
                                      fontweight: FontWeight.w700,
                                      size: 20,
                                    ),

                                    AppText(
                                      text: "Today",
                                      color: AppColors.blue.withAlpha(100),
                                      size: 16,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: size.width * 0.775,
                                  child: AppText(
                                    text:
                                        "Set SMART goals: Specific, Measurable, Achievable, Relevant, Time-bound",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    AppText(
                      text: "This Week's Tasks",
                      size: 21,
                      fontweight: FontWeight.w700,
                    ),
                    SizedBox(height: size.height * 0.02),
                    AppshadowContainer(
                      margin: EdgeInsets.only(bottom: size.height * 0.02),
                      padding: EdgeInsets.all(size.width * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppCheckbox(
                                status: false,
                                // width: size.width * 0.05,
                                // height: size.width * 0.05,
                              ),
                              SizedBox(width: size.width * 0.03),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: "Goal Review",
                                    fontweight: FontWeight.w500,
                                    size: 20,
                                  ),
                                  Row(
                                    children: [
                                      AppText(
                                        text: "Due: ",
                                        color: AppColors.grey,
                                        size: 16,
                                      ),
                                      AppText(
                                        text: "Friday, 25th August 2024",
                                        color: AppColors.grey,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ],
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
