import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/features/Profile/presentation/pages/Profiles/Mentee/mentee_account.dart';
import 'package:mistakes/features/Profile/presentation/pages/Profiles/Mentor/mentor_account.dart';
import 'package:mistakes/global%20widgets/export.dart';

class ProfileSetUp extends StatelessWidget {
  const ProfileSetUp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthenticationCubit>().user.role;
    return user == 'mentor' ? const MentorAccount() : const MenteeAccount();
  }
}

class ProfileSettingWidget extends StatelessWidget {
  const ProfileSettingWidget({
    super.key,
    required this.size,
    this.label,
    this.icon,
    this.onTap,
  });

  final Size size;
  final String? label;
  final IconData? icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size.width * 0.02),
      shadowcolour: AppColors.lightgrey.withAlpha(100),
      border: true,
      borderColor: AppColors.background,
      padding: EdgeInsets.all(size.width * 0.03),
      margin: EdgeInsets.only(top: size.height * 0.02),
      color: AppColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AppshadowContainer(
                color: AppColors.white,
                shadowcolour: AppColors.lightgrey.withAlpha(100),
                padding: EdgeInsets.all(size.width * 0.02),
                child: Icon(
                  icon ?? Icons.lock,
                  size: 30.sp,
                  color: AppColors.blue,
                ),
              ),
              SizedBox(width: size.width * 0.03),
              InAppText(
                text: label ?? "Change Password",
                color: AppColors.blue,
                fontweight: FontWeight.w500,
              ),
            ],
          ),
          Icon(
            CupertinoIcons.chevron_right,
            size: 25.sp,
            color: AppColors.blue,
            weight: size.width * 0.05,
          ),
        ],
      ),
    );
  }
}
class InwardCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.quadraticBezierTo(
      size.width / 2,
      80,
      size.width,
      0,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
