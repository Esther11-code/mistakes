import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mistakes/constants/utils/app_colors.dart';

class AppTimer extends StatelessWidget {
  const AppTimer({
    super.key,
    required this.duration,
    this.timerColor,
    this.onEnd,
  });
  final int duration;
  final Color? timerColor;
  final Function()? onEnd;

  @override
  Widget build(BuildContext context) {
    return TimerCountdown(
      onEnd: onEnd,
      spacerWidth: 1,
      colonsTextStyle: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: timerColor ?? AppColors.errorColor,
      ),
      timeTextStyle: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: timerColor ?? AppColors.errorColor,
      ),
      format: CountDownTimerFormat.minutesSeconds,
      enableDescriptions: false,
      endTime: DateTime.now().add(Duration(minutes: duration)),
    );
  }
}
