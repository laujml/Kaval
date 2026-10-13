import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/integrante.dart';

/// Personas de un evento. Quien no tiene cuenta queda solo con su nombre.
class RepositorioIntegrantes {
  RepositorioIntegrantes(this._db);

  final FirebaseFirestore _db;

  Future<void> guardar(String eventoId, Integrante persona, {int? orden}) {
    final evento = _db.collection('eventos').doc(eventoId);
    final batch = _db.batch();
    batch.set(evento.collection('integrantes').doc(persona.id), {
      ...persona.toMap(),
      'orden': orden ?? DateTime.now().millisecondsSinceEpoch,
    });
    batch.update(evento, {'actualizado': DateTime.now().millisecondsSinceEpoch});
    return batch.commit();
  }
}
