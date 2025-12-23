import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../constants/utils/app_colors.dart';

class LoginSuccessPage extends StatelessWidget {
  const LoginSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AppScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.1),
                  Icon(
                    Icons.verified_user,
                    size: 250.sp,
                    color: AppColors.background,
                  ),
                  SizedBox(height: size.width * 0.055),
                  AppText(
                    text: 'Account Logged In',
                    size: 20,
                    fontweight: FontWeight.w600,
                    color: AppColors.blue,
                  ),
                  SizedBox(height: size.width * 0.02),
                  const AppText(
                    text: 'Your account has been successfully Logged In ',
                    size: 18,
                    textAlign: TextAlign.center,
                  ),
                  40.verticalSpace,
                ],
              ),
            ),
            AppButton(
              onTap: () {
                Navigator.pushNamed(context, Routename.bottomNav);
              },
              buttonColor: AppColors.background,
              label: 'Proceed',
            ),
            SizedBox(height: size.width * 0.1),
          ],
        ),
      ),
    );
  }
}
