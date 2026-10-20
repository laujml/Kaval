import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/evento.dart';
import '../../models/gasto.dart';
import '../../models/integrante.dart';

String etiquetaIntegrante(
  AppLocalizations textos,
  Integrante persona,
  String usuarioId,
) {
  if (persona.id == usuarioId) return textos.tu;
  return persona.nombre;
}

String nombreCategoria(AppLocalizations textos, CategoriaGasto categoria) {
  return switch (categoria) {
    CategoriaGasto.comida => textos.categoriaComida,
    CategoriaGasto.transporte => textos.categoriaTransporte,
    CategoriaGasto.hospedaje => textos.categoriaHospedaje,
    CategoriaGasto.diversion => textos.categoriaDiversion,
  };
}

IconData iconoCategoria(CategoriaGasto categoria) {
  return switch (categoria) {
    CategoriaGasto.transporte => Icons.local_gas_station,
    CategoriaGasto.comida => Icons.restaurant,
    CategoriaGasto.hospedaje => Icons.hotel,
    CategoriaGasto.diversion => Icons.confirmation_number,
  };
}

IconData iconoPortada(PortadaEvento portada) {
  return switch (portada) {
    PortadaEvento.playa => Icons.waves,
    PortadaEvento.volcan => Icons.volcano,
    PortadaEvento.comida => Icons.restaurant,
    PortadaEvento.carretera => Icons.directions_car,
  };
}

/// Icono de categoría. Si hay etiqueta, el lector de pantalla la anuncia.
class IconoCategoria extends StatelessWidget {
  const IconoCategoria({
    super.key,
    required this.categoria,
    this.tamano = 22,
    this.color,
    this.etiqueta,
  });

  final CategoriaGasto categoria;
  final double tamano;
  final Color? color;
  final String? etiqueta;

  @override
  Widget build(BuildContext context) {
    final icono = Icon(iconoCategoria(categoria), size: tamano, color: color);
    final nombre = etiqueta;
    if (nombre == null) return ExcludeSemantics(child: icono);
    return Tooltip(
      message: nombre,
      child: Semantics(label: nombre, child: icono),
    );
  }
}

/// Las descripciones de ejemplo se guardan como clave para poder traducirlas.
String textoAporte(AppLocalizations textos, String clave) {
  return switch (clave) {
    'retiro' => textos.retiroCajero,
    'bolsa' => textos.efectivoBolsa,
    _ => clave,
  };
}
