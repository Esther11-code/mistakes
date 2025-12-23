import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mistakes/global%20widgets/widgets/app_text.dart';

import '../../constants/utils/app_colors.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.color,
    required this.body,
    this.floatingActionButton,
    this.isloading = false,
    this.extendBody,
  });
  final Color? color;
  final Widget? body, floatingActionButton;

  final bool isloading;
  final bool? extendBody;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: extendBody ?? false,
      floatingActionButton: floatingActionButton,
      backgroundColor: color ?? AppColors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(2.h),
        child: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          backgroundColor: color ?? AppColors.white,
        ),
      ),
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: isloading,
            child: Opacity(opacity: isloading ? 0.2 : 1.0, child: body),
          ),
          isloading
              ? Column(
                  children: [
                    SizedBox(height: 220.h),
                    Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: AppColors.blackColor,
                        size: 60.sp,
                      ),
                    ),
                    3.verticalSpace,
                    const AppText(
                      text: ' Please wait...',
                      fontweight: FontWeight.w600,
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
