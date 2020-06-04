import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static Color _iconColor = Colors.blueAccent.shade200;

  static const Color _lightPrimaryColor = Colors.white;
  static const Color _lightPrimaryVariantColor = Color(0XFFFCFCFC);
  static const Color _lightSecondaryColor = Colors.green;
  static const Color _lightOnPrimaryColor = Colors.black;

  static const Color _darkPrimaryColor = Colors.white24;
  static const Color _darkPrimaryVariantColor = Colors.black;
  static const Color _darkSecondaryColor = Colors.white;
  static const Color _darkOnPrimaryColor = Colors.white;

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Josefin',
    scaffoldBackgroundColor: _lightPrimaryVariantColor,
    appBarTheme: AppBarTheme(
      color: _lightPrimaryVariantColor,
      iconTheme: IconThemeData(color: _lightOnPrimaryColor),
    ),
    colorScheme: ColorScheme.light(
      primary: _lightPrimaryColor,
      primaryVariant: _lightPrimaryVariantColor,
      secondary: _lightSecondaryColor,
      onPrimary: _lightOnPrimaryColor,
    ),
    iconTheme: IconThemeData(
      color: _iconColor,
    ),
    textTheme: _lightTextTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Josefin',
    scaffoldBackgroundColor: _darkPrimaryVariantColor,
    appBarTheme: AppBarTheme(
      color: _darkPrimaryVariantColor,
      iconTheme: IconThemeData(color: _darkOnPrimaryColor),
    ),
    colorScheme: ColorScheme.light(
      primary: _darkPrimaryColor,
      primaryVariant: _darkPrimaryVariantColor,
      secondary: _darkSecondaryColor,
      onPrimary: _darkOnPrimaryColor,
    ),
    iconTheme: IconThemeData(
      color: _iconColor,
    ),
    textTheme: _darkTextTheme,
  );

  static final TextTheme _lightTextTheme = TextTheme(
      headline: _lightScreenHeadingTextStyle,
      display1: _lightScreenHeadline1TextStyle,
      body1: _lightScreenTaskNameTextStyle,
      body2: _lightScreenTaskDurationTextStyle,
      title: _lightScreenTitleTextStyle,
      subtitle: _lightScreenSubTitleTextStyle);

  static final TextTheme _darkTextTheme = TextTheme(
      headline: _darkScreenHeadingTextStyle,
      display1: _darkScreenHeadline1TextStyle,
      body1: _darkScreenTaskNameTextStyle,
      body2: _darkScreenTaskDurationTextStyle,
      title: _darkScreenTitleTextStyle,
      subtitle: _darkScreenSubTitleTextStyle);

  static final TextStyle _lightScreenHeadingTextStyle =
      TextStyle(fontSize: 48.0, color: _lightOnPrimaryColor);
  static final TextStyle _lightScreenTaskNameTextStyle =
      TextStyle(fontSize: 20.0, color: _lightOnPrimaryColor);
  static final TextStyle _lightScreenTaskDurationTextStyle =
      TextStyle(fontSize: 16.0, color: Colors.grey);
  static final TextStyle _lightScreenTitleTextStyle = TextStyle(
      fontSize: 17.0,
      color: _lightOnPrimaryColor,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w400);
  static final TextStyle _lightScreenSubTitleTextStyle = TextStyle(
      fontSize: 16.0,
      color: _lightOnPrimaryColor,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w300);
  static final TextStyle _lightScreenHeadline1TextStyle = TextStyle(
      fontSize: 20.0,
      color: _lightOnPrimaryColor,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w400);

  static final TextStyle _darkScreenHeadingTextStyle =
      _lightScreenHeadingTextStyle.copyWith(color: _darkOnPrimaryColor);
  static final TextStyle _darkScreenTaskNameTextStyle =
      _lightScreenTaskNameTextStyle.copyWith(color: _darkOnPrimaryColor);
  static final TextStyle _darkScreenTaskDurationTextStyle =
      _lightScreenTaskDurationTextStyle;
  static final TextStyle _darkScreenTitleTextStyle = TextStyle(
      fontSize: 17.0,
      color: _darkOnPrimaryColor,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w400);
  static final TextStyle _darkScreenSubTitleTextStyle = TextStyle(
      fontSize: 16.0,
      color: _darkOnPrimaryColor,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w300);
  static final TextStyle _darkScreenHeadline1TextStyle = TextStyle(
      fontSize: 20.0,
      color: _darkOnPrimaryColor,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w400);
}
