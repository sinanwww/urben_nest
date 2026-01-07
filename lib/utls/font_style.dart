import 'package:flutter/material.dart';

class Fontstyle extends TextStyle {
  Fontstyle({FontWeight? fontWeight, double? fontSize, Color? color})
    : super(
        fontFamily: 'Poppins',
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
      );

  Fontstyle.light({FontWeight? fontWeight, double? fontSize})
    : super(
        fontFamily: 'Poppins',
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight ?? FontWeight.w300,
        fontSize: fontSize,
        color: Colors.black,
      );

  Fontstyle.dark({FontWeight? fontWeight, double? fontSize})
    : super(
        fontFamily: 'Poppins',
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight ?? FontWeight.w300,
        fontSize: fontSize,
        color: Colors.white,
      );
}
