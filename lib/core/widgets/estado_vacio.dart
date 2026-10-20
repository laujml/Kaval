import 'package:flutter/material.dart';

import '../theme/kaval_medidas.dart';
import '../theme/kaval_paleta.dart';
import '../theme/kaval_texto.dart';

/// Estado vacío o de error, con el mismo círculo pastel de las pantallas de Stitch.
class EstadoVacio extends StatelessWidget {
  const EstadoVacio({
    super.key,
    required this.icono,
    required this.titulo,
    this.cuerpo,
    this.fondo,
    this.tinta,
    this.accion,
  });

  final IconData icono;
  final String titulo;
  final String? cuerpo;
  final Color? fondo;
  final Color? tinta;
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    final paleta = KavalPaleta.de(context);
    final tituloEstilo = Theme.of(context).textTheme.headlineMedium ?? KavalTexto.titulo(size: 28);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: KavalMedidas.lg, vertical: KavalMedidas.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(color: fondo ?? paleta.durazno, shape: BoxShape.circle),
              child: Icon(icono, size: 42, color: tinta ?? paleta.coral),
            ),
          ),
          const SizedBox(height: KavalMedidas.md),
          Text(titulo, textAlign: TextAlign.center, style: tituloEstilo.copyWith(color: paleta.marino)),
          if (cuerpo != null) ...[
            const SizedBox(height: KavalMedidas.xs),
            Text(cuerpo!, textAlign: TextAlign.center, style: KavalTexto.cuerpo(color: paleta.gris)),
          ],
          if (accion != null) ...[
            const SizedBox(height: KavalMedidas.md),
            accion!,
          ],
        ],
      ),
    );
  }
}

/// En tablet el contenido no se estira a todo el ancho.
class MarcoKaval extends StatelessWidget {
  const MarcoKaval({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: KavalMedidas.anchoLectura),
        child: child,
      ),
    );
  }
}
