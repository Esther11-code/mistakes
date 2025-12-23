import 'package:flutter/material.dart';

import '../../../../../constants/utils/app_colors.dart';

class HomeTextfield extends StatelessWidget {
  const HomeTextfield({
    super.key,
    required this.size,
    this.prefixicon,
    this.hintext,
    this.controller,
    this.onChange,
    this.borderColor,
    this.iconColor,
    this.focusColor, this.textColor,
  });
  final Function(String)? onChange;
  final Size size;
  final Widget? prefixicon;
  final String? hintext;
  final TextEditingController? controller;
  final Color? borderColor, iconColor, focusColor,textColor;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChange,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixicon,
        iconColor: iconColor ?? AppColors.blue,
        hintText: hintext,
        hintStyle: TextStyle(
          color:textColor ?? AppColors.grey,
    
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? AppColors.lightgrey.withAlpha(40),
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(size.width * 0.03),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.5,
            color: focusColor ?? AppColors.blue,
          ),
          borderRadius: BorderRadius.circular(size.width * 0.03),
        ),
      ),
    );
  }
}
