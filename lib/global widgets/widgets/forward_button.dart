import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/detail/route_name.dart';
import '../../constants/utils/app_colors.dart';
import '../../features/Onboarding/presentation/cubit/onboarding_cubit.dart';

class ForwardButton extends StatelessWidget {
  const ForwardButton({super.key, required this.size, required this.onTap});

  final Size size;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final watchOnboarding = context.watch<OnboardingCubit>();
    final readOnboarding = context.read<OnboardingCubit>();
    return GestureDetector(
      onTap:
          onTap ??
          () {
            readOnboarding.updateIndex(index: 1);
            Navigator.pushNamed(context, Routename.onboardingTwo);
          },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer circular border = progress ring
          SizedBox(
            width: size.height * 0.08,
            height: size.height * 0.08,
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0,
                end: (watchOnboarding.currentIndex + 1) / 3,
              ),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, _) => CircularProgressIndicator(
                value: value, // 👈 border fill progress
                strokeWidth: 4, // 👈 border thickness
                backgroundColor: AppColors.inactive.withAlpha(100),
                valueColor: AlwaysStoppedAnimation(
                  AppColors.background.withAlpha(100),
                ),
              ),
            ),
          ),

          // Inner circle (button)
          CircleAvatar(
            radius: size.height * 0.03,
            backgroundColor: AppColors.bottomnav,
            child: Icon(
              CupertinoIcons.arrow_right,
              size: 25.sp,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
