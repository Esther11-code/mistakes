import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../config/detail/route_name.dart';
import '../../../../constants/utils/app_colors.dart';
import '../../data/images/images.dart';
import '../cubit/onboarding_cubit.dart';

class OnboardingThree extends StatelessWidget {
  const OnboardingThree({super.key});

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
              OnboardingImages.onboarding3,
              fit: BoxFit.cover,
              height: size.height * 0.4,
              width: size.width,
            ),
            SizedBox(height: size.height * 0.06),
            // 20.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AppText(
                textAlign: TextAlign.center,
                text: 'Build confidence in your career journey',
                fontweight: FontWeight.w600,
                size: 18.sp,
              ),
            ),
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AppText(
                text:
                    'Gain the skills and mindset to achieve your professional dreams',
                fontweight: FontWeight.w400,
                size: 16.sp,
                textAlign: TextAlign.center,
                color: AppColors.blackColor,
              ),
            ),

            SizedBox(height: size.height * 0.06),

            ForwardButton(
              size: size,
              onTap: () {
                log(
                  "Onboarding One Tapped${readOnboarding.currentIndex} ${1.0 / (3 - readOnboarding.currentIndex)}",
                );

                readOnboarding.updateIndex(index: 3);
                Navigator.pushNamed(context, Routename.welcome);
              },
            ),

            10.verticalSpace,
          ],
        ),
      ),
    );
  }
}
