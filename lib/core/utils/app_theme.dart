import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF000919),
      fontFamily: 'Mplus 1p Bold',

      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF01379C), secondary: const Color(0xFFDB2653),),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34.sp,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 12.sp,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFE1F66),
          foregroundColor: Colors.white,
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
      ),
    );
  }
}
