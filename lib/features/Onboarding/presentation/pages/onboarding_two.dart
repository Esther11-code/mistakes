import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../config/page route/page_route.dart';
import '../../../../constants/utils/app_colors.dart';
import '../../data/images/images.dart';
import '../cubit/onboarding_cubit.dart';

class OnboardingTwo extends StatelessWidget {
  const OnboardingTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final readOnboarding = context.read<OnboardingCubit>();
    final size = MediaQuery.sizeOf(context);
    return AppScaffold(
      color: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.06),
            Image.asset(
              OnboardingImages.onboarding2,
              fit: BoxFit.cover,
              height: size.height * 0.4,
              width: size.width,
            ),
            SizedBox(height: size.height * 0.06),
            // 30.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AppText(
                textAlign: TextAlign.center,
                text: 'Set clear goals and track your progress',
                fontweight: FontWeight.w600,
                size: 18.sp,
              ),
            ),
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AppText(
                text:
                    'Define your goals, set clear milestones and monitor your progressevery step of the way',
                fontweight: FontWeight.w400,
                size: 16.sp,
                textAlign: TextAlign.center,
                color: AppColors.blackColor,
              ),
            ),

            // 40.verticalSpace,
            SizedBox(height: size.height * 0.06),
            ForwardButton(
              size: size,
              onTap: () {
                log(
                  "Onboarding One Tapped${readOnboarding.currentIndex} ${1.0 / (3 - readOnboarding.currentIndex)}",
                );

                readOnboarding.updateIndex(index: 2);
                Navigator.pushNamed(context, Routename.onboardingThree);
              },
            ),

            10.verticalSpace,
          ],
        ),
      ),
    );
  }
}
