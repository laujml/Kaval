/// Montos siempre en centavos. Así $18.50 es 1850 y no 18.499999.
String usd(int centavos, {bool conSigno = false, bool siempreSigno = false}) {
  final negativo = centavos < 0;
  final absoluto = centavos.abs();
  final texto =
      '\$${absoluto ~/ 100}.${(absoluto % 100).toString().padLeft(2, '0')}';
  if (conSigno || siempreSigno) {
    if (centavos > 0) return '+$texto';
    if (centavos < 0) return '-$texto';
    return siempreSigno ? '+$texto' : texto;
  }
  return negativo ? '-$texto' : texto;
}

/// "$36.00" escrito en un campo vuelve a centavos. Acepta coma o punto.
int? centavosDesdeTexto(String texto) {
  final limpio = texto.trim().replaceAll('\$', '').replaceAll(' ', '');
  if (limpio.isEmpty) return null;
  final normalizado = limpio.replaceAll(',', '.');
  final valor = double.tryParse(normalizado);
  if (valor == null) return null;
  return (valor * 100).round();
}
