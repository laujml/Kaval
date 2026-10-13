import 'package:flutter/material.dart';

import '../theme/kaval_texto.dart';
import '../theme/kaval_colors.dart';
import '../utils/dinero.dart';

/// Fila de concepto y monto. El color sigue el signo del saldo.
class FilaMonto extends StatelessWidget {
  const FilaMonto({
    super.key,
    required this.etiqueta,
    required this.centavos,
    this.detalle,
    this.conSigno = true,
    this.neutro = false,
    this.trailing,
  });

  final String etiqueta;
  final int centavos;
  final String? detalle;
  final bool conSigno;
  final bool neutro;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final color = neutro ? KavalColors.marino : colorSegunSigno(centavos);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                etiqueta,
                style: KavalTexto.cuerpo(
                  weight: FontWeight.w800,
                  color: KavalColors.marino,
                ),
              ),
              if (detalle != null)
                Text(detalle!, style: KavalTexto.cuerpo(size: 12)),
            ],
          ),
        ),
        Text(
          usd(centavos, conSigno: conSigno),
          style: KavalTexto.titulo(size: 16, color: color),
        ),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );
  }
}
