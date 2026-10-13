import 'package:flutter/material.dart';

import '../theme/kaval_colors.dart';
import '../theme/kaval_texto.dart';

/// Botón principal de la app. El coral es la única acción fuerte.
class BotonCoral extends StatelessWidget {
  const BotonCoral({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icono,
    this.expandido = true,
  });

  final String texto;
  final VoidCallback? onPressed;
  final Widget? icono;
  final bool expandido;

  @override
  Widget build(BuildContext context) {
    final boton = FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: KavalColors.coral,
        foregroundColor: Colors.white,
        disabledBackgroundColor: KavalColors.coral.withValues(alpha: 0.4),
        elevation: 0,
        minimumSize: Size(expandido ? double.infinity : 0, 54),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
      ),
      child: Row(
        mainAxisSize: expandido ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icono != null) ...[icono!, const SizedBox(width: 8)],
          Flexible(
            child: Text(
              texto,
              overflow: TextOverflow.ellipsis,
              style: KavalTexto.cuerpo(
                size: 16,
                weight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: KavalColors.coral.withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: boton,
    );
  }
}

class BotonBlanco extends StatelessWidget {
  const BotonBlanco({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icono,
  });

  final String texto;
  final VoidCallback? onPressed;
  final Widget? icono;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: KavalColors.marino,
        side: const BorderSide(color: KavalColors.borde),
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icono != null) ...[icono!, const SizedBox(width: 8)],
          Flexible(
            child: Text(
              texto,
              overflow: TextOverflow.ellipsis,
              style: KavalTexto.cuerpo(
                weight: FontWeight.w800,
                color: KavalColors.marino,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
