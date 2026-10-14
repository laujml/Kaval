import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'kaval_medidas.dart';
import 'kaval_paleta.dart';

/// Tema claro de los mockups y el mismo sistema en oscuro.
ThemeData temaKaval({Brightness brillo = Brightness.light}) {
  final oscuro = brillo == Brightness.dark;
  final paleta = oscuro ? KavalPaleta.oscura : KavalPaleta.clara;
  final scheme = ColorScheme(
    brightness: brillo,
    primary: paleta.coral,
    onPrimary: Colors.white,
    secondary: paleta.menta,
    onSecondary: paleta.marino,
    error: paleta.rojo,
    onError: oscuro ? const Color(0xFF1C1714) : Colors.white,
    surface: paleta.superficie,
    onSurface: paleta.marino,
  );
  final texto = _texto(paleta);
  final radioCampo = BorderRadius.circular(KavalMedidas.radioCampo);
  final borde = OutlineInputBorder(borderRadius: radioCampo, borderSide: BorderSide(color: paleta.borde));

  return ThemeData(
    useMaterial3: true,
    brightness: brillo,
    colorScheme: scheme,
    scaffoldBackgroundColor: paleta.crema,
    extensions: [paleta],
    textTheme: texto,
    fontFamily: GoogleFonts.nunito().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: paleta.crema,
      foregroundColor: paleta.marino,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: texto.titleLarge,
      iconTheme: IconThemeData(color: paleta.marino),
    ),
    cardTheme: CardThemeData(
      color: paleta.superficie,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KavalMedidas.radioTarjeta)),
    ),
    dividerColor: paleta.borde,
    splashColor: paleta.coral.withValues(alpha: 0.08),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(minimumSize: const Size(KavalMedidas.toque, KavalMedidas.toque)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: paleta.coral,
        minimumSize: const Size(KavalMedidas.toque, KavalMedidas.toque),
        textStyle: texto.labelLarge,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: paleta.coral,
        foregroundColor: Colors.white,
        minimumSize: const Size(KavalMedidas.toque, KavalMedidas.altoBoton),
        textStyle: texto.labelLarge?.copyWith(color: Colors.white),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(KavalMedidas.radioBoton))),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: paleta.marino,
        backgroundColor: paleta.superficie,
        minimumSize: const Size(KavalMedidas.toque, KavalMedidas.altoBoton),
        side: BorderSide(color: paleta.borde),
        textStyle: texto.labelLarge,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(KavalMedidas.radioCampo))),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: paleta.superficie,
      selectedColor: paleta.marino,
      labelStyle: texto.labelLarge!,
      side: BorderSide(color: paleta.borde),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KavalMedidas.radioChip)),
      padding: const EdgeInsets.symmetric(horizontal: KavalMedidas.sm, vertical: KavalMedidas.xs),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: paleta.superficie,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: texto.titleLarge,
      contentTextStyle: texto.bodyMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KavalMedidas.radioTarjeta)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: paleta.superficie,
      hintStyle: texto.bodyMedium?.copyWith(color: paleta.gris),
      contentPadding: const EdgeInsets.symmetric(horizontal: KavalMedidas.md, vertical: KavalMedidas.md),
      border: borde,
      enabledBorder: borde,
      focusedBorder: borde.copyWith(borderSide: BorderSide(color: paleta.coral, width: 1.6)),
      errorBorder: borde.copyWith(borderSide: BorderSide(color: paleta.rojo)),
      focusedErrorBorder: borde.copyWith(borderSide: BorderSide(color: paleta.rojo, width: 1.6)),
      errorStyle: texto.bodySmall?.copyWith(color: paleta.rojo),
      errorMaxLines: 3,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: oscuro ? paleta.superficie : paleta.marino,
      contentTextStyle: texto.bodyMedium?.copyWith(color: oscuro ? paleta.marino : Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KavalMedidas.radioCampo)),
    ),
  );
}

TextTheme _texto(KavalPaleta paleta) {
  TextStyle titulo(double size) {
    return GoogleFonts.poppins(fontSize: size, fontWeight: FontWeight.w700, color: paleta.marino, height: 1.15);
  }

  TextStyle cuerpo(double size, {FontWeight weight = FontWeight.w600}) {
    return GoogleFonts.nunito(fontSize: size, fontWeight: weight, color: paleta.marino, height: 1.3);
  }

  return TextTheme(
    headlineMedium: titulo(28),
    titleLarge: titulo(18),
    titleMedium: titulo(16),
    bodyLarge: cuerpo(16),
    bodyMedium: cuerpo(14).copyWith(color: paleta.gris),
    bodySmall: cuerpo(12),
    labelLarge: cuerpo(16, weight: FontWeight.w800),
  );
}
