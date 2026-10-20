import 'package:flutter/material.dart';

import '../../core/theme/kaval_medidas.dart';
import '../../core/theme/kaval_paleta.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/utils/dinero.dart';
import '../../l10n/app_localizations.dart';

class DeudaResumen {
  const DeudaResumen(this.nombre, this.centavos);

  final String nombre;
  final int centavos;
}

/// Frase que se muestra antes de guardar, a partir de las cuotas ya calculadas.
String textoResumen({
  required AppLocalizations textos,
  required bool efectivo,
  required bool soyYo,
  required String nombrePagador,
  required int total,
  required List<DeudaResumen> deudas,
}) {
  if (total <= 0) return '';
  final totalTexto = usd(total);
  final positivas = [for (final deuda in deudas) if (deuda.centavos > 0) deuda];
  if (positivas.isEmpty) {
    return efectivo ? '' : (soyYo ? textos.resumenSoloTu(totalTexto) : textos.resumenOtroSolo(nombrePagador, totalTexto));
  }
  final cuota = positivas.first.centavos;
  final iguales = positivas.every((deuda) => deuda.centavos == cuota);
  final nombres = unirLista([for (final deuda in positivas) deuda.nombre], textos.conjuncion);
  if (iguales) {
    final cuotaTexto = usd(cuota);
    if (efectivo) return textos.resumenEfectivoIgual(cuotaTexto);
    if (soyYo) return textos.resumenPagasteIgual(totalTexto, nombres, cuotaTexto);
    return textos.resumenOtroIgual(nombrePagador, totalTexto, nombres, cuotaTexto);
  }
  final detalle = unirLista(
    [for (final deuda in positivas) '${deuda.nombre} ${usd(deuda.centavos)}'],
    textos.conjuncion,
  );
  if (efectivo) return textos.resumenEfectivoVarios(detalle);
  if (soyYo) return textos.resumenPagasteVarios(totalTexto, detalle);
  return textos.resumenOtroVarios(nombrePagador, totalTexto, detalle);
}

String unirLista(List<String> partes, String conjuncion) {
  if (partes.isEmpty) return '';
  if (partes.length == 1) return partes.first;
  if (partes.length == 2) return '${partes[0]} $conjuncion ${partes[1]}';
  return '${partes.sublist(0, partes.length - 1).join(', ')} $conjuncion ${partes.last}';
}

class TarjetaResumen extends StatelessWidget {
  const TarjetaResumen({super.key, required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    if (texto.isEmpty) return const SizedBox.shrink();
    final paleta = KavalPaleta.de(context);
    return Semantics(
      liveRegion: true,
      label: texto,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(KavalMedidas.md),
        decoration: BoxDecoration(
          color: paleta.menta,
          borderRadius: BorderRadius.circular(KavalMedidas.radioCampo),
        ),
        child: Text(texto, style: KavalTexto.cuerpo(color: paleta.marino, weight: FontWeight.w800)),
      ),
    );
  }
}
