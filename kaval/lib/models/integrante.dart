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
}
