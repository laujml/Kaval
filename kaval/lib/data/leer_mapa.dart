/// Lectura tolerante de los mapas que vienen de Firestore.
String textoDe(Object? valor, {String siVacio = ''}) {
  if (valor is! String || valor.isEmpty) return siVacio;
  return valor;
}

int enteroDe(Object? valor) {
  if (valor is int) return valor;
  if (valor is num) return valor.toInt();
  return 0;
}

DateTime fechaDe(Object? valor) {
  return DateTime.fromMillisecondsSinceEpoch(enteroDe(valor));
}

T enumDe<T extends Enum>(List<T> valores, Object? nombre, T porDefecto) {
  if (nombre is! String) return porDefecto;
  for (final valor in valores) {
    if (valor.name == nombre) return valor;
  }
  return porDefecto;
}
