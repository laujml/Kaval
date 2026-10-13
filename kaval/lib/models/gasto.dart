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
}
