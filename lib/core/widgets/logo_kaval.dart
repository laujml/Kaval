import 'package:flutter/material.dart';

import '../theme/kaval_colors.dart';
import '../theme/kaval_texto.dart';

/// Maleta blanca sobre un cuadro coral. Es el logo de todas las pantallas.
class LogoKaval extends StatelessWidget {
  const LogoKaval({super.key, this.tamano = 42, this.conNombre = false, this.nombre = 'kaval'});

  final double tamano;
  final bool conNombre;
  final String nombre;

  @override
  Widget build(BuildContext context) {
    final marca = Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        color: KavalColors.coral,
        borderRadius: BorderRadius.circular(tamano * 0.28),
      ),
      child: Icon(Icons.work_outline_rounded, color: Colors.white, size: tamano * 0.52),
    );
    if (!conNombre) return marca;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        marca,
        const SizedBox(width: 8),
        Text(nombre, style: KavalTexto.titulo(size: tamano * 0.55)),
      ],
    );
  }
}

class BotonRedondo extends StatelessWidget {
  const BotonRedondo({
    super.key,
    required this.icono,
    required this.onTap,
    this.fondo = Colors.white,
    this.tinta = KavalColors.marino,
    this.etiqueta,
  });

  final IconData icono;
  final VoidCallback onTap;
  final Color fondo;
  final Color tinta;
  final String? etiqueta;

  @override
  Widget build(BuildContext context) {
    final boton = Material(
      color: fondo,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icono, color: tinta, size: 20),
        ),
      ),
    );
    final nombre = etiqueta;
    if (nombre == null) return boton;
    return Tooltip(
      message: nombre,
      child: Semantics(label: nombre, button: true, child: boton),
    );
  }
}
