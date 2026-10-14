import 'package:flutter/material.dart';

import '../theme/kaval_medidas.dart';

/// Tarjeta blanca, muy redondeada y con sombra suave.
class TarjetaKaval extends StatelessWidget {
  const TarjetaKaval({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(KavalMedidas.md),
    this.color = Colors.white,
    this.radio = KavalMedidas.radioTarjeta,
    this.borde,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final double radio;
  final BoxBorder? borde;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radioBorde = BorderRadius.circular(radio);
    // El Material va por dentro: si no, el ListTile de Perfil se pinta detrás de la tarjeta.
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radioBorde,
        border: borde,
        boxShadow: const [KavalMedidas.sombra],
      ),
      child: Material(
        color: color,
        borderRadius: radioBorde,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: radioBorde,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
