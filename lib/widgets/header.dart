import 'package:annaistore/utils/universal_variables.dart';
import 'package:flutter/material.dart';

class BuildHeader extends StatelessWidget {
  final String text;
  BuildHeader({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 28, color: Variables.blackColor, fontWeight: FontWeight.bold,),
    );
  }
}