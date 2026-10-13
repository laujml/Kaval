import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'kaval_colors.dart';

/// Material 3 con el coral como color de acción.
/// Poppins y Nunito se aplican en KavalTexto; el tema solo fija el color.
ThemeData temaKaval() {
  final base = ColorScheme.fromSeed(seedColor: KavalColors.coral);
  final nunito = GoogleFonts.nunito().fontFamily;

  return ThemeData(
    useMaterial3: true,
    colorScheme: base.copyWith(
      primary: KavalColors.coral,
      onPrimary: Colors.white,
      secondary: KavalColors.menta,
      surface: Colors.white,
      error: KavalColors.rojo,
    ),
    scaffoldBackgroundColor: KavalColors.crema,
    fontFamily: nunito,
    appBarTheme: AppBarTheme(
      backgroundColor: KavalColors.crema,
      foregroundColor: KavalColors.marino,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: KavalColors.marino,
      ),
    ),
    dividerColor: KavalColors.borde,
    splashColor: KavalColors.coral.withValues(alpha: 0.08),
  );
}
