import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class StyledText extends Text {
  StyledText(String data, TextStyle style)
      : super(data,
            style: GoogleFonts.montserrat(
                fontWeight: style.fontWeight,
                textStyle:style));
}
