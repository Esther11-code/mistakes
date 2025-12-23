import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Dashboard/pages/mentee/mentee_dashboard.dart';
import 'package:mistakes/features/Dashboard/pages/mentor/mentor_dashboard.dart';
import 'package:mistakes/global%20widgets/widgets/app_container_withshadow.dart';

import '../../../global widgets/widgets/app_text.dart';
import '../../Authentication/presentation/cubit/authentication_cubit.dart';

class DashboardSetup extends StatelessWidget {
  const DashboardSetup({super.key});

  @override
  Widget build(BuildContext context) {
    final watchAuthCubit = context.watch<AuthenticationCubit>();
    return watchAuthCubit.user.role == "Mentor"
        ? const MentorDashboard()
        : const MenteeDashboard();
  }
}

class DashboardOptions extends StatelessWidget {
  const DashboardOptions({
    super.key,
    required this.size,
    this.onTap,
    this.icon,
    this.text,
  });

  final Size size;
  final dynamic Function()? onTap;
  final IconData? icon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return AppshadowContainer(
      width: size.width * 0.28,

      onTap:
          onTap ??
          () {
            Navigator.pushNamed(context, Routename.chat);
          },
      shadowcolour: AppColors.lightgrey.withAlpha(100),
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.02,
        horizontal: size.width * 0.04,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.message,
            size: 30.sp,
            color: AppColors.filledColor,
          ),
          SizedBox(height: size.height * 0.01),
          AppText(
            text: text ?? "Message",
            textAlign: TextAlign.center,
            size: 20,
          ),
        ],
      ),
    );
  }
}
