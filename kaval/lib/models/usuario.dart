/// Cuenta con la que se entra a Kaval. En esta fase vive solo en memoria.
class Usuario {
  const Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    this.local = false,
  });

  final String id;
  final String nombre;
  final String correo;

  /// Perfil de demostración cuando todavía no hay red.
  final bool local;

  String get primerNombre {
    final limpio = nombre.trim();
    if (limpio.isEmpty) return nombre;
    return limpio.split(' ').first;
  }

  Usuario copyWith({String? nombre, String? correo, bool? local}) {
    return Usuario(
      id: id,
      nombre: nombre ?? this.nombre,
      correo: correo ?? this.correo,
      local: local ?? this.local,
    );
  }
}
