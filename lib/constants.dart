import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFDEE1EC);
  static const Color myPurple = Color(0xFF7B3EFF);
  static const Color myRed = Color(0xFFF98699);
  static const Color myGreen = Color.fromARGB(255, 77, 185, 101);
  static const Color myYellow = Color(0xFFFEBE6C);
  static const Color textColor = Color(0xFF46568C);
}

Color ingredientColor(int val) {
  if (val > 6) {
    return AppColors.myRed;
  } else if (val > 4) {
    return AppColors.myYellow;
  } else {
    return AppColors.myGreen;
  }
}

Color percentColor(int val) {
  if (val > 85) {
    return AppColors.myGreen;
  } else if (val > 60) {
    return AppColors.myYellow;
  } else {
    return AppColors.myRed;
  }
}

String trimmedText(String val) {
  final count = val.length;
  if (count > 15) {
    return '${val.substring(0, 15)}...';
  }
  return val;
}
