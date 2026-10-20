import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_medidas.dart';
import '../../core/theme/kaval_paleta.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/utils/fechas.dart';
import '../../core/widgets/boton_coral.dart';
import '../../core/widgets/estado_vacio.dart';
import '../../core/widgets/fila_monto.dart';
import '../../core/widgets/tarjeta_kaval.dart';
import '../../l10n/app_localizations.dart';
import '../../models/evento.dart';
import '../../state/kaval_state.dart';

class HistorialPage extends StatelessWidget {
  const HistorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = context.watch<KavalState>();
    final paleta = KavalPaleta.de(context);
    final historial = estado.eventosHistorial;
    final vacio = historial.isEmpty;
    return Scaffold(
      body: SafeArea(
        child: MarcoKaval(
          child: ListView.builder(
            padding: KavalMedidas.pagina,
            itemCount: vacio ? 2 : historial.length + 1,
            itemBuilder: (context, indice) {
              if (indice == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: KavalMedidas.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(textos.historial, style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: KavalMedidas.xxs),
                      Text(textos.viajesRecientes, style: KavalTexto.cuerpo(color: paleta.gris)),
                    ],
                  ),
                );
              }
              if (vacio) {
                final sinNada = estado.eventos.isEmpty;
                return EstadoVacio(
                  icono: Icons.luggage_outlined,
                  titulo: sinNada ? textos.sinEventos : textos.historial,
                  cuerpo: sinNada ? textos.sinEventosCuerpo : textos.historialVacio,
                  accion: BotonCoral(
                    texto: sinNada ? textos.nuevoEvento : textos.eventosActivos,
                    icono: Icon(sinNada ? Icons.add : Icons.event_available_outlined, color: Colors.white),
                    onPressed: () => sinNada ? context.push('/nuevo-evento') : context.go('/inicio'),
                  ),
                );
              }
              final evento = historial[indice - 1];
              return Padding(
                padding: const EdgeInsets.only(bottom: KavalMedidas.sm),
                child: _Viaje(evento: evento, idioma: estado.idioma),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Viaje extends StatelessWidget {
  const _Viaje({required this.evento, required this.idioma});

  final Evento evento;
  final String idioma;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final lugar = evento.lugar.trim();
    final fechas = rangoFechas(evento.inicio, evento.fin, idioma);
    return TarjetaKaval(
      onTap: () => context.push('/evento/${evento.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(evento.nombre, style: KavalTexto.titulo(size: 18, color: KavalColors.marino)),
          Text(
            lugar.isEmpty ? fechas : textos.lugarFecha(lugar, fechas),
            style: KavalTexto.cuerpo(size: 12, color: KavalColors.gris),
          ),
          const SizedBox(height: KavalMedidas.xs),
          FilaMonto(etiqueta: textos.total, centavos: evento.totalCentavos, conSigno: false, neutro: true),
          if (evento.gastos.isNotEmpty) const Divider(height: 20),
          for (final gasto in evento.gastos)
            Padding(
              padding: const EdgeInsets.only(bottom: KavalMedidas.xs),
              child: FilaMonto(
                etiqueta: gasto.concepto,
                centavos: gasto.montoCentavos,
                conSigno: false,
                neutro: true,
                detalle: fechaConAnio(gasto.fecha, idioma),
              ),
            ),
        ],
      ),
    );
  }
}
