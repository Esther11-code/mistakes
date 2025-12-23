import 'package:flutter/material.dart';

import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/export.dart';

class AllMessages extends StatelessWidget {
  const AllMessages({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
        width: size.width,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.02),

            AppText(
              text: 'Chats',
              size: 20,
              fontweight: FontWeight.w800,
              color: AppColors.blue,
            ),
            SizedBox(height: size.height * 0.02),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    15,
                    (index) => AppshadowContainer(
                      shadowcolour: AppColors.lightgrey.withAlpha(20),
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.width * 0.02,
                      ),
                      margin: EdgeInsets.only(bottom: size.width * 0.03),
                      width: size.width,

                      // height: size.height * 0.1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ProfilePic(
                          //     size: size,
                          //     height: size.width * 0.15,
                          //     width: size.width * 0.15,
                          //     radius: size.width * 0.1),
                          SizedBox(width: size.width * 0.03),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.65,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      maxline: 2,
                                      text: 'John Doe ',
                                      fontweight: FontWeight.w700,
                                      color: AppColors.blue,
                                    ),
                                    AppText(
                                      text: '2 min ago',
                                      size: 12,
                                      fontweight: FontWeight.w700,
                                      color: AppColors.blue,
                                    ),
                                  ],
                                ),
                              ),
                              AppText(
                                text: 'Are You done?',
                                color: AppColors.lightgrey,
                                size: 14,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
