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
  static Color textfieldbg = const Color.fromARGB(255, 135, 176, 236);
  static Color textfieldborder = const Color.fromARGB(255, 130, 170, 222);
  static Color lightblack = const Color(0xFF4A4A4A);
  static Color lightblue = const Color(0xFF4A90E2);
  static Color filledColor = const Color(0xFF6f90be);
  static Color active = const Color(0xFFb8c8df);

  static final gradient = LinearGradient(
    colors: [AppColors.background, AppColors.blue, AppColors.active],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Lighter shades for outer container
  static final List<Color> lightRainbowColors = [
    Colors.red.shade300,
    Colors.orange.shade300,

    Colors.green.shade300,
    Colors.blue.shade300,
    Colors.indigo.shade300,
    Colors.purple.shade300,
  ];

  // Darker shades for inner container
  static final List<Color> darkRainbowColors = [
    Colors.red.shade500,
    Colors.orange.shade500,

    Colors.green.shade500,
    Colors.blue.shade500,
    Colors.indigo.shade500,
    Colors.purple.shade500,
  ];
  static final List<Color> darkTextRainbowColors = [
    Colors.red.shade700,
    Colors.orange.shade700,

    Colors.green.shade700,
    Colors.blue.shade700,
    Colors.indigo.shade700,
    Colors.purple.shade700,
  ];
  static final lightGradient = LinearGradient(
    colors: [AppColors.background, AppColors.filledColor, AppColors.inactive],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
