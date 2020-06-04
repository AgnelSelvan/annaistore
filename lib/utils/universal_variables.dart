import 'package:flutter/material.dart';

class Variables {
  static final Color greyColor = Color(0xffF7F7F7);
  static final Color blackColor = Color(0xff686868);
  static final Color lightGreyColor = Color(0xffFCFCFC);
  // static const Color primaryColor = Color(0xffFFC300);
  static final Color primaryColor = Colors.yellow[800];
  static const Color lightPrimaryColor = Color(0xffFFD95F);

  static final TextStyle drawerListTextStyle =
      TextStyle(fontSize: 16, letterSpacing: 1, color: Variables.blackColor);
  static final TextStyle appBarTextStyle = TextStyle(
      fontSize: 20,
      letterSpacing: 1,
      color: Variables.primaryColor,
      fontWeight: FontWeight.w400);
  static final TextStyle inputLabelTextStyle =
      TextStyle(fontSize: 16, color: Color(0xff777777), letterSpacing: 0.5);
  static final TextStyle inputTextStyle =
      TextStyle(fontSize: 16, letterSpacing: 0.5, color: Color(0xff333333));
}
