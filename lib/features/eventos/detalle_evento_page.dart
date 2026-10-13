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
import '../../models/evento.dart';
import '../../models/gasto.dart';
import '../../state/kaval_state.dart';

class DetalleEventoPage extends StatelessWidget {
  const DetalleEventoPage({super.key, required this.eventoId});

  final String eventoId;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = context.watch<KavalState>();
    final evento = estado.buscar(eventoId);
    if (evento == null) {
      return Scaffold(body: Center(child: Text(textos.sinEventos)));
    }
    final resultado = calcularLiquidacion(evento);
    final saldo = resultado.saldoDe(estado.usuario.id);
    return Scaffold(
      backgroundColor: KavalColors.crema,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _Encabezado(evento: evento)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: TarjetaKaval(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text('${evento.nombre} ${evento.emoji}', style: KavalTexto.titulo(size: 22)),
                              ),
                              _Nube(texto: textos.sincronizado),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            textos.metaEvento(
                              rangoFechas(evento.inicio, evento.fin, estado.idioma),
                              evento.integrantes.length,
                            ),
                            style: KavalTexto.cuerpo(size: 13),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _Metrica(textos.total, usd(resultado.totalGastos), KavalColors.marino),
                              _Metrica(textos.tuParte, usd(resultado.parteDe(estado.usuario.id)), KavalColors.marino),
                              _Metrica(
                                saldo < 0 ? textos.debes('').trim() : textos.teDeben('').trim(),
                                usd(saldo.abs()),
                                saldo < 0 ? KavalColors.rojo : KavalColors.verde,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
                    child: Row(
                      children: [
                        Text(textos.saldosPersona, style: KavalTexto.titulo(size: 18)),
                        const Spacer(),
                        TextButton(
                          onPressed: () => context.push('/evento/$eventoId/liquidar'),
                          child: Text('${textos.liquidar} →', style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.coral)),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 118,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: evento.integrantes.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, indice) {
                        final persona = evento.integrantes[indice];
                        final valor = resultado.saldoDe(persona.id);
                        final eresTu = persona.id == estado.usuario.id;
                        return Container(
                          width: 84,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: eresTu ? KavalColors.coral : KavalColors.borde,
                              width: eresTu ? 1.6 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              avatarDe(persona, tamano: 36),
                              const SizedBox(height: 6),
                              Text(
                                etiquetaIntegrante(textos, persona, estado.usuario.id),
                                style: KavalTexto.cuerpo(size: 12, color: KavalColors.marino, weight: FontWeight.w800),
                              ),
                              Text(
                                usd(valor, conSigno: true),
                                style: KavalTexto.cuerpo(size: 12, weight: FontWeight.w800, color: colorSegunSigno(valor)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      children: [
                        Text(textos.gastosCount(evento.gastos.length), style: KavalTexto.titulo(size: 18)),
                        const Spacer(),
                        Text(textos.masRecientes, style: KavalTexto.cuerpo(size: 12)),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverList.separated(
                    itemCount: evento.gastos.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, indice) {
                      return _FilaGasto(evento: evento, gasto: evento.gastos[indice]);
                    },
                  ),
                ),
              ],
            ),
          ),
          _BarraAcciones(eventoId: eventoId),
        ],
      ),
    );
  }
}

class _Encabezado extends StatelessWidget {
  const _Encabezado({required this.evento});

  final Evento evento;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: Stack(
        children: [
          Positioned.fill(
            child: IlustracionPortada(portada: evento.portada, alto: 210),
          ),
          Positioned(
            top: 36,
            left: 12,
            right: 12,
            child: Row(
              children: [
                BotonRedondo(icono: Icons.chevron_left, onTap: () => volver(context)),
                const Spacer(),
                BotonRedondo(
                  icono: Icons.ios_share_rounded,
                  onTap: () => context.push('/evento/${evento.id}/resumen'),
                ),
                const SizedBox(width: 8),
                BotonRedondo(
                  icono: Icons.group_outlined,
                  onTap: () => context.push('/evento/${evento.id}/invitar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Nube extends StatelessWidget {
  const _Nube({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: KavalColors.menta, borderRadius: BorderRadius.circular(12)),
      child: Text('☁ $texto', style: KavalTexto.cuerpo(size: 11, weight: FontWeight.w800, color: KavalColors.verde)),
    );
  }
}

class _Metrica extends StatelessWidget {
  const _Metrica(this.titulo, this.valor, this.color);

  final String titulo;
  final String valor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(titulo, style: KavalTexto.cuerpo(size: 12)),
          Text(valor, style: KavalTexto.titulo(size: 16, color: color)),
        ],
      ),
    );
  }
}

class _FilaGasto extends StatelessWidget {
  const _FilaGasto({required this.evento, required this.gasto});

  final Evento evento;
  final Gasto gasto;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final pagador = gasto.pagadorId == null ? null : evento.integrante(gasto.pagadorId!);
    final detalle = gasto.esEfectivoGrupo
        ? textos.efectivoPersonas(gasto.participanteIds.length)
        : textos.pagoPor(pagador?.nombre ?? '', gasto.participanteIds.length);
    return TarjetaKaval(
      radio: 18,
      padding: const EdgeInsets.all(12),
      onTap: gasto.esEfectivoGrupo
          ? () => context.push('/evento/${evento.id}/efectivo')
          : () => context.push('/evento/${evento.id}/gasto?editar=${gasto.id}'),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: KavalColors.durazno, borderRadius: BorderRadius.circular(12)),
            child: Text(gasto.emoji, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(gasto.concepto, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.marino)),
                    ),
                    if (gasto.dictado) ...[
                      const SizedBox(width: 6),
                      _Etiqueta(texto: '🎙️ ${textos.dictado}', color: KavalColors.coral),
                    ],
                    if (gasto.esEfectivoGrupo) ...[
                      const SizedBox(width: 6),
                      _Etiqueta(texto: '💵 ${textos.efectivo}', color: KavalColors.verde),
                    ],
                  ],
                ),
                Text(detalle, style: KavalTexto.cuerpo(size: 12)),
              ],
            ),
          ),
          Text(usd(gasto.montoCentavos), style: KavalTexto.titulo(size: 15)),
        ],
      ),
    );
  }
}

class _Etiqueta extends StatelessWidget {
  const _Etiqueta({required this.texto, required this.color});

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(texto, style: KavalTexto.cuerpo(size: 10, weight: FontWeight.w800, color: color)),
    );
  }
}

class _BarraAcciones extends StatelessWidget {
  const _BarraAcciones({required this.eventoId});

  final String eventoId;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: BotonBlanco(
              texto: textos.liquidar,
              icono: const Icon(Icons.sync_alt, size: 18),
              onPressed: () => context.push('/evento/$eventoId/liquidar'),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: KavalColors.coral,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.push('/evento/$eventoId/dictar'),
              child: const SizedBox(width: 58, height: 58, child: Icon(Icons.mic_rounded, color: Colors.white)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: BotonCoral(
              texto: textos.gasto,
              icono: const Icon(Icons.add, color: Colors.white),
              onPressed: () => context.push('/evento/$eventoId/gasto'),
            ),
          ),
        ],
      ),
    );
  }
}
