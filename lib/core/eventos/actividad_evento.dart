import '../../models/evento.dart';

/// Sigue activo si el día de fin es hoy o posterior. Solo lo ya terminado sale.
bool eventoSigueActivo(Evento evento, DateTime ahora) {
  final fin = DateTime(evento.fin.year, evento.fin.month, evento.fin.day);
  final hoy = DateTime(ahora.year, ahora.month, ahora.day);
  return !fin.isBefore(hoy);
}

List<Evento> eventosActivosEn(List<Evento> eventos, DateTime ahora) {
  return [for (final evento in eventos) if (eventoSigueActivo(evento, ahora)) evento];
}

List<Evento> eventosHistorialEn(List<Evento> eventos, DateTime ahora) {
  return [for (final evento in eventos) if (!eventoSigueActivo(evento, ahora)) evento];
}

/// Conserva un evento local que la nube todavía no devolvió (offline o pendiente).
/// Si la nube ya lo trae, manda la copia remota y no se duplica.
List<Evento> fusionarEventos(List<Evento> locales, List<Evento> nube) {
  final idsNube = {for (final evento in nube) evento.id};
  return [
    for (final evento in locales)
      if (!idsNube.contains(evento.id)) evento,
    ...nube,
  ];
}
