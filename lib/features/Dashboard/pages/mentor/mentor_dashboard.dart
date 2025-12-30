import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Dashboard/pages/cubit/dashboard_cubit.dart';
import 'package:mistakes/global%20widgets/widgets/app_container_withshadow.dart';
import 'package:mistakes/global%20widgets/widgets/app_scaffold.dart';
import 'package:mistakes/global%20widgets/widgets/app_text.dart';
import 'package:mistakes/global%20widgets/widgets/appbar.dart';

class MentorDashboard extends StatelessWidget {
  const MentorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchDashboardCubit = context.watch<DashboardCubit>();
    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(title: 'My Mentees', size: size),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppshadowContainer(
                      border: true,
                      borderColor: AppColors.filledColor,
                      color: Colors.transparent,
                      width: size.width * 0.9,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          watchDashboardCubit.status.length,
                          (int index) => AppshadowContainer(
                            color:
                                watchDashboardCubit.selectedStatusIndex == index
                                ? AppColors.filledColor
                                : Colors.transparent,
                            onTap: () {
                              context.read<DashboardCubit>().changeStatus(
                                index,
                              );
                            },
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.015,
                              horizontal: size.width * 0.04,
                            ),
                            child: InAppText(
                              text: watchDashboardCubit.status[index],
                              color:
                                  watchDashboardCubit.selectedStatusIndex ==
                                      index
                                  ? AppColors.white
                                  : AppColors.grey,
                              fontweight: FontWeight.w500,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    AppshadowContainer(
                      onTap: () {
                        context.read<DashboardCubit>().setSelectedMenteeIndex(
                          0,
                        );
                        Navigator.pushNamed(context, Routename.menteeDashboard);
                      },
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
                                  InAppText(
                                    text: "Me Name",
                                    fontweight: FontWeight.w800,
                                    size: 18,
                                  ),
                                  InAppText(
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
                                    child: InAppText(
                                      text: "Active",
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InAppText(text: "Overall Progress"),
                                  InAppText(
                                    text: " 70%",
                                    fontweight: FontWeight.w800,
                                    color: AppColors.filledColor,
                                    size: 20,
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.012),
                              AppshadowContainer(
                                padding: EdgeInsets.zero,
                                alignment: Alignment.centerLeft,
                                height: size.height * 0.025,
                                width: size.width,
                                borderRadius: BorderRadius.circular(
                                  size.height * 0.02,
                                ),
                                color: AppColors.grey.withAlpha(40),
                                child: SizedBox(
                                  width: size.width * 0.7,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.filledColor,
                                      borderRadius: BorderRadius.circular(
                                        size.height * 0.02,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.012),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      InAppText(
                                        text: "0%",
                                        fontweight: FontWeight.w700,
                                      ),
                                      InAppText(
                                        text: "Goals",
                                        color: AppColors.grey,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InAppText(
                                        text: "0%",
                                        fontweight: FontWeight.w700,
                                      ),
                                      InAppText(
                                        text: "Hours",
                                        color: AppColors.grey,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InAppText(
                                        text: "0%",
                                        fontweight: FontWeight.w700,
                                      ),
                                      InAppText(
                                        text: "Skills",
                                        color: AppColors.grey,
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
