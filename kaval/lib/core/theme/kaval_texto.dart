import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'kaval_colors.dart';

/// Poppins para títulos y Nunito para el resto, como en los mockups.
class KavalTexto {
  const KavalTexto._();

  static TextStyle titulo({
    double size = 22,
    FontWeight weight = FontWeight.w700,
    Color color = KavalColors.marino,
    double height = 1.15,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  static TextStyle cuerpo({
    double size = 14,
    FontWeight weight = FontWeight.w600,
    Color color = KavalColors.gris,
    double height = 1.3,
  }) {
    return GoogleFonts.nunito(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }
}
