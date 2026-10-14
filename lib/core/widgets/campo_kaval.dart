import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/kaval_colors.dart';
import '../theme/kaval_medidas.dart';
import '../theme/kaval_paleta.dart';
import '../theme/kaval_texto.dart';

/// Borde de los campos. El foco es coral, igual que en el registro.
InputDecoration decoracionCampo(
  BuildContext context, {
  IconData? icono,
  Widget? suffix,
  String? hint,
  bool rellenoBlanco = true,
}) {
  final paleta = KavalPaleta.de(context);
  final radio = const BorderRadius.all(Radius.circular(KavalMedidas.radioCampo));
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: rellenoBlanco ? paleta.superficie : paleta.campo,
    prefixIcon: icono == null ? null : Icon(icono, color: paleta.gris),
    suffixIcon: suffix,
    hintStyle: KavalTexto.cuerpo(),
    contentPadding: const EdgeInsets.symmetric(horizontal: KavalMedidas.md, vertical: KavalMedidas.md),
    border: OutlineInputBorder(borderRadius: radio, borderSide: BorderSide(color: paleta.borde)),
    enabledBorder: OutlineInputBorder(borderRadius: radio, borderSide: BorderSide(color: paleta.borde)),
    focusedBorder: OutlineInputBorder(
      borderRadius: radio,
      borderSide: BorderSide(color: paleta.coral, width: 1.6),
    ),
    errorBorder: OutlineInputBorder(borderRadius: radio, borderSide: BorderSide(color: paleta.rojo)),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radio,
      borderSide: BorderSide(color: paleta.rojo, width: 1.6),
    ),
    errorStyle: GoogleFonts.nunito(fontSize: 12, color: paleta.rojo),
    errorMaxLines: 3,
  );
}

class EtiquetaCampo extends StatelessWidget {
  const EtiquetaCampo(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: KavalMedidas.xs),
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
