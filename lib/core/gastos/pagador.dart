import '../../models/integrante.dart';

/// Busca a la persona que la voz nombró, por nombre completo o por el primer nombre.
String? buscarPagador(Iterable<Integrante> personas, String nombre) {
  final busca = _sinTilde(nombre.trim().toLowerCase());
  if (busca.isEmpty) return null;
  for (final persona in personas) {
    final completo = _sinTilde(persona.nombre.trim().toLowerCase());
    if (completo.isEmpty) continue;
    final primero = completo.split(RegExp(r'\s+')).first;
    if (completo == busca || primero == busca) return persona.id;
  }
  return null;
}

String _sinTilde(String texto) {
  const origen = 'áéíóúüñ';
  const destino = 'aeiouun';
  var salida = texto;
  for (var i = 0; i < origen.length; i++) {
    salida = salida.replaceAll(origen[i], destino[i]);
  }
  return salida;
}
