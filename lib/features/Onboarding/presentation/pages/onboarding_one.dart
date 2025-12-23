import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/page route/page_route.dart';
import '../../../../constants/utils/app_colors.dart';
import '../../../../global widgets/export.dart';
import '../../data/images/images.dart';
import '../cubit/onboarding_cubit.dart';

class OnboardingOne extends StatelessWidget {
  const OnboardingOne({super.key});

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
              OnboardingImages.onboarding1,
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
                text: 'Learn from real mentors who care',
                fontweight: FontWeight.w600,
                size: 18.sp,
              ),
            ),
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AppText(
                text:
                    'Connect with experienced professionals dedicated to your success. Gain invaluable insights from mentors who have had the same journey as you. ',
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
                  "Onboarding One Tapped${readOnboarding.currentIndex}  ${1.0 / (3 - readOnboarding.currentIndex)}",
                );

                readOnboarding.updateIndex(index: 1);
                Navigator.pushNamed(context, Routename.onboardingTwo);
              },
            ),

            10.verticalSpace,
          ],
        ),
      ),
    );
  }
}
