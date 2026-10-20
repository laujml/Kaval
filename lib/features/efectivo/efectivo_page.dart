import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
import '../../core/widgets/tarjeta_kaval.dart';
import '../../l10n/app_localizations.dart';
import '../../models/gasto.dart';
import '../../state/kaval_state.dart';

class EfectivoPage extends StatelessWidget {
  const EfectivoPage({super.key, required this.eventoId});

  final String eventoId;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = context.watch<KavalState>();
    final evento = estado.buscar(eventoId);
    if (evento == null) return Scaffold(body: Center(child: Text(textos.sinEventos)));
    final resultado = calcularLiquidacion(evento);
    final custodio = evento.integrante(evento.custodioId);
    final porcentaje = resultado.reunido == 0 ? 0 : ((resultado.sobrante * 100) / resultado.reunido).round();
    final enEfectivo = evento.gastos.where((g) => g.esEfectivoGrupo).toList();

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
                  Expanded(child: Text(textos.efectivoTitulo, textAlign: TextAlign.center, style: KavalTexto.titulo(size: 18))),
                  BotonRedondo(icono: Icons.help_outline, onTap: () => mostrarAviso(context, textos.ayudaEfectivo)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: KavalColors.menta, borderRadius: BorderRadius.circular(28)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const ExcludeSemantics(child: Icon(Icons.payments_outlined, color: KavalColors.verde, size: 18)),
                                      const SizedBox(width: 6),
                                      Text(textos.efectivoTitulo, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.verde)),
                                    ],
                                  ),
                                  Text(textos.efectivoDisponible, style: KavalTexto.cuerpo()),
                                  Text(usd(resultado.sobrante), style: KavalTexto.titulo(size: 36)),
                                  Text(textos.deReunidos(usd(resultado.reunido)), style: KavalTexto.cuerpo()),
                                ],
                              ),
                            ),
                            IlustracionBilletera(semanticsLabel: textos.efectivoTitulo),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: resultado.reunido == 0 ? 0 : resultado.sobrante / resultado.reunido,
                            minHeight: 8,
                            backgroundColor: Colors.white,
                            color: KavalColors.verde,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(textos.quedaPorcentaje(porcentaje), style: KavalTexto.cuerpo(size: 12, weight: FontWeight.w800, color: KavalColors.marino)),
                            const Spacer(),
                            Text(textos.gastadoMonto(usd(resultado.gastadoEfectivo)), style: KavalTexto.cuerpo(size: 12)),
                          ],
                        ),
                        if (custodio != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              avatarDe(custodio, tamano: 28),
                              const SizedBox(width: 8),
                              Text(textos.loGuarda(custodio.nombre), style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(textos.quienAporto, style: KavalTexto.titulo(size: 18)),
                      const Spacer(),
                      Text(textos.aporte, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.coral)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (final aporte in evento.aportes)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TarjetaKaval(
                        radio: 18,
                        child: Row(
                          children: [
                            avatarDe(evento.integrante(aporte.integranteId)!, tamano: 40),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(evento.integrante(aporte.integranteId)!.nombre, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.marino)),
                                  Text(textoAporte(textos, aporte.descripcion), style: KavalTexto.cuerpo(size: 12)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(usd(aporte.montoCentavos), style: KavalTexto.titulo(size: 16)),
                                Text(
                                  textos.delFondo(resultado.reunido == 0 ? 0 : ((aporte.montoCentavos * 100) / resultado.reunido).round()),
                                  style: KavalTexto.cuerpo(size: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(textos.pagadoEfectivo, style: KavalTexto.titulo(size: 18)),
                      const Spacer(),
                      Text(usd(resultado.gastadoEfectivo), style: KavalTexto.cuerpo()),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (final gasto in enEfectivo) _GastoEfectivo(gasto: gasto, idioma: estado.idioma),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: BotonBlanco(
                      texto: textos.aporte,
                      onPressed: () => mostrarAviso(context, textos.ayudaEfectivo),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: BotonCoral(
                      texto: textos.gastoEnEfectivo,
                      onPressed: () => context.push('/evento/$eventoId/gasto'),
                    ),
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

class _GastoEfectivo extends StatelessWidget {
  const _GastoEfectivo({required this.gasto, required this.idioma});

  final Gasto gasto;
  final String idioma;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TarjetaKaval(
        radio: 18,
        child: Row(
          children: [
            IconoCategoria(
              categoria: gasto.categoria,
              tamano: 28,
              color: KavalColors.coral,
              etiqueta: nombreCategoria(textos, gasto.categoria),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(gasto.concepto, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.marino)),
                  Text(
                    '${textos.personasCount(gasto.participanteIds.length)} · ${fechaConAnio(gasto.fecha, idioma)}',
                    style: KavalTexto.cuerpo(size: 12),
                  ),
                ],
              ),
            ),
            Text(usd(gasto.montoCentavos), style: KavalTexto.titulo(size: 16)),
          ],
        ),
      ),
    );
  }
}
