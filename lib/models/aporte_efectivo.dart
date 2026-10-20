import '../data/leer_mapa.dart';

/// Dinero en efectivo que alguien pone en el fondo del grupo.
class AporteEfectivo {
  const AporteEfectivo({
    required this.id,
    required this.integranteId,
    required this.montoCentavos,
    required this.descripcion,
    required this.fecha,
  });

  final String id;
  final String integranteId;
  final int montoCentavos;
  final String descripcion;
  final DateTime fecha;

  Map<String, dynamic> toMap() {
    return {
      'integranteId': integranteId,
      'montoCentavos': montoCentavos,
      'descripcion': descripcion,
      'fecha': fecha.millisecondsSinceEpoch,
    };
  }

  factory AporteEfectivo.fromMap(String id, Map<String, dynamic> mapa) {
    return AporteEfectivo(
      id: id,
      integranteId: textoDe(mapa['integranteId']),
      montoCentavos: enteroDe(mapa['montoCentavos']),
      descripcion: textoDe(mapa['descripcion']),
      fecha: fechaDe(mapa['fecha']),
    );
  }
}
