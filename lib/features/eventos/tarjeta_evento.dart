import 'package:flutter/material.dart';

import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/utils/dinero.dart';
import '../../core/utils/fechas.dart';
import '../../core/widgets/ilustraciones.dart';
import '../../core/widgets/kaval_avatar.dart';
import '../../core/widgets/tarjeta_kaval.dart';
import '../../l10n/app_localizations.dart';
import '../../models/evento.dart';

/// Tarjeta de viaje del inicio y de la lista de eventos.
class TarjetaEvento extends StatelessWidget {
  const TarjetaEvento({
    super.key,
    required this.evento,
    required this.saldoCentavos,
    required this.idioma,
    this.onTap,
    this.ancho,
  });

  final Evento evento;
  final int saldoCentavos;
  final String idioma;
  final VoidCallback? onTap;
  final double? ancho;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final aFavor = saldoCentavos >= 0;
    final tarjeta = TarjetaKaval(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                IlustracionPortada(portada: evento.portada, alto: 112),
                Positioned(
                  left: 8,
                  top: 8,
                  child: _MarcaSincronizacion(alDia: evento.sincronizado, textos: textos),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${evento.nombre} ${evento.emoji}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: KavalTexto.titulo(size: 16),
          ),
          const SizedBox(height: 2),
          Text(
            textos.lugarFecha(evento.lugar, rangoFechas(evento.inicio, evento.fin, idioma)),
            style: KavalTexto.cuerpo(size: 12),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 28,
                  child: Stack(
                    children: [
                      for (var i = 0; i < evento.integrantes.length && i < 5; i++)
                        Positioned(
                          left: i * 18,
                          child: avatarDe(evento.integrantes[i], tamano: 28),
                        ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(textos.total, style: KavalTexto.cuerpo(size: 11)),
                  Text(usd(evento.totalCentavos), style: KavalTexto.titulo(size: 16)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (aFavor ? KavalColors.verde : KavalColors.rojo).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              aFavor ? textos.teDeben(usd(saldoCentavos)) : textos.debes(usd(-saldoCentavos)),
              style: KavalTexto.cuerpo(
                size: 12,
                weight: FontWeight.w800,
                color: aFavor ? KavalColors.verde : KavalColors.rojo,
              ),
            ),
          ),
        ],
      ),
    );

    if (ancho == null) return tarjeta;
    return SizedBox(width: ancho, height: 292, child: tarjeta);
  }
}

class _MarcaSincronizacion extends StatelessWidget {
  const _MarcaSincronizacion({required this.alDia, required this.textos});

  final bool alDia;
  final AppLocalizations textos;

  @override
  Widget build(BuildContext context) {
    final etiqueta = alDia ? textos.sincronizado : textos.pendiente;
    final color = alDia ? KavalColors.verde : KavalColors.marino;
    return Semantics(
      label: etiqueta,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              alDia ? Icons.cloud_done_rounded : Icons.cloud_upload_rounded,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              etiqueta,
              style: KavalTexto.cuerpo(size: 11, weight: FontWeight.w800, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
