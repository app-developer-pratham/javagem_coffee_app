import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors (Design Tokens from Figma Foundation)
  static const Color primaryColor = Color(0xffC67C4E); // Brown/Normal
  static const Color primaryLightColor = Color(0xffF9F2ED); // Brown/Light
  static const Color surfaceLightColor = Color(0xffF9F9F9); // Surface/Light
  static const Color surfaceWhiteColor = Color(0xffFFFFFF); // Surface/White
  static const Color surfaceGreyColor = Color(0xffEDEDED); // Surface/Grey
  static const Color surfaceActiveColor = Color(
    0xffE3E3E3,
  ); // Surface/Light :active
  static const Color textDarkColor = Color(0xff242424); // Grey/Normal :active
  static const Color textHoverColor = Color(0xff2A2A2A); // Grey/Normal :hover
  static const Color textNormalColor = Color(0xff313131); // Grey/Normal
  static const Color textGreyHoverColor = Color(
    0xff909090,
  ); // Grey/Light :hover
  static const Color textMutedColor = Color(0xffA2A2A2); // Grey/Lighter
  static const Color iconBadgeBgColor = Color(
    0x59EDEDED,
  ); // rgba(237, 237, 237, 0.35)
  static const Color starColor = Color(0xffFBBE21);

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
    cupertinoOverrideTheme: MaterialBasedCupertinoThemeData(
      materialTheme: ThemeData(
        textTheme: textTheme,
      ),
    ),
  );

  // Dimensions
  static const double spacing = 24;
  static const double promoBannerAspectRatio = 2.336;
  static const double productCardAspectRatio = 0.655;
  static const double detailImageAspectRatio = 327 / 202;
}
