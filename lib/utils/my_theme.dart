import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
   static MaterialColor primaryColor1 = Colors.blue;

  static TextStyle regularTextStyle(
      {Color? color,
        double? fontSize,
        FontWeight? fontWeight,
        double? letterSpacing}) {
    final textScaleFactor = WidgetsBinding.instance?.window.textScaleFactor ?? 1.0;
    return GoogleFonts.poppins(
      color: color ?? Colors.white,
      fontSize: fontSize != null ? fontSize / textScaleFactor : 15,
      fontWeight: fontWeight ?? FontWeight.normal,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle labelTextStyle(
      {Color? color,
        double? textSize,
        FontWeight? fontWeight,
        double? letterSpacing}) {
    final textScaleFactor = WidgetsBinding.instance.window.textScaleFactor ?? 1.0;
    return GoogleFonts.roboto(
      color: color ?? const Color(0XFF3A3A3A).withOpacity(0.8),
      fontSize: textSize != null ? textSize / textScaleFactor : 15,
      fontWeight: fontWeight ?? FontWeight.normal,
      letterSpacing: letterSpacing,
    );
  }

}
