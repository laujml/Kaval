import 'aporte_efectivo.dart';
import 'gasto.dart';
import 'integrante.dart';

/// Portada ilustrada que elige quien crea el evento.
enum PortadaEvento { playa, volcan, comida, carretera }

/// Viaje o salida con sus integrantes, gastos y fondo de efectivo.
class Evento {
  const Evento({
    required this.id,
    required this.nombre,
    required this.lugar,
    required this.inicio,
    required this.fin,
    required this.portada,
    required this.codigo,
    required this.integrantes,
    required this.gastos,
    required this.aportes,
    required this.custodioId,
    this.sincronizado = true,
    this.emoji = '',
  });

  final String id;
  final String nombre;
  final String lugar;
  final DateTime inicio;
  final DateTime fin;
  final PortadaEvento portada;
  final String codigo;
  final bool sincronizado;
  final String emoji;
  final List<Integrante> integrantes;
  final List<Gasto> gastos;
  final List<AporteEfectivo> aportes;

  /// Quién lleva el efectivo encima. En el ejemplo, Ana.
  final String custodioId;

  int get totalCentavos =>
      gastos.fold(0, (suma, gasto) => suma + gasto.montoCentavos);

  Integrante? integrante(String id) {
    for (final persona in integrantes) {
      if (persona.id == id) return persona;
    }
    return null;
  }

  Evento copyWith({
    String? nombre,
    List<Integrante>? integrantes,
    List<Gasto>? gastos,
    List<AporteEfectivo>? aportes,
    String? custodioId,
    bool? sincronizado,
  }) {
    return Evento(
      id: id,
      nombre: nombre ?? this.nombre,
      lugar: lugar,
      inicio: inicio,
      fin: fin,
      portada: portada,
      codigo: codigo,
      sincronizado: sincronizado ?? this.sincronizado,
      emoji: emoji,
      integrantes: integrantes ?? this.integrantes,
      gastos: gastos ?? this.gastos,
      aportes: aportes ?? this.aportes,
      custodioId: custodioId ?? this.custodioId,
    );
  }
}
