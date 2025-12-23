import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:mistakes/global%20widgets/export.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final watchOnboardingCubit = context.watch<OnboardingCubit>();
    // final readOnboardingCubit = context.read<OnboardingCubit>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // 👇 Optional: makes status bar text/icons visible on gradient
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background, // important!
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: SizedBox()),
            Padding(
              padding: EdgeInsets.all(size.width * 0.05),
              child: AppText(
                textAlign: TextAlign.center,
                text: "Welcome =)",
                fontweight: FontWeight.w800,
                size: 32,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(size.width * 0.05),
              child: Column(
                children: [
                  AppText(
                    text:
                        "Turn ambition into action — connect with mentors who care. Your journey starts here in Mentorverse",
                    textAlign: TextAlign.center,
                    fontweight: FontWeight.w500,
                    size: 18,
                    color: Colors.white,
                  ),
                ],
              ),
            ),

            const Spacer(),
            Row(
              children: [
                AppButton(
                  borderRadius: watchOnboardingCubit.isLogin
                      ? BorderRadius.only(
                          topRight: Radius.circular(size.width * 0.05),
                        )
                      : BorderRadius.zero,

                  radius: 0.0,
                  height: size.height * 0.1,
                  textSize: 18,
                  label: "Log In",
                  buttonColor: watchOnboardingCubit.isLogin
                      ? AppColors.filledColor
                      : Colors.transparent,
                  onTap: () {
                    Navigator.pushNamed(context, Routename.login);
                    watchOnboardingCubit.changeAuthMode(isLogin: true);
                  },
                  width: size.width * 0.5,
                ),
                AppButton(
                  height: size.height * 0.1,
                  textSize: 18,
                  borderRadius: watchOnboardingCubit.isLogin
                      ? BorderRadius.zero
                      : BorderRadius.only(
                          topLeft: Radius.circular(size.width * 0.05),
                        ),
                  radius: 0.0,
                  label: "Sign Up",
                  buttonColor: watchOnboardingCubit.isLogin
                      ? Colors.transparent
                      : AppColors.blue,
                  width: size.width * 0.5,
                  onTap: () {
                    watchOnboardingCubit.changeAuthMode(isLogin: false);
                    Navigator.pushNamed(context, Routename.signup);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
