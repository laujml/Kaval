import 'package:flutter/material.dart';

/// Paleta de los mockups. Un solo acento (coral) y fondos pastel.
class KavalColors {
  const KavalColors._();

  static const crema = Color(0xFFFFF8F0);
  static const coral = Color(0xFFFF6B4A);
  static const menta = Color(0xFFDFF5EB);
  static const durazno = Color(0xFFFFE9DE);
  static const marino = Color(0xFF1F2A3B);
  static const verde = Color(0xFF1FA971);
  static const rojo = Color(0xFFE5484D);
  static const gris = Color(0xFF8B93A1);
  static const borde = Color(0xFFE4DDD4);
  static const campo = Color(0xFFF4EFE8);
  static const aviso = Color(0xFFFFF4D6);
  static const oro = Color(0xFFE0B15A);
  static const whatsapp = Color(0xFF25D366);

  static const sombra = Color(0x141F2A3B);
}

Color colorSegunSigno(int centavos) {
  if (centavos > 0) return KavalColors.verde;
  if (centavos < 0) return KavalColors.rojo;
  return KavalColors.marino;
}
