import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mistakes/main.dart';

import 'app_colors.dart';

class ToastMessage {
  static void showErrorToast({required String message, VoidCallback? onTap}) {
    _toast(message: message, type: _ToastType.error);
  }

  static void showWarningToast({required String message, VoidCallback? onTap}) {
    _toast(message: message, type: _ToastType.warning);
  }

  static void showSuccessToast({required String message, VoidCallback? onTap}) {
    _toast(message: message, type: _ToastType.success, onTap: onTap);
  }

  static void _toast({
    required String message,
    required _ToastType type,
    VoidCallback? onTap,
  }) {
    Flushbar(
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      onTap: (flushbar) {
        if (onTap != null) {
          onTap.call();
        }
      },
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      reverseAnimationCurve: Curves.fastEaseInToSlowEaseOut,
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 24.h),
      borderRadius: BorderRadius.circular(10.r),
      messageSize: 16.sp,
      backgroundColor: switch (type) {
        _ToastType.error => AppColors.errorColor,
        _ToastType.warning => AppColors.yellow,
        _ToastType.success => AppColors.green,
      },
      messageColor: AppColors.white,
      duration: const Duration(seconds: 2),
      icon: Icon(switch (type) {
        _ToastType.error => Icons.error_outline_rounded,
        _ToastType.warning => Icons.warning_amber_rounded,
        _ToastType.success => Icons.done_all_rounded,
      }, color: AppColors.white),
    ).show(navigatorKey.currentState!.context);
  }
}

enum _ToastType { error, warning, success }
