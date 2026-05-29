import 'package:flutter/material.dart';

class Responsive {
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  
  static double verticalSpacing(BuildContext context, double multiplier) {
    // Standard modular unit spacing based on 8dp unit
    return 8.0 * multiplier;
  }
  
  static double horizontalPadding(BuildContext context) {
    double width = screenWidth(context);
    if (width > 600) {
      return 64.0; // Desktop/Tablet container padding
    }
    return 24.0; // Mobile container padding (24dp from DESIGN.md)
  }

  static bool isMobile(BuildContext context) => screenWidth(context) < 600;
  static bool isTablet(BuildContext context) => screenWidth(context) >= 600 && screenWidth(context) < 1024;
  static bool isDesktop(BuildContext context) => screenWidth(context) >= 1024;

  static double cardWidth(BuildContext context) {
    double width = screenWidth(context);
    if (width > 1140) {
      return 1140.0;
    }
    return width - (horizontalPadding(context) * 2);
  }
}
