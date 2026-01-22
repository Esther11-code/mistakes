import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/global%20widgets/widgets/app_container_withshadow.dart';
import 'package:mistakes/global%20widgets/widgets/app_textfield.dart';

import '../../../../../constants/utils/app_colors.dart';

class ExpertiseField extends StatelessWidget {
  const ExpertiseField({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    final user = watchAuthCubit.user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: user.isMentor ? 'Expertise' : 'Field of Study',
            style: GoogleFonts.ptSans(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blue,
            ),
            children: [
              TextSpan(
                text: '*',
                style: GoogleFonts.ptSans(
                  color: AppColors.errorColor,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.01),
        AppshadowContainer(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: size.height * 0.005,
          ),
          color: AppColors.white,
          child: ApptextField(
            controller: watchAuthCubit.expertiseController,
            hintText: user.isMentor
                ? "e.g., Senior Software Engineer"
                : "e.g., Junior Software Engineer",
            prefixIconn: Icon(
              Icons.work_outline,
              color: AppColors.blue,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class BioField extends StatelessWidget {
  const BioField({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Bio',
            style: GoogleFonts.ptSans(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blue,
            ),
            children: [
              TextSpan(
                text: '*',
                style: GoogleFonts.ptSans(
                  color: AppColors.errorColor,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.01),
        AppshadowContainer(
          padding: EdgeInsets.all(size.width * 0.04),
          color: AppColors.white,
          child: ApptextField(
            controller: watchAuthCubit.bioController,
            maxLine: 5,
            hintText: "Tell us about yourself...",
          ),
        ),
      ],
    );
  }
}

class YoeField extends StatelessWidget {
  const YoeField({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Years of Experience',
            style: GoogleFonts.ptSans(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blue,
            ),
            children: [
              TextSpan(
                text: '*',
                style: GoogleFonts.ptSans(
                  color: AppColors.errorColor,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
        ),
        AppshadowContainer(
          padding: EdgeInsets.all(size.width * 0.04),
          color: AppColors.white,
          child: ApptextField(
            controller: watchAuthCubit.yearsOfExperienceController,
            hintText: "What is your years of experience?",
          ),
        ),
      ],
    );
  }
}
