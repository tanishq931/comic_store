import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle heading(
    {Color color = Colors.white, FontWeight weight = FontWeight.normal,double size=16}) {
  return GoogleFonts.poppins(
      color: color, textStyle: TextStyle(fontWeight: weight,fontSize: size));
}
