import 'package:flutter/material.dart';

class AppColors {
  static Color blackColor = Colors.black;
  static Color errorColor = Colors.red;
  static Color lightgrey = const Color(0xFF9AB4C2);
  static Color homeIconColor = const Color(0xFFD5D5D5);
  static Color blue = const Color(0xFF262b50);
  static Color orange = const Color(0xFFe45a15);
  static Color white = Colors.white;
  static Color green = Colors.green;
  static Color success = const Color.fromARGB(255, 9, 131, 13);
  static Color yellow = Colors.yellow;
  static Color bluelight = const Color(0xFFD4E5EF);
  static Color inactive = const Color(0xFFD0DFE6);
  static Color background = const Color(0xFF5f83b6);
  static Color bottomnav = const Color(0xFF9eb4d3);
  static Color grey = const Color(0xFF7C7C7C);
  static Color textfieldbg = const Color(0xFFdae2ee);
  static Color textfieldborder = const Color(0xFF9cb3d2);
  static Color lightblack = const Color(0xFF4A4A4A);
  static Color lightblue = const Color(0xFF4A90E2);
  static Color filledColor = const Color(0xFF6f90be);
  static Color active = const Color(0xFFb8c8df);

  static final gradient = LinearGradient(
    colors: [AppColors.background, AppColors.blue, AppColors.active],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final lightGradient = LinearGradient(
    colors: [AppColors.background, AppColors.filledColor, AppColors.inactive],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
