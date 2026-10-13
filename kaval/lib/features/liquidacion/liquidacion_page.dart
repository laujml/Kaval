import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/liquidacion/liquidacion.dart';
import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/utils/dinero.dart';
import '../../core/widgets/aviso.dart';
import '../../core/widgets/boton_coral.dart';
import '../../core/widgets/ilustraciones.dart';
import '../../core/widgets/kaval_avatar.dart';
import '../../core/widgets/logo_kaval.dart';
import '../../core/widgets/tarjeta_kaval.dart';
import '../../l10n/app_localizations.dart';
import '../../models/transferencia.dart';
import '../../state/kaval_state.dart';

class LiquidacionPage extends StatelessWidget {
  const LiquidacionPage({super.key, required this.eventoId});

  final String eventoId;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = context.watch<KavalState>();
    final evento = estado.buscar(eventoId);
    if (evento == null) return Scaffold(body: Center(child: Text(textos.sinEventos)));
    final resultado = calcularLiquidacion(evento);
    final devoluciones = resultado.devolucion.entries.where((e) => e.value > 0).map((e) {
      final nombre = evento.integrante(e.key)?.nombre ?? e.key;
      return '$nombre ${usd(e.value)}';
    }).join(' · ');

    return Scaffold(
      backgroundColor: KavalColors.crema,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                children: [
                  BotonRedondo(icono: Icons.chevron_left, onTap: () => volver(context)),
                  Expanded(child: Text(textos.liquidacion, textAlign: TextAlign.center, style: KavalTexto.titulo(size: 18))),
                  BotonRedondo(icono: Icons.ios_share_rounded, onTap: () => context.push('/evento/$eventoId/resumen')),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: KavalColors.menta, borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(textos.quienPaga, style: KavalTexto.titulo(size: 22)),
                              const SizedBox(height: 4),
                              Text(
                                textos.eventoTotal(evento.nombre, usd(resultado.totalGastos)),
                                style: KavalTexto.cuerpo(color: KavalColors.marino),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '✨ ${textos.soloTransferencias(resultado.transferencias.length)}',
                                style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.verde),
                              ),
                            ],
                          ),
                        ),
                        const IlustracionMonedas(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final pago in resultado.transferencias)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _Pago(
                        eventoId: eventoId,
                        pago: pago,
                        eresTu: pago.deudorId == estado.usuario.id,
                      ),
                    ),
                  if (resultado.sobrante > 0)
                    GestureDetector(
                      onTap: () => context.push('/evento/$eventoId/efectivo'),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: KavalColors.aviso, borderRadius: BorderRadius.circular(18)),
                        child: Text(
                          '💵 ${textos.efectivoSobrante(usd(resultado.sobrante))}\n${textos.seDevuelven(devoluciones)}',
                          style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: BotonCoral(
                texto: textos.compartirResumen,
                icono: const Icon(Icons.chat_rounded, color: Colors.white),
                onPressed: () => context.push('/evento/$eventoId/resumen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pago extends StatelessWidget {
  const _Pago({required this.eventoId, required this.pago, required this.eresTu});

  final String eventoId;
  final Transferencia pago;
  final bool eresTu;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = context.watch<KavalState>();
    final evento = estado.buscar(eventoId)!;
    final deudor = evento.integrante(pago.deudorId);
    final acreedor = evento.integrante(pago.acreedorId);
    final pagada = estado.estaPagada(eventoId, pago);
    final frase = eresTu
        ? textos.tuLePagas(acreedor?.nombre ?? '')
        : textos.lePagaA(deudor?.nombre ?? '', acreedor?.nombre ?? '');

    return TarjetaKaval(
      radio: 20,
      color: eresTu ? KavalColors.durazno : Colors.white,
      borde: eresTu ? Border.all(color: KavalColors.coral, width: 1.4) : null,
      child: Row(
        children: [
          if (deudor != null) avatarDe(deudor, tamano: 36),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Icon(Icons.arrow_forward, size: 16, color: KavalColors.gris),
          ),
          if (acreedor != null) avatarDe(acreedor, tamano: 36),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(frase, style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800)),
                Text(usd(pago.montoCentavos), style: KavalTexto.titulo(size: 18)),
              ],
            ),
          ),
          if (eresTu)
            FilledButton(
              onPressed: () {
                estado.marcarPagada(eventoId, pago);
                mostrarAviso(context, textos.resumenListo);
              },
              style: FilledButton.styleFrom(backgroundColor: KavalColors.coral),
              child: Text(textos.pagar),
            )
          else
            IconButton(
              onPressed: () => estado.marcarPagada(eventoId, pago),
              icon: Icon(
                pagada ? Icons.check_circle : Icons.circle_outlined,
                color: pagada ? KavalColors.verde : KavalColors.gris,
              ),
            ),
        ],
      ),
    );
  }
}
