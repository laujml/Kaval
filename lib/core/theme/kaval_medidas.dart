import 'package:flutter/material.dart';

/// Espaciados, radios y tamaños de los mockups. No se repiten números en las pantallas nuevas.
class KavalMedidas {
  const KavalMedidas._();

  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const xxl = 32.0;

  static const radioChip = 12.0;
  static const radioCampo = 16.0;
  static const radioTarjeta = 24.0;
  static const radioBoton = 28.0;
  static const toque = 48.0;
  static const altoBoton = 54.0;
  static const anchoLectura = 640.0;

  static const pagina = EdgeInsets.fromLTRB(lg, md, lg, xl);
  static const sombra = BoxShadow(
    color: Color(0x141F2A3B),
    blurRadius: 24,
    offset: Offset(0, 10),
  );
}
