import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/kaval_colors.dart';
import '../theme/kaval_texto.dart';

/// Borde de los campos. El foco es coral, igual que en el registro de la semana 7.
InputDecoration decoracionCampo({
  IconData? icono,
  Widget? suffix,
  String? hint,
  bool rellenoBlanco = true,
}) {
  const radio = BorderRadius.all(Radius.circular(16));
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: rellenoBlanco ? Colors.white : KavalColors.campo,
    prefixIcon: icono == null ? null : Icon(icono, color: KavalColors.gris),
    suffixIcon: suffix,
    hintStyle: KavalTexto.cuerpo(),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: const OutlineInputBorder(
      borderRadius: radio,
      borderSide: BorderSide(color: KavalColors.borde),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: radio,
      borderSide: BorderSide(color: KavalColors.borde),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: radio,
      borderSide: BorderSide(color: KavalColors.coral, width: 1.6),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: radio,
      borderSide: BorderSide(color: KavalColors.rojo),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: radio,
      borderSide: BorderSide(color: KavalColors.rojo, width: 1.6),
    ),
    errorStyle: GoogleFonts.nunito(fontSize: 12, color: KavalColors.rojo),
    errorMaxLines: 3,
  );
}

class EtiquetaCampo extends StatelessWidget {
  const EtiquetaCampo(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: KavalTexto.cuerpo(
          color: KavalColors.marino,
          weight: FontWeight.w700,
        ),
      ),
    );
  }
}
