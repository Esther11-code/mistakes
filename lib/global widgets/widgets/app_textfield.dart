import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/utils/app_colors.dart';

class ApptextField extends StatelessWidget {
  const ApptextField({
    super.key,
    this.title,
    this.labelText,
    this.prefixIcon,
    this.labelColor,
    this.sufixIcon,
    this.controller,
    this.hintText,
    this.maxLine,
    this.validator,
    this.onChange,
    this.onTap,
    this.readOnly = false,
    this.keyboardType,
    this.size,
    this.fontWeight,
    this.obscureText,
    this.suffixIcon,
    this.prefixIconn, this.maxlength, this.focusNode,
  });
  final String? title, hintText, labelText;
  final int? maxLine,maxlength;
  final IconData? prefixIcon, sufixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String?)? onChange;
  final Function()? onTap;
  final bool readOnly;
  final TextInputType? keyboardType;
  final double? size;
  final FontWeight? fontWeight;
  final Color? labelColor;
  final bool? obscureText;
  final Widget? suffixIcon, prefixIconn;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AppText(
        //   text: title ?? "",
        //   size: size ?? 14,
        //   fontweight: fontWeight ?? FontWeight.w500,
        // ),
        // 4.verticalSpace,
        TextFormField(
          obscureText: obscureText ?? false,
          onTap: onTap,
          readOnly: readOnly,
          validator: validator,
          focusNode: focusNode,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: maxLine,
          maxLength: maxlength,
          controller: controller,
          onChanged: onChange,
          keyboardType: keyboardType,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              fontFamily: 'Matter',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: labelColor ?? AppColors.blue,
            ),
            errorMaxLines: 3,
            suffixIconColor: WidgetStateColor.resolveWith(
              (states) => states.contains(WidgetState.focused)
                  ? AppColors.blue
                  : AppColors.inactive,
            ),
            prefixIconColor: WidgetStateColor.resolveWith(
              (states) => states.contains(WidgetState.focused)
                  ? AppColors.blue
                  : AppColors.inactive,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(color: AppColors.textfieldborder),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(color: AppColors.errorColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(color: AppColors.blue),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(color: AppColors.errorColor),
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: 'Matter',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.blackColor,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.sp,
              vertical: 5.sp,
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIconn,
          ),
        ),
      ],
    );
  }
}
