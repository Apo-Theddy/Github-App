import 'package:flutter/material.dart';
import 'package:github_app/core/color/app_color.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light);
  }

  static ThemeData dark() {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.poppins().fontFamily,
      scaffoldBackgroundColor: Color(AppColor.scaffoldBackground),
    );
  }
}
