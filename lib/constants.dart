import 'package:flutter/material.dart';
import 'package:deep_scan/models/company.dart';

class AppColors {
  static const Color background = Color(0xFFDEE1EC);
  static const Color myPurple = Color(0xFF7B3EFF);
  static const Color myRed = Color(0xFFF98699);
  static const Color myGreen = Color.fromARGB(255, 77, 185, 101);
  static const Color myYellow = Color(0xFFFEBE6C);
  static const Color textColor = Color(0xFF46568C);
}

String URL =
    'https://images.unsplash.com/photo-1528750596806-ff12e21cda04?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

Color ingredientColor(int val) {
  if (val > 7) {
    return AppColors.myRed;
  } else if (val > 4) {
    return AppColors.myYellow;
  } else {
    return AppColors.myGreen;
  }
}

Color percentColor(int val) {
  if (val > 70) {
    return AppColors.myGreen;
  } else if (val > 40) {
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

Icon getIcon(ItemType type) {
  switch (type) {
    case ItemType.food:
      return const Icon(
        Icons.fastfood,
        color: AppColors.myRed,
        size: 20,
      );
    case ItemType.cosmetics:
      return const Icon(
        Icons.spa,
        color: AppColors.myRed,
      );
    case ItemType.supplements:
      return const Icon(Icons.medication, color: AppColors.myRed);
  }
}

enum ItemType { food, supplements, cosmetics }

final List<Company> companies = [
  Company(
    id: '1',
    name: 'Nissan',
    averageHealthRating: 72,
  ),
  Company(
    id: '2',
    name: 'Nissan',
    averageHealthRating: 27,
  ),
  Company(
    id: '3',
    name: 'Nissan',
    averageHealthRating: 13,
  ),
  Company(
    id: '4',
    name: 'Nissan',
    averageHealthRating: 91,
  ),
  Company(
    id: '5',
    name: 'Nissan',
    averageHealthRating: 42,
  ),
];
