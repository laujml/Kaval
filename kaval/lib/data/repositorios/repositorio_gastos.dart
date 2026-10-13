import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/gasto.dart';

/// Gastos del evento. El monto se guarda en centavos, como int.
class RepositorioGastos {
  RepositorioGastos(this._db);

  final FirebaseFirestore _db;

  Future<void> guardar(String eventoId, Gasto gasto, {int? orden}) {
    final evento = _db.collection('eventos').doc(eventoId);
    final batch = _db.batch();
    batch.set(evento.collection('gastos').doc(gasto.id), {
      ...gasto.toMap(),
      'orden': orden ?? -DateTime.now().millisecondsSinceEpoch,
    });
    batch.update(evento, {'actualizado': DateTime.now().millisecondsSinceEpoch});
    return batch.commit();
  }

  Future<List<Gasto>> listar(String eventoId) async {
    final docs = await _db.collection('eventos').doc(eventoId).collection('gastos').get();
    final ordenados = docs.docs.toList()
      ..sort((a, b) => _orden(a.data()).compareTo(_orden(b.data())));
    return [for (final doc in ordenados) Gasto.fromMap(doc.id, doc.data())];
  }
}

int _orden(Map<String, dynamic> data) {
  final valor = data['orden'];
  if (valor is int) return valor;
  if (valor is num) return valor.toInt();
  return 0;
}
