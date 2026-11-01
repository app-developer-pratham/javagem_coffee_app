import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static final primaryColor = Color(0xffC67C4E);
  static final colorScheme = ColorScheme.fromSeed(seedColor: primaryColor);
  static final textTheme = GoogleFonts.soraTextTheme();
  static final themeData = ThemeData(
    scaffoldBackgroundColor: Color(0xffF9F9F9),
    colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffC67C4E)),
    textTheme: textTheme.copyWith(),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Color(0xffC67C4E),
        minimumSize: Size(0, 56),
        textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 16, cornerSmoothing: 1),
          ),
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 12, cornerSmoothing: 1),
          ),
        ),
        padding: EdgeInsets.zero,
        backgroundColor: Color(0xffC67C4E),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Color(0xffA2A2A2),
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Color(0xffEDEDED),
      labelStyle: textTheme.labelLarge?.copyWith(
        fontSize: 14,
        color: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return const Color(0xff313131);
        }),
        fontWeight: FontWeight.bold,
      ),
      selectedColor: Color(0xffC67C4E),
      secondarySelectedColor: Color(0xffC67C4E),
      labelPadding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 0,
      ),
      side: BorderSide.none,
      showCheckmark: false,
    ),
    bottomAppBarTheme: BottomAppBarThemeData(height: 85, color: Colors.white),
  );

  // Dimensions
  static const double spacing = 24;
}
