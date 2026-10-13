/// Un pago directo: el deudor le transfiere este monto al acreedor.
class Transferencia {
  const Transferencia({
    required this.deudorId,
    required this.acreedorId,
    required this.montoCentavos,
  });

  final String deudorId;
  final String acreedorId;
  final int montoCentavos;

  String get clave => '$deudorId>$acreedorId:$montoCentavos';
}
