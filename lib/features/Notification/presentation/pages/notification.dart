import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../config/detail/route_name.dart';
import '../../../../constants/utils/app_colors.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppScaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: AppbarWidget(
              size: size,
              title: 'Notifications',
              onTap: () {
                Navigator.popAndPushNamed(context, Routename.bottomNav);
              },
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              width: size.width,
              color: AppColors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    9,
                    (index) => AppshadowContainer(
                      shadowcolour: AppColors.lightgrey.withAlpha(50),
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.width * 0.04,
                      ),
                      margin: EdgeInsets.symmetric(vertical: size.width * 0.03),
                      width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.notifications,
                            color: AppColors.blue,
                            size: 25.sp,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: 'Great Deals',
                                color: AppColors.blue,
                                fontweight: FontWeight.w600,
                              ),
                              SizedBox(
                                width: size.width * 0.6,
                                child: AppText(
                                  text: 'We have an amazing deal for you ',
                                  color: AppColors.blue,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: AppText(
                              text: '1h ago',
                              size: 13,
                              fontweight: FontWeight.w700,
                              color: AppColors.lightgrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
