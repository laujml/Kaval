/// Dinero en efectivo que alguien pone en el fondo del grupo.
class AporteEfectivo {
  const AporteEfectivo({
    required this.id,
    required this.integranteId,
    required this.montoCentavos,
    required this.descripcion,
    required this.fecha,
    this.emoji = '💵',
  });

  final String id;
  final String integranteId;
  final int montoCentavos;
  final String descripcion;
  final String emoji;
  final DateTime fecha;
}
