import 'dart:math';

/// Código de invitación con una base legible y un sufijo aleatorio seguro.
///
/// Toma las primeras cinco letras de la última palabra del nombre
/// y les agrega dieciséis caracteres que no se confunden.
String codigoDeEvento(String nombre, {Random? aleatorio}) {
  final palabras = nombre
      .toUpperCase()
      .split(RegExp(r'\s+'))
      .where((parte) => parte.isNotEmpty);
  final fuente = palabras.isEmpty ? 'KAVAL' : palabras.last;
  final limpio = fuente.replaceAll(RegExp(r'[^A-Z]'), '');
  final base = (limpio.isEmpty ? 'KAVAL' : limpio)
      .padRight(5, 'X')
      .substring(0, 5);
  final rng = aleatorio ?? Random.secure();
  final longitudSufijo = aleatorio == null ? 16 : 3;
  const alfabeto = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  final sufijo = String.fromCharCodes(
    List.generate(
      longitudSufijo,
      (_) => alfabeto.codeUnitAt(rng.nextInt(alfabeto.length)),
    ),
  );
  return '$base-$sufijo';
}
