import '../../l10n/app_localizations.dart';
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

String emojiCategoria(CategoriaGasto categoria) {
  return switch (categoria) {
    CategoriaGasto.comida => '🍽️',
    CategoriaGasto.transporte => '⛽',
    CategoriaGasto.hospedaje => '🏠',
    CategoriaGasto.diversion => '🎉',
  };
}

/// Las descripciones de ejemplo se guardan como clave para poder traducirlas.
String textoAporte(AppLocalizations textos, String clave) {
  return switch (clave) {
    'retiro' => textos.retiroCajero,
    'bolsa' => textos.efectivoBolsa,
    _ => clave,
  };
}
