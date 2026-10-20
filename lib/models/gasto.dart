import '../data/leer_mapa.dart';

/// Categoría visual del gasto. El icono vive en un solo mapa.
enum CategoriaGasto { comida, transporte, hospedaje, diversion }

/// Tarjeta es un pago de alguien. Efectivo del grupo sale del fondo común.
enum MetodoPago { tarjeta, efectivoGrupo }

/// Cómo se reparte el monto. Los gastos viejos no traen el campo y quedan en iguales.
enum ModoDivision { iguales, montos, consumo }

/// Una línea de consumo: precio unitario por cantidad, asignada a una o más personas.
class ItemGasto {
  const ItemGasto({
    required this.id,
    required this.nombre,
    required this.precioCentavos,
    required this.cantidad,
    required this.participanteIds,
  });

  final String id;
  final String nombre;
  final int precioCentavos;
  final int cantidad;
  final List<String> participanteIds;

  int get totalCentavos => precioCentavos * cantidad;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'precioCentavos': precioCentavos,
      'cantidad': cantidad,
      'participanteIds': participanteIds,
    };
  }

  factory ItemGasto.fromMap(Map<String, dynamic> mapa) {
    return ItemGasto(
      id: textoDe(mapa['id'], siVacio: 'item'),
      nombre: textoDe(mapa['nombre']),
      precioCentavos: enteroDe(mapa['precioCentavos']),
      cantidad: enteroDe(mapa['cantidad']) <= 0 ? 1 : enteroDe(mapa['cantidad']),
      participanteIds: [
        for (final item in (mapa['participanteIds'] as List?) ?? const []) item.toString(),
      ],
    );
  }
}

/// Un gasto compartido. El monto va en centavos para no perder redondeos.
class Gasto {
  const Gasto({
    required this.id,
    required this.concepto,
    required this.montoCentavos,
    required this.participanteIds,
    required this.categoria,
    required this.metodo,
    required this.fecha,
    this.pagadorId,
    this.dictado = false,
    this.modoDivision = ModoDivision.iguales,
    this.partes = const {},
    this.items = const [],
    this.propinaPorcentaje = 0,
    this.extrasCentavos = 0,
  });

  final String id;
  final String concepto;
  final int montoCentavos;

  /// Null cuando paga el efectivo del grupo: nadie adelantó de su bolsillo.
  final String? pagadorId;
  final List<String> participanteIds;
  final CategoriaGasto categoria;
  final MetodoPago metodo;
  final bool dictado;
  final DateTime fecha;

  /// `iguales` si el documento es anterior a los modos de división.
  final ModoDivision modoDivision;

  /// Centavos por persona. En montos exactos es lo que escribió quien carga el gasto.
  final Map<String, int> partes;
  final List<ItemGasto> items;
  final int propinaPorcentaje;
  final int extrasCentavos;

  bool get esEfectivoGrupo => metodo == MetodoPago.efectivoGrupo;

  Map<String, dynamic> toMap() {
    return {
      'concepto': concepto,
      'montoCentavos': montoCentavos,
      'pagadorId': pagadorId,
      'participanteIds': participanteIds,
      'categoria': categoria.name,
      'metodo': metodo.name,
      'dictado': dictado,
      'fecha': fecha.millisecondsSinceEpoch,
      'splitMode': modoDivision.name,
      'shares': partes,
      'items': [for (final item in items) item.toMap()],
      'propinaPorcentaje': propinaPorcentaje,
      'extrasCentavos': extrasCentavos,
    };
  }

  factory Gasto.fromMap(String id, Map<String, dynamic> mapa) {
    return Gasto(
      id: id,
      concepto: textoDe(mapa['concepto']),
      montoCentavos: enteroDe(mapa['montoCentavos']),
      pagadorId: mapa['pagadorId'] as String?,
      participanteIds: [
        for (final item in (mapa['participanteIds'] as List?) ?? const []) item.toString(),
      ],
      categoria: enumDe(CategoriaGasto.values, mapa['categoria'], CategoriaGasto.comida),
      metodo: enumDe(MetodoPago.values, mapa['metodo'], MetodoPago.tarjeta),
      dictado: mapa['dictado'] as bool? ?? false,
      fecha: fechaDe(mapa['fecha']),
      modoDivision: enumDe(ModoDivision.values, mapa['splitMode'], ModoDivision.iguales),
      partes: _partesDe(mapa['shares']),
      items: _itemsDe(mapa['items']),
      propinaPorcentaje: enteroDe(mapa['propinaPorcentaje']),
      extrasCentavos: enteroDe(mapa['extrasCentavos']),
    );
  }
}

Map<String, int> _partesDe(Object? valor) {
  if (valor is! Map) return const {};
  return {
    for (final entrada in valor.entries) entrada.key.toString(): enteroDe(entrada.value),
  };
}

List<ItemGasto> _itemsDe(Object? valor) {
  if (valor is! List) return const [];
  return [
    for (final item in valor)
      if (item is Map) ItemGasto.fromMap(Map<String, dynamic>.from(item)),
  ];
}
