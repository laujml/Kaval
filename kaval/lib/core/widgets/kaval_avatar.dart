import 'package:flutter/material.dart';

import '../../models/integrante.dart';
import '../theme/kaval_colors.dart';
import '../theme/kaval_texto.dart';

KavalAvatar avatarDe(
  Integrante persona, {
  double tamano = 44,
  bool seleccionado = false,
}) {
  return KavalAvatar(
    inicial: persona.inicial,
    fondo: Color(persona.colorFondo),
    tinta: Color(persona.colorInicial),
    tamano: tamano,
    seleccionado: seleccionado,
  );
}

/// Círculo pastel con la inicial. Más adelante puede llevar ilustración.
class KavalAvatar extends StatelessWidget {
  const KavalAvatar({
    super.key,
    required this.inicial,
    required this.fondo,
    required this.tinta,
    this.tamano = 44,
    this.seleccionado = false,
  });

  final String inicial;
  final Color fondo;
  final Color tinta;
  final double tamano;
  final bool seleccionado;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fondo,
        shape: BoxShape.circle,
        border: seleccionado
            ? Border.all(color: KavalColors.coral, width: 2.4)
            : null,
      ),
      child: Text(
        inicial,
        style: KavalTexto.titulo(
          size: tamano * 0.38,
          color: tinta,
          weight: FontWeight.w700,
        ),
      ),
    );
  }
}
