import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/aporte_efectivo.dart';

/// Aportes al efectivo del grupo. El monto también va en centavos.
class RepositorioAportes {
  RepositorioAportes(this._db);

  final FirebaseFirestore _db;

  Future<void> guardar(String eventoId, AporteEfectivo aporte, {int? orden}) {
    final evento = _db.collection('eventos').doc(eventoId);
    final batch = _db.batch();
    batch.set(evento.collection('aportes').doc(aporte.id), {
      ...aporte.toMap(),
      'orden': orden ?? DateTime.now().millisecondsSinceEpoch,
    });
    batch.update(evento, {'actualizado': DateTime.now().millisecondsSinceEpoch});
    return batch.commit();
  }

  Future<List<AporteEfectivo>> listar(String eventoId) async {
    final docs = await _db.collection('eventos').doc(eventoId).collection('aportes').get();
    final ordenados = docs.docs.toList()
      ..sort((a, b) => _orden(a.data()).compareTo(_orden(b.data())));
    return [for (final doc in ordenados) AporteEfectivo.fromMap(doc.id, doc.data())];
  }
}

int _orden(Map<String, dynamic> data) {
  final valor = data['orden'];
  if (valor is int) return valor;
  if (valor is num) return valor.toInt();
  return 0;
}
