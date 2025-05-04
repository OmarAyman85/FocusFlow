import 'package:flutter/material.dart';
import 'package:focusflow/core/theme/app_pallete.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 3),
    borderRadius: BorderRadius.circular(10),
  );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27.0),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.gradient2), 
      floatingLabelStyle: const TextStyle(
        color: AppPallete.gradient1, 
        fontWeight: FontWeight.w600,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppPallete.gradient1,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
