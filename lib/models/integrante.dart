import '../data/leer_mapa.dart';

/// Cómo se unió la persona al evento. Sirve para la pantalla de invitación.
enum EstadoUnion { admin, unido, soloNombre, pendiente }

/// Persona dentro de un evento. Puede ser solo un nombre, sin cuenta.
class Integrante {
  const Integrante({
    required this.id,
    required this.nombre,
    required this.colorFondo,
    required this.colorInicial,
    this.estado = EstadoUnion.unido,
  });

  final String id;
  final String nombre;

  /// Colores en ARGB. El modelo no depende de Flutter para poder testearlo.
  final int colorFondo;
  final int colorInicial;
  final EstadoUnion estado;

  String get inicial {
    final limpio = nombre.trim();
    if (limpio.isEmpty) return '?';
    return limpio[0].toUpperCase();
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'colorFondo': colorFondo,
      'colorInicial': colorInicial,
      'estado': estado.name,
    };
  }

  factory Integrante.fromMap(String id, Map<String, dynamic> mapa) {
    return Integrante(
      id: id,
      nombre: textoDe(mapa['nombre']),
      colorFondo: enteroDe(mapa['colorFondo']),
      colorInicial: enteroDe(mapa['colorInicial']),
      estado: enumDe(EstadoUnion.values, mapa['estado'], EstadoUnion.soloNombre),
    );
  }
}
