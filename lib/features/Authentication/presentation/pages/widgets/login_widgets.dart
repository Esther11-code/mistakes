import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/constants/utils/app_colors.dart';
import 'package:mistakes/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mistakes/global%20widgets/widgets/app_checkbox.dart';

import '../../../../../global widgets/widgets/app_text.dart';

class CheckboxAndLabel extends StatelessWidget {
  const CheckboxAndLabel({
    super.key,
    required this.watchAuthCubit,
    required this.readAuthCubit,
  });

  final AuthenticationCubit watchAuthCubit;
  final AuthenticationCubit readAuthCubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppCheckbox(
          status: watchAuthCubit.stayLogin,
          ontap: () {
            readAuthCubit.changeStaylogin();
          },
        ),
        10.horizontalSpace,
        InAppText(
          text: "Stay logged in",
          fontweight: FontWeight.w500,
          size: 16,
          color: AppColors.lightblack,
        ),
      ],
    );
  }
}
