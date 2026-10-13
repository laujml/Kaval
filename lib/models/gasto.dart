import '../data/leer_mapa.dart';

/// Categoría visual del gasto. El emoji concreto vive en cada gasto.
enum CategoriaGasto { comida, transporte, hospedaje, diversion }

/// Tarjeta es un pago de alguien. Efectivo del grupo sale del fondo común.
enum MetodoPago { tarjeta, efectivoGrupo }

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
    this.emoji = '💸',
    this.dictado = false,
  });

  final String id;
  final String concepto;
  final int montoCentavos;

  /// Null cuando paga el efectivo del grupo: nadie adelantó de su bolsillo.
  final String? pagadorId;
  final List<String> participanteIds;
  final CategoriaGasto categoria;
  final MetodoPago metodo;
  final String emoji;
  final bool dictado;
  final DateTime fecha;

  bool get esEfectivoGrupo => metodo == MetodoPago.efectivoGrupo;

  Map<String, dynamic> toMap() {
    return {
      'concepto': concepto,
      'montoCentavos': montoCentavos,
      'pagadorId': pagadorId,
      'participanteIds': participanteIds,
      'categoria': categoria.name,
      'metodo': metodo.name,
      'emoji': emoji,
      'dictado': dictado,
      'fecha': fecha.millisecondsSinceEpoch,
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
      emoji: textoDe(mapa['emoji'], siVacio: '💸'),
      dictado: mapa['dictado'] as bool? ?? false,
      fecha: fechaDe(mapa['fecha']),
    );
  }
}
