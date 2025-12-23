import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mistakes/constants/utils/app_colors.dart';

class AppText extends StatelessWidget {
  const AppText({
    super.key,
    required this.text,
    this.size = 18,
    this.maxline = 3,
    this.color,
    this.fontweight = FontWeight.w400,
    this.textAlign,
    this.height = 0,
    this.fontStyle = FontStyle.normal,
  });
  final String text;
  final FontWeight? fontweight;
  final Color? color;
  final double size, height;
  final int maxline;
  final TextAlign? textAlign;
  final FontStyle fontStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      softWrap: true,
      maxLines: maxline,
      style: GoogleFonts.jost(
        fontStyle: fontStyle,
        height: height,
        fontSize: size.sp,
        fontWeight: fontweight,
        color: color ?? AppColors.blackColor,
      ),
    );
  }
}
