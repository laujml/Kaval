import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/utils/dinero.dart';
import '../../core/widgets/aviso.dart';
import '../../core/widgets/chip_categoria.dart';
import '../../core/widgets/ilustraciones.dart';
import '../../core/widgets/kaval_avatar.dart';
import '../../data/datos_ejemplo.dart';
import '../../l10n/app_localizations.dart';
import '../../models/evento.dart';
import '../../state/kaval_state.dart';
import '../eventos/tarjeta_evento.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = context.watch<KavalState>();
    final eventos = estado.eventosFiltrados;
    final laura = estado.buscar(idTunco)?.integrante(idLaura);

    return Scaffold(
      backgroundColor: KavalColors.crema,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Row(
              children: [
                if (laura != null) avatarDe(laura, tamano: 52),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(textos.holaNombre(estado.usuario.primerNombre), style: KavalTexto.titulo(size: 22)),
                      Text(textos.aDonde, style: KavalTexto.cuerpo(size: 13)),
                    ],
                  ),
                ),
                Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  child: IconButton(
                    onPressed: () => mostrarAviso(context, textos.sincronizadoHace),
                    icon: const Icon(Icons.notifications_none_rounded, color: KavalColors.marino),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _Balance(
              balance: estado.balanceGeneral,
              teDeben: estado.teDeben,
              debes: estado.debes,
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChipCategoria(
                    texto: textos.todos,
                    activo: estado.filtro == null,
                    oscuro: true,
                    onTap: () => estado.cambiarFiltro(null),
                  ),
                  const SizedBox(width: 8),
                  ChipCategoria(
                    emoji: '🏖️',
                    texto: textos.playa,
                    activo: estado.filtro == PortadaEvento.playa,
                    onTap: () => estado.cambiarFiltro(PortadaEvento.playa),
                  ),
                  const SizedBox(width: 8),
                  ChipCategoria(
                    emoji: '🌋',
                    texto: textos.volcan,
                    activo: estado.filtro == PortadaEvento.volcan,
                    onTap: () => estado.cambiarFiltro(PortadaEvento.volcan),
                  ),
                  const SizedBox(width: 8),
                  ChipCategoria(
                    emoji: '🍽️',
                    texto: textos.comidas,
                    activo: estado.filtro == PortadaEvento.comida,
                    onTap: () => estado.cambiarFiltro(PortadaEvento.comida),
                  ),
                  const SizedBox(width: 8),
                  ChipCategoria(
                    emoji: '🚗',
                    texto: textos.roadTrip,
                    activo: estado.filtro == PortadaEvento.carretera,
                    onTap: () => estado.cambiarFiltro(PortadaEvento.carretera),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Text(textos.eventosActivos, style: KavalTexto.titulo(size: 20)),
                const Spacer(),
                TextButton(
                  onPressed: () => context.go('/eventos'),
                  child: Text(textos.verTodos, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.coral)),
                ),
              ],
            ),
            SizedBox(
              height: 300,
              child: eventos.isEmpty
                  ? Center(child: Text(textos.sinEventos, style: KavalTexto.cuerpo()))
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: eventos.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, indice) {
                        final evento = eventos[indice];
                        return TarjetaEvento(
                          evento: evento,
                          saldoCentavos: estado.saldoEn(evento),
                          idioma: estado.idioma,
                          ancho: 280,
                          onTap: () => context.push('/evento/${evento.id}'),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: KavalColors.menta,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mic_none_rounded, color: KavalColors.verde),
                  const SizedBox(width: 8),
                  Expanded(child: Text(textos.tipVoz, style: KavalTexto.cuerpo(color: KavalColors.marino))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Balance extends StatelessWidget {
  const _Balance({required this.balance, required this.teDeben, required this.debes});

  final int balance;
  final int teDeben;
  final int debes;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8A6A), KavalColors.coral],
        ),
        boxShadow: [
          BoxShadow(
            color: KavalColors.coral.withValues(alpha: 0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(textos.balanceGeneral, style: KavalTexto.cuerpo(color: Colors.white)),
                Text(usd(balance, conSigno: true), style: KavalTexto.titulo(size: 34, color: Colors.white)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Pastilla('↓ ${textos.teDeben(usd(teDeben))}'),
                    _Pastilla('↑ ${textos.debes(usd(debes))}'),
                  ],
                ),
              ],
            ),
          ),
          const IlustracionMonedas(),
        ],
      ),
    );
  }
}

class _Pastilla extends StatelessWidget {
  const _Pastilla(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(texto, style: KavalTexto.cuerpo(size: 12, weight: FontWeight.w800, color: Colors.white)),
    );
  }
}
