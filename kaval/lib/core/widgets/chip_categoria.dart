import 'package:flutter/material.dart';

import '../theme/kaval_colors.dart';
import '../theme/kaval_texto.dart';

/// Chip de categoría o filtro. El activo se pinta coral u oscuro.
class ChipCategoria extends StatelessWidget {
  const ChipCategoria({
    super.key,
    required this.texto,
    this.emoji,
    this.activo = false,
    this.oscuro = false,
    this.onTap,
  });

  final String texto;
  final String? emoji;
  final bool activo;
  final bool oscuro;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fondo = activo
        ? (oscuro ? KavalColors.marino : Colors.white)
        : Colors.white;
    final tinta = activo && oscuro ? Colors.white : KavalColors.marino;
    final borde = activo && !oscuro
        ? KavalColors.coral
        : (activo ? KavalColors.marino : KavalColors.borde);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: fondo,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borde, width: activo && !oscuro ? 1.6 : 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (emoji != null) ...[
                Text(emoji!, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
              ],
              Text(
                texto,
                style: KavalTexto.cuerpo(
                  size: 13,
                  weight: FontWeight.w800,
                  color: tinta,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
