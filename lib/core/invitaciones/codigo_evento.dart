import 'dart:math';

/// Código corto para invitar, del estilo TUNCO-7K2.
///
/// Toma las primeras cinco letras de la última palabra del nombre
/// y les agrega tres caracteres que no se confunden (sin 0, O, 1 ni I).
String codigoDeEvento(String nombre, {Random? aleatorio}) {
  final palabras = nombre.toUpperCase().split(RegExp(r'\s+')).where((parte) => parte.isNotEmpty);
  final fuente = palabras.isEmpty ? 'KAVAL' : palabras.last;
  final limpio = fuente.replaceAll(RegExp(r'[^A-Z]'), '');
  final base = (limpio.isEmpty ? 'KAVAL' : limpio).padRight(5, 'X').substring(0, 5);
  final rng = aleatorio ?? Random();
  const alfabeto = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  final sufijo = String.fromCharCodes(
    List.generate(3, (_) => alfabeto.codeUnitAt(rng.nextInt(alfabeto.length))),
  );
  return '$base-$sufijo';
}
