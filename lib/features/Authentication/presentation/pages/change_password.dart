import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/config/detail/route_name.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/global%20widgets/export.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppScaffold(
      body: Column(
        children: [
          AppbarWidget(
            size: size,
            title: 'Change Password',
            onTap: () => Navigator.pop(context),
          ),
          20.verticalSpace,
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              children: [
                AppText(
                  text: 'Secure your account',
                  fontweight: FontWeight.w600,

                  size: 20,
                ),
                5.verticalSpace,
                AppText(
                  text: 'Create a new password below to secure your account',
                  size: 14,
                ),
                20.verticalSpace,
                const ApptextField(
                  title: 'New Password',
                  hintText: 'Enter New Password',
                ),
                20.verticalSpace,
                const ApptextField(
                  title: 'Confirm Password',
                  hintText: 'Enter confirm Password',
                ),
                30.verticalSpace,
                const CustomOtpField(),
                10.verticalSpace,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(text: 'Didn’t receive any code?', size: 14),
                    AppText(text: 'Expires in 00:00', size: 14),
                  ],
                ),
                5.verticalSpace,
                const AppText(
                  text: 'Resend code',
                  fontweight: FontWeight.w500,
                  size: 14,
                ),
                40.verticalSpace,
                AppButton(
                  label: 'Proceed',
                  buttonColor: AppColors.background,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const ChangePasswordDialog();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChangePasswordDialog extends StatelessWidget {
  const ChangePasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.check_mark_circled_solid,
            size: 250.sp,
            color: AppColors.background,
          ),
          20.verticalSpace,
          const AppText(
            textAlign: TextAlign.center,
            text: 'Your Password Has been Changed Successfully!',
            size: 16,
          ),
          20.verticalSpace,
          AppButton(
            label: 'Done',
            buttonColor: AppColors.background,
            onTap: () {
              Navigator.pushNamed(context, Routename.login);
            },
          ),
        ],
      ),
    );
  }
}

class CustomOtpField extends StatelessWidget {
  const CustomOtpField({super.key, this.controller});
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return PinCodeTextField(
      keyboardType: TextInputType.number,
      controller: controller,
      pinTheme: PinTheme(
        activeColor: AppColors.blackColor,
        inactiveColor: AppColors.lightgrey,
        selectedColor: AppColors.blackColor,
        borderRadius: BorderRadius.circular(size.width * 0.03),
        shape: PinCodeFieldShape.box,
        fieldHeight: size.height * 0.06,
        fieldWidth: size.height * 0.06,
      ),
      appContext: context,
      length: 6,
    );
  }
}
