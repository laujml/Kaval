import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/compartir/compartir_texto.dart';
import '../../core/compartir/texto_resumen.dart';

import '../../core/liquidacion/liquidacion.dart';
import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/utils/dinero.dart';
import '../../core/utils/etiquetas.dart';
import '../../core/utils/fechas.dart';
import '../../core/widgets/aviso.dart';
import '../../core/widgets/boton_coral.dart';
import '../../core/widgets/ilustraciones.dart';
import '../../core/widgets/kaval_avatar.dart';
import '../../core/widgets/logo_kaval.dart';
import '../../l10n/app_localizations.dart';
import '../../models/gasto.dart';
import '../../state/kaval_state.dart';

class ResumenPage extends StatelessWidget {
  const ResumenPage({super.key, required this.eventoId});

  final String eventoId;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = context.watch<KavalState>();
    final evento = estado.buscar(eventoId);
    if (evento == null) return Scaffold(body: Center(child: Text(textos.sinEventos)));
    final cuentas = calcularSaldos(evento);
    final resultado = cuentas.copyWith(transferencias: liquidar(cuentas.saldos));
    final resumen = textoResumen(textos, evento, resultado);
    final porCategoria = <CategoriaGasto, int>{};
    for (final gasto in evento.gastos) {
      porCategoria[gasto.categoria] = (porCategoria[gasto.categoria] ?? 0) + gasto.montoCentavos;
    }

    return Scaffold(
      backgroundColor: KavalColors.menta,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                children: [
                  BotonRedondo(icono: Icons.chevron_left, onTap: () => volver(context)),
                  Expanded(child: Text(textos.resumenViaje, textAlign: TextAlign.center, style: KavalTexto.titulo(size: 18))),
                  const SizedBox(width: 42),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Transform.rotate(
                    angle: -0.03,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [BoxShadow(color: KavalColors.sombra, blurRadius: 24, offset: Offset(0, 12))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: IlustracionPortada(portada: evento.portada, alto: 90),
                          ),
                          const SizedBox(height: 8),
                          Text(fechaConAnio(evento.inicio, estado.idioma), style: KavalTexto.cuerpo(size: 12)),
                          Text(evento.nombre, style: KavalTexto.titulo(size: 20)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              for (final persona in evento.integrantes) Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: avatarDe(persona, tamano: 28),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(textos.totalViaje, style: KavalTexto.cuerpo(size: 12)),
                          Text(usd(resultado.totalGastos), style: KavalTexto.titulo(size: 26, color: KavalColors.coral)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final entrada in porCategoria.entries)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(color: KavalColors.crema, borderRadius: BorderRadius.circular(12)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconoCategoria(
                                        categoria: entrada.key,
                                        tamano: 16,
                                        color: KavalColors.coral,
                                        etiqueta: nombreCategoria(textos, entrada.key),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(usd(entrada.value), style: KavalTexto.cuerpo(size: 12, color: KavalColors.marino, weight: FontWeight.w800)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(textos.quienSeccion, style: KavalTexto.cuerpo(size: 11, weight: FontWeight.w800, color: KavalColors.gris)),
                          for (final pago in resultado.transferencias)
                            Text(
                              '${evento.integrante(pago.deudorId)?.nombre ?? ''} → ${evento.integrante(pago.acreedorId)?.nombre ?? ''} ${usd(pago.montoCentavos)}',
                              style: KavalTexto.cuerpo(size: 13, color: KavalColors.marino),
                            ),
                          const SizedBox(height: 8),
                          Text(textos.hechoCon(usd(resultado.sobrante)), style: KavalTexto.cuerpo(size: 12)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(child: Text(textos.vistaPrevia, style: KavalTexto.cuerpo(size: 12))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                children: [
                  FilledButton.icon(
                    onPressed: () => unawaited(compartirTexto(context, resumen)),
                    style: FilledButton.styleFrom(
                      backgroundColor: KavalColors.whatsapp,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    icon: const Icon(Icons.chat_rounded, color: Colors.white),
                    label: Text(textos.compartirWhatsapp, style: KavalTexto.cuerpo(size: 16, weight: FontWeight.w800, color: Colors.white)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: BotonBlanco(texto: textos.imagen, onPressed: () => unawaited(compartirTexto(context, resumen)))),
                      const SizedBox(width: 8),
                      Expanded(child: BotonBlanco(texto: textos.texto, onPressed: () => unawaited(compartirTexto(context, resumen)))),
                      const SizedBox(width: 8),
                      Expanded(child: BotonBlanco(texto: '${textos.pdf} ${textos.pro}', onPressed: () => mostrarAviso(context, textos.proAviso))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
