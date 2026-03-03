import 'package:flutter/material.dart';

class Screensize {
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}

// import 'package:flutter/material.dart';

class myColors {
  static const Color primaryColor = Color(0xFF000000); // Pure Black Background
  static const Color secondaryColor = Color(0xFF141414); // Netflix Dark Grey
  static const Color extra = Color(0xFF2B2B2B); // Lighter Grey
  static const Color extra2 = Color(0xFFE50914); // Netflix Red / Accent
  static const Color darkPrimary = Color(0xFFE50914);
  static const Color darkSecondary = Color(0xFF141414);
  static const Color grey = Color(0xFF808080);
  static const Color grey2 = Color(0xFFB3B3B3);
  static const Color grey3 = Color(0xFF4D4D4D);
}
