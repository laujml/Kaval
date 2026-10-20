import 'package:flutter/material.dart';

import '../../core/theme/kaval_medidas.dart';
import '../../core/theme/kaval_paleta.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/utils/etiquetas.dart';
import '../../core/widgets/kaval_avatar.dart';
import '../../l10n/app_localizations.dart';
import '../../models/integrante.dart';

/// Valor del selector cuando el dinero sale del fondo, no de una persona.
const idEfectivoGrupo = '__efectivo_grupo__';

class SelectorPagador extends StatelessWidget {
  const SelectorPagador({
    super.key,
    required this.personas,
    required this.usuarioId,
    required this.seleccionId,
    required this.onElegir,
  });

  final List<Integrante> personas;
  final String usuarioId;
  final String? seleccionId;
  final ValueChanged<String> onElegir;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return Semantics(
      label: textos.quienPago,
      child: SizedBox(
        height: 112,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: personas.length + 1,
          separatorBuilder: (_, _) => const SizedBox(width: KavalMedidas.xs),
          itemBuilder: (context, indice) {
            if (indice == personas.length) {
              return _OpcionPagador(
                etiqueta: textos.efectivoGrupo,
                seleccionado: seleccionId == idEfectivoGrupo,
                onTap: () => onElegir(idEfectivoGrupo),
                avatar: const _IconoFondo(),
              );
            }
            final persona = personas[indice];
            final etiqueta = etiquetaIntegrante(textos, persona, usuarioId);
            return _OpcionPagador(
              etiqueta: etiqueta,
              seleccionado: seleccionId == persona.id,
              onTap: () => onElegir(persona.id),
              avatar: avatarDe(persona, tamano: 44, seleccionado: seleccionId == persona.id),
            );
          },
        ),
      ),
    );
  }
}

class _OpcionPagador extends StatelessWidget {
  const _OpcionPagador({
    required this.etiqueta,
    required this.seleccionado,
    required this.onTap,
    required this.avatar,
  });

  final String etiqueta;
  final bool seleccionado;
  final VoidCallback onTap;
  final Widget avatar;

  @override
  Widget build(BuildContext context) {
    final paleta = KavalPaleta.de(context);
    return Semantics(
      button: true,
      selected: seleccionado,
      label: etiqueta,
      child: Material(
        color: seleccionado ? paleta.durazno : paleta.superficie,
        borderRadius: BorderRadius.circular(KavalMedidas.radioCampo),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(KavalMedidas.radioCampo),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 96,
            padding: const EdgeInsets.symmetric(horizontal: KavalMedidas.xs, vertical: KavalMedidas.sm),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(KavalMedidas.radioCampo),
              border: Border.all(
                color: seleccionado ? paleta.coral : paleta.borde,
                width: seleccionado ? 2.5 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                avatar,
                const SizedBox(height: KavalMedidas.xxs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (seleccionado) ...[
                      Icon(Icons.check_circle, size: 14, color: paleta.coral),
                      const SizedBox(width: 2),
                    ],
                    Flexible(
                      child: Text(
                        etiqueta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: KavalTexto.cuerpo(
                          size: 11,
                          weight: FontWeight.w800,
                          color: seleccionado ? paleta.coral : paleta.marino,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconoFondo extends StatelessWidget {
  const _IconoFondo();

  @override
  Widget build(BuildContext context) {
    final paleta = KavalPaleta.de(context);
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: paleta.menta, shape: BoxShape.circle),
      child: Icon(Icons.payments_outlined, color: paleta.verde, size: 22),
    );
  }
}
