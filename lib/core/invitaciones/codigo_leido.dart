final _codigo = RegExp(r'[A-Z0-9]{2,12}-[A-Z0-9]{2,8}');

/// Saca el código de un QR o de un texto compartido. `TUNCO-7K2` vale solo o dentro de una frase.
String? codigoEnTexto(String raw) {
  final limpio = raw.trim().toUpperCase();
  if (limpio.isEmpty) return null;
  return _codigo.firstMatch(limpio)?.group(0);
}
