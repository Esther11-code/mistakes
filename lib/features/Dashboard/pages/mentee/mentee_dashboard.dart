import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/global%20widgets/widgets/app_button.dart';
import 'package:mistakes/global%20widgets/widgets/app_container_withshadow.dart';
import 'package:mistakes/global%20widgets/widgets/app_scaffold.dart';
import 'package:mistakes/global%20widgets/widgets/app_text.dart';
import 'package:mistakes/global%20widgets/widgets/appbar.dart';
import '../../data/local/dashboard_static_repo.dart';

class MenteeDashboard extends StatelessWidget {
  const MenteeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isRole = context.watch<AuthenticationCubit>().user.role;

    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(title: 'Dashboard', size: size),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.025),
                  Container(
                    width: size.width,
                    padding: EdgeInsets.all(size.width * 0.05),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.background, AppColors.filledColor],
                      ),
                      borderRadius: BorderRadius.circular(size.width * 0.04),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey.withAlpha(50),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: size.height * 0.08,
                              height: size.height * 0.08,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.white,
                                  width: 3,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.blue,
                                  size: 30.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: size.width * 0.04),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InAppText(
                                    text: "Stella Sofia",
                                    fontweight: FontWeight.w800,
                                    size: 20,
                                    color: AppColors.white,
                                  ),
                                  SizedBox(height: size.height * 0.005),
                                  InAppText(
                                    text: "Senior Developer",
                                    fontweight: FontWeight.w500,
                                    size: 15,
                                    color: AppColors.white,
                                  ),
                                  SizedBox(height: size.height * 0.005),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.03,
                                      vertical: size.height * 0.006,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(20),
                                      borderRadius: BorderRadius.circular(
                                        size.width * 0.02,
                                      ),
                                      border: Border.all(
                                        color: Colors.white.withAlpha(30),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 6),
                                        InAppText(
                                          text: "3 months together",
                                          color: AppColors.white,
                                          fontweight: FontWeight.w600,
                                          size: 13,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.025),
                        Container(
                          padding: EdgeInsets.all(size.width * 0.04),
                          decoration: BoxDecoration(
                            color: AppColors.white.withAlpha(15),
                            borderRadius: BorderRadius.circular(
                              size.width * 0.03,
                            ),
                            border: Border.all(
                              color: AppColors.white.withAlpha(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InAppText(
                                    text: "Overall Progress",
                                    color: AppColors.white,

                                    fontweight: FontWeight.w600,
                                  ),
                                  InAppText(
                                    text: "70%",
                                    fontweight: FontWeight.w900,
                                    color: AppColors.white,
                                    size: 22,
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.015),
                              Container(
                                height: size.height * 0.01,
                                width: size.width,
                                decoration: BoxDecoration(
                                  color: AppColors.blue.withAlpha(70),
                                  borderRadius: BorderRadius.circular(
                                    size.width * 0.03,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    FractionallySizedBox(
                                      widthFactor: 0.7,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.white,
                                              AppColors.white.withAlpha(90),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            size.width * 0.03,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      QuickActionCard(
                        size: size,
                        icon: Icons.message_outlined,
                        label: "Messages",
                        color: Colors.blue.shade400,
                        onTap: () {
                          Navigator.pushNamed(context, Routename.chatSetup);
                        },
                      ),
                      QuickActionCard(
                        size: size,
                        icon: Icons.track_changes,
                        label: "Goals",
                        color: Colors.purple.shade400,
                        onTap: () {
                          Navigator.pushNamed(context, Routename.goalSetUp);
                        },
                      ),
                      QuickActionCard(
                        size: size,
                        icon: Icons.bar_chart,
                        label: "Progress",
                        color: Colors.orange.shade400,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routename.progressDashboard,
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.03),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(size.width * 0.04),
                        decoration: BoxDecoration(
                          color: AppColors.blue.withAlpha(10),
                          borderRadius: BorderRadius.circular(
                            size.width * 0.03,
                          ),
                        ),
                        child: Icon(
                          Icons.analytics_outlined,
                          color: AppColors.blue,
                          size: 25.sp,
                        ),
                      ),
                      SizedBox(width: size.width * 0.03),
                      InAppText(
                        text: "Mentorship Stats",
                        size: 20,
                        fontweight: FontWeight.w700,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.015),

                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: size.width * 0.03,
                      mainAxisSpacing: size.height * 0.015,
                    ),
                    itemCount: DashboardStaticRepo.stats.length,
                    itemBuilder: (context, index) {
                      final statColors = [
                        [Colors.blue.shade400, Colors.blue.shade600],
                        [Colors.purple.shade400, Colors.purple.shade600],
                        [Colors.orange.shade400, Colors.orange.shade600],
                        [Colors.green.shade400, Colors.green.shade600],
                      ];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routename.chat);
                        },
                        child: Container(
                          padding: EdgeInsets.all(size.width * 0.04),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: statColors[index % statColors.length],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: statColors[index % statColors.length][0]
                                    .withAlpha(30),
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InAppText(
                                text: DashboardStaticRepo.stats[index].stat,
                                color: AppColors.white,
                                size: 30,
                                fontweight: FontWeight.w900,
                              ),
                              SizedBox(height: 4),
                              InAppText(
                                text: DashboardStaticRepo.stats[index].title,
                                textAlign: TextAlign.center,

                                fontweight: FontWeight.w600,
                                color: AppColors.white,
                                maxline: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  if (isRole == "Mentor") ...[
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(size.width * 0.03),
                          decoration: BoxDecoration(
                            color: Colors.green.withAlpha(10),
                            borderRadius: BorderRadius.circular(
                              size.width * 0.03,
                            ),
                          ),
                          child: Icon(
                            Icons.flag_outlined,
                            color: Colors.green.shade600,
                            size: 25.sp,
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        InAppText(
                          text: "Recent Goals",
                          size: 20,
                          fontweight: FontWeight.w700,
                          color: AppColors.blue,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.015),
                    AppshadowContainer(
                      padding: EdgeInsets.all(size.width * 0.04),
                      shadowcolour: AppColors.blue.withAlpha(50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: InAppText(
                                  text: "Master Flutter Development",
                                  fontweight: FontWeight.w700,
                                  size: 19,
                                  color: AppColors.blue,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.03,
                                  vertical: size.height * 0.006,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.shade400,
                                      Colors.green.shade600,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: InAppText(
                                  text: "Active",
                                  color: Colors.white,
                                  fontweight: FontWeight.w700,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.015),
                          Container(
                            height: size.height * 0.001,
                            color: AppColors.inactive,
                          ),
                          SizedBox(height: size.height * 0.015),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InAppText(
                                text: "Progress",
                                size: 15,
                                color: AppColors.grey,
                              ),
                              InAppText(
                                text: "70%",
                                fontweight: FontWeight.w800,
                                color: AppColors.filledColor,
                                size: 20,
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.012),
                          Container(
                            height: size.height * 0.015,
                            decoration: BoxDecoration(
                              color: AppColors.inactive,
                              borderRadius: BorderRadius.circular(
                                size.width * 0.03,
                              ),
                            ),
                            child: Stack(
                              children: [
                                FractionallySizedBox(
                                  widthFactor: 0.7,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.filledColor,
                                          AppColors.blue,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          AppButton(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routename.mentorFeedback,
                              );
                            },
                            label: "Add Feedback",
                            buttonColor: AppColors.filledColor,
                            textSize: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (isRole == "Mentee") ...[
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(size.width * 0.04),
                          decoration: BoxDecoration(
                            color: AppColors.orange.withAlpha(10),
                            borderRadius: BorderRadius.circular(
                              size.width * 0.03,
                            ),
                          ),
                          child: Icon(
                            Icons.history,
                            color: AppColors.orange,
                            size: 25.sp,
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        InAppText(
                          text: "Activity",
                          size: 20,
                          fontweight: FontWeight.w700,
                          color: AppColors.blue,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.015),
                    Column(
                      children: List.generate(5, (index) {
                        final activityIcons = [
                          Icons.check_circle_outline,
                          Icons.message_outlined,
                          Icons.book_outlined,
                          Icons.emoji_events_outlined,
                          Icons.feedback_outlined,
                        ];
                        final activityColors = [
                          Colors.green.shade400,
                          Colors.blue.shade400,
                          Colors.purple.shade400,
                          Colors.orange.shade400,
                          Colors.pink.shade400,
                        ];
                        final activities = [
                          'Goal Completed',
                          'New Message',
                          'Resource Shared',
                          'Achievement Unlocked',
                          'Feedback Received',
                        ];

                        return AppshadowContainer(
                          onTap: () {
                            if (index == 0) {
                              Navigator.pushNamed(context, Routename.goalSetUp);
                            } else if (index == 2) {
                              // Navigator.pushNamed(context, Routename.resourcesShared);
                            } else if (index == 4) {
                              Navigator.pushNamed(
                                context,
                                Routename.mentorFeedback,
                              );
                            } else if (index == 1) {
                              Navigator.pushNamed(context, Routename.chat);
                            }
                          },
                          shadowcolour: AppColors.lightgrey.withAlpha(50),
                          padding: EdgeInsets.all(size.width * 0.04),
                          margin: EdgeInsets.only(bottom: size.height * 0.012),
                          child: Row(
                            children: [
                              Container(
                                width: size.height * 0.06,
                                height: size.height * 0.06,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      activityColors[index],
                                      activityColors[index].withAlpha(70),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: activityColors[index].withAlpha(
                                        30,
                                      ),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  activityIcons[index],
                                  color: Colors.white,
                                  size: 24.sp,
                                ),
                              ),
                              SizedBox(width: size.width * 0.04),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InAppText(
                                      text: activities[index],
                                      color: AppColors.blue,
                                      size: 19,
                                      fontweight: FontWeight.w700,
                                    ),
                                    SizedBox(height: 4),
                                    InAppText(
                                      text: '${index + 1}h ago',
                                      size: 16,
                                      fontweight: FontWeight.w500,
                                      color: AppColors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 20.sp,
                                color: AppColors.grey,
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],

                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Quick Action Card Widget
class QuickActionCard extends StatelessWidget {
  final Size size;
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.size,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.29,
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(size.width * 0.04),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withAlpha(20),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color, color.withAlpha(70)]),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.white, size: 28.sp),
            ),
            SizedBox(height: size.height * 0.01),
            InAppText(
              text: label,

              fontweight: FontWeight.w600,
              color: AppColors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
