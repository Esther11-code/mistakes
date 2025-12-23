import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/global%20widgets/export.dart';

import '../../../../constants/utils/app_colors.dart';

class BookingSuccess extends StatelessWidget {
  const BookingSuccess({super.key});

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
                    Icons.check_circle,
                    size: 200.sp,
                    color: AppColors.filledColor,
                  ),
                  SizedBox(height: size.width * 0.055),
                  AppText(
                    text: 'Thank You!',
                    size: 20,
                    fontweight: FontWeight.w600,
                    color: AppColors.blue,
                  ),
                  SizedBox(height: size.width * 0.02),
                  const AppText(
                    text: 'Your mentor booking was successful ',
                    size: 18,
                    textAlign: TextAlign.center,
                  ),
                  40.verticalSpace,
                ],
              ),
            ),
            AppButton(
              onTap: () {
                Navigator.popAndPushNamed(context, Routename.bottomNav);
              },
              buttonColor: AppColors.background,
              label: 'Done',
            ),
            SizedBox(height: size.width * 0.1),
          ],
        ),
      ),
    );
  }
}
