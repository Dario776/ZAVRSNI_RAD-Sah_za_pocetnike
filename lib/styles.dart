import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zavrsni/settings_provider.dart';

class Styles {
  static const _textSizeVeryLarge = 36.0;
  static const _textSizeLarge = 22.0;
  static const _textSizeDefault = 16.0;
  static const _textSizeSmall = 12.0;
  static const horizontalPaddingDefault = 12.0;
  static const biggerFontSizeMultiplier = 1.2;

  static final Color primaryColor = Color.fromARGB(255, 237, 244, 242);
  static final Color secondaryColor = Color.fromARGB(255, 49, 71, 58);
  static final Color accentColor = Color.fromARGB(255, 233, 180, 76);
  static final Color errorColor = Color.fromARGB(255, 155, 41, 21);
  static final Color backgroundColor = Color.fromARGB(255, 84, 117, 120);
  static final Color primaryTextColor = Colors.black;
  static final Color secondaryTextColor = Colors.white;
  static final Color disabledTextColor = Colors.grey[400]!;
  static final String fontNamePrimary = 'Sans';
  static final String fontNameSecondary = 'Dyslexic';

  static TextStyle navBarTitle(BuildContext context) {
    return TextStyle(
      fontFamily: Provider.of<SettingsProvider>(context).currentFontName,
      fontWeight: FontWeight.w600,
      fontSize:
          Provider.of<SettingsProvider>(context).isBiggerFontSize
              ? _textSizeDefault * biggerFontSizeMultiplier
              : _textSizeDefault,
      height: 1.5,
    );
  }

  static TextStyle headerLarge(BuildContext context) {
    return TextStyle(
      fontFamily: Provider.of<SettingsProvider>(context).currentFontName,
      fontSize:
          Provider.of<SettingsProvider>(context).isBiggerFontSize
              ? _textSizeLarge * biggerFontSizeMultiplier
              : _textSizeLarge,
      height: 1.5,
    );
  }

  static TextStyle headerVeryLarge(BuildContext context) {
    return TextStyle(
      fontFamily: Provider.of<SettingsProvider>(context).currentFontName,
      fontWeight: FontWeight.w600,
      fontSize:
          Provider.of<SettingsProvider>(context).isBiggerFontSize
              ? _textSizeVeryLarge * biggerFontSizeMultiplier
              : _textSizeVeryLarge,
      height: 1.5,
    );
  }

  static TextStyle textDefault(BuildContext context) {
    return TextStyle(
      fontFamily: Provider.of<SettingsProvider>(context).currentFontName,
      fontSize:
          Provider.of<SettingsProvider>(context).isBiggerFontSize
              ? _textSizeDefault * biggerFontSizeMultiplier
              : _textSizeDefault,
      height: 1.5,
    );
  }

  static TextStyle boardText(BuildContext context, bool isWhite) {
    return TextStyle(
      fontFamily: Provider.of<SettingsProvider>(context).currentFontName,
      fontSize:
          Provider.of<SettingsProvider>(context).isBiggerFontSize
              ? _textSizeSmall * biggerFontSizeMultiplier
              : _textSizeSmall,
      fontWeight: FontWeight.w600,
      color: isWhite ? Styles.backgroundColor : Colors.white,
    );
  }

  static TextStyle customColorText(
    BuildContext context,
    TextStyle textStyle,
    bool isSecondary,
  ) {
    final bool isWhiteTheme = Theme.of(context).brightness == Brightness.light;
    return isWhiteTheme
        ? textStyle.copyWith(color: isSecondary ? primaryColor : secondaryColor)
        : textStyle.copyWith(
          color: isSecondary ? secondaryColor : primaryColor,
        );
  }

  static ThemeData buildThemeData({
    required bool isDarkMode,
    required String fontFamily,
    required BuildContext context,
  }) {
    final brightness = isDarkMode ? Brightness.dark : Brightness.light;
    final baseColor = isDarkMode ? secondaryColor : primaryColor;
    final contrastColor = isDarkMode ? primaryColor : secondaryColor;

    return ThemeData(
      brightness: brightness,
      primaryColor: isDarkMode ? primaryColor : secondaryColor,
      secondaryHeaderColor: secondaryColor,
      scaffoldBackgroundColor: baseColor,
      fontFamily: fontFamily,
      cardTheme: CardTheme(color: contrastColor),
      iconTheme: IconThemeData(color: contrastColor),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(iconSize: 30),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: baseColor,
        iconTheme: IconThemeData(color: contrastColor),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize:
              Provider.of<SettingsProvider>(context).isBiggerFontSize
                  ? _textSizeVeryLarge * biggerFontSizeMultiplier
                  : _textSizeVeryLarge,
          fontWeight: FontWeight.w600,
          color: contrastColor,
        ),
        headlineMedium: TextStyle(
          fontSize:
              Provider.of<SettingsProvider>(context).isBiggerFontSize
                  ? _textSizeLarge * biggerFontSizeMultiplier
                  : _textSizeLarge,
          fontWeight: FontWeight.w500,
          color: contrastColor,
        ),
        bodyMedium: TextStyle(
          fontSize:
              Provider.of<SettingsProvider>(context).isBiggerFontSize
                  ? _textSizeDefault * biggerFontSizeMultiplier
                  : _textSizeDefault,
          height: 1.2,
          color: contrastColor,
        ),
        labelSmall: TextStyle(
          fontSize:
              Provider.of<SettingsProvider>(context).isBiggerFontSize
                  ? _textSizeSmall * biggerFontSizeMultiplier
                  : _textSizeSmall,
          fontWeight: FontWeight.w600,
          color: contrastColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: contrastColor,
          foregroundColor: baseColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        ),
      ),
    );
  }
}
