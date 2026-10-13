import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/utils/fechas.dart';
import '../../core/widgets/fila_monto.dart';
import '../../core/widgets/tarjeta_kaval.dart';
import '../../l10n/app_localizations.dart';
import '../../state/kaval_state.dart';

class HistorialPage extends StatelessWidget {
  const HistorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = context.watch<KavalState>();
    return Scaffold(
      backgroundColor: KavalColors.crema,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text(textos.historial, style: KavalTexto.titulo(size: 28)),
            const SizedBox(height: 4),
            Text(textos.viajesRecientes, style: KavalTexto.cuerpo()),
            const SizedBox(height: 16),
            for (final evento in estado.eventos) ...[
              TarjetaKaval(
                onTap: () => context.push('/evento/${evento.id}'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${evento.nombre} ${evento.emoji}', style: KavalTexto.titulo(size: 18)),
                    Text(
                      textos.lugarFecha(evento.lugar, rangoFechas(evento.inicio, evento.fin, estado.idioma)),
                      style: KavalTexto.cuerpo(size: 12),
                    ),
                    const SizedBox(height: 8),
                    FilaMonto(
                      etiqueta: textos.total,
                      centavos: evento.totalCentavos,
                      conSigno: false,
                      neutro: true,
                    ),
                    const Divider(height: 20),
                    for (final gasto in evento.gastos)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: FilaMonto(
                          etiqueta: '${gasto.emoji} ${gasto.concepto}',
                          centavos: gasto.montoCentavos,
                          conSigno: false,
                          neutro: true,
                          detalle: fechaConAnio(gasto.fecha, estado.idioma),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
