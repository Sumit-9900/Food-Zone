import 'package:flutter/material.dart';
import 'package:food_client/core/theme/textstyle.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 1.0,
      titleTextStyle: Style.text.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 24.0,
      ),
    ),
    cardTheme: CardThemeData(elevation: 2.0),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Colors.black87,
      circularTrackColor: Colors.grey,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.black)),
        minimumSize: WidgetStatePropertyAll(Size(double.infinity, 60)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.black),
          ),
        ),
      ),
    ),
  );
}
