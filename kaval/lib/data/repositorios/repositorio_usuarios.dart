import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/usuario.dart';

/// Perfil de la cuenta. El id del documento es el uid de Firebase Auth.
class RepositorioUsuarios {
  RepositorioUsuarios(this._db);

  final FirebaseFirestore _db;

  Future<void> guardar(Usuario usuario) {
    return _db.collection('usuarios').doc(usuario.id).set(usuario.toMap());
  }

  Future<Usuario?> leer(String id) async {
    final doc = await _db.collection('usuarios').doc(id).get();
    final data = doc.data();
    if (!doc.exists || data == null) return null;
    return Usuario.fromMap(doc.id, data);
  }

  Future<void> borrar(String id) {
    return _db.collection('usuarios').doc(id).delete();
  }
}
