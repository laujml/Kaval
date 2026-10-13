import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/invitaciones/codigo_evento.dart';
import '../../models/aporte_efectivo.dart';
import '../../models/evento.dart';
import '../../models/gasto.dart';
import '../../models/integrante.dart';
import '../../models/usuario.dart';

/// Eventos visibles para una cuenta, más el código con el que se entra.
class RepositorioEventos {
  RepositorioEventos(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _eventos => _db.collection('eventos');

  CollectionReference<Map<String, dynamic>> get _codigos => _db.collection('codigos');

  /// Ids de cuentas reales. Un invitado con solo nombre no entra aquí:
  /// no tiene uid y las reglas no deben tratarlo como integrante.
  List<String> cuentasDe(Evento evento, String duenoId) {
    final ids = <String>{duenoId};
    for (final persona in evento.integrantes) {
      final conCuenta = persona.estado == EstadoUnion.admin || persona.estado == EstadoUnion.unido;
      if (conCuenta && persona.id.length >= 20) ids.add(persona.id);
    }
    return ids.toList();
  }

  Future<Evento> guardar(Evento evento, {required String duenoId}) async {
    final codigo = await _codigoLibre(evento);
    final listo = codigo == evento.codigo ? evento : evento.copyWith(codigo: codigo);
    final ref = _eventos.doc(listo.id);
    // Primero el evento. Las reglas de códigos e integrantes hacen get()
    // de este documento, y get() no ve las otras escrituras del mismo lote.
    await ref.set({
      ...listo.toMap(),
      'integranteIds': cuentasDe(listo, duenoId),
      'actualizado': DateTime.now().millisecondsSinceEpoch,
    });
    final batch = _db.batch();
    batch.set(_codigos.doc(listo.codigo.toUpperCase()), {'eventoId': listo.id});
    for (var i = 0; i < listo.integrantes.length; i++) {
      final persona = listo.integrantes[i];
      batch.set(ref.collection('integrantes').doc(persona.id), {
        ...persona.toMap(),
        'orden': i,
      });
    }
    batch.update(ref, {'actualizado': DateTime.now().millisecondsSinceEpoch});
    await batch.commit();
    return listo;
  }

  Future<String> _codigoLibre(Evento evento) async {
    var codigo = evento.codigo.toUpperCase();
    for (var intento = 0; intento < 5; intento++) {
      final ocupado = await _codigos.doc(codigo).get();
      final dueno = ocupado.data()?['eventoId'];
      if (!ocupado.exists || dueno == evento.id) return codigo;
      codigo = codigoDeEvento(evento.nombre);
    }
    return codigo;
  }

  Stream<List<Evento>> escuchar(String uid) {
    return _eventos
        .where('integranteIds', arrayContains: uid)
        .snapshots(includeMetadataChanges: true)
        .asyncMap((snap) async {
      final lista = <Evento>[];
      for (final doc in snap.docs) {
        lista.add(await armar(doc));
      }
      return lista;
    });
  }

  Future<Evento?> leer(String id) async {
    final doc = await _eventos.doc(id).get();
    if (!doc.exists) return null;
    return armar(doc);
  }

  Future<Evento?> unirse(String codigo, Usuario usuario) async {
    final puntero = await _codigos.doc(codigo.trim().toUpperCase()).get();
    final eventoId = puntero.data()?['eventoId'];
    if (!puntero.exists || eventoId is! String) return null;
    final ref = _eventos.doc(eventoId);
    await ref.update({
      'integranteIds': FieldValue.arrayUnion([usuario.id]),
    });
    final persona = Integrante(
      id: usuario.id,
      nombre: usuario.primerNombre,
      colorFondo: 0xFFFFD9E0,
      colorInicial: 0xFFE56B8A,
      estado: EstadoUnion.unido,
    );
    await ref.collection('integrantes').doc(usuario.id).set({
      ...persona.toMap(),
      'orden': DateTime.now().millisecondsSinceEpoch,
    });
    return leer(eventoId);
  }

  Future<Evento> armar(DocumentSnapshot<Map<String, dynamic>> doc) async {
    final soloLocal = doc.metadata.hasPendingWrites;
    final integrantes = await _hijos(doc.reference.collection('integrantes'), soloLocal: soloLocal);
    final gastos = await _hijos(doc.reference.collection('gastos'), soloLocal: soloLocal);
    final aportes = await _hijos(doc.reference.collection('aportes'), soloLocal: soloLocal);
    gastos.sort((a, b) => a.orden.compareTo(b.orden));
    integrantes.sort((a, b) => a.orden.compareTo(b.orden));
    aportes.sort((a, b) => a.orden.compareTo(b.orden));
    return Evento.fromMap(
      doc.id,
      doc.data() ?? {},
      integrantes: [for (final item in integrantes) Integrante.fromMap(item.id, item.data)],
      gastos: [for (final item in gastos) Gasto.fromMap(item.id, item.data)],
      aportes: [for (final item in aportes) AporteEfectivo.fromMap(item.id, item.data)],
      sincronizado: !doc.metadata.hasPendingWrites,
    );
  }
}

class _Hijo {
  const _Hijo(this.id, this.data, this.orden);

  final String id;
  final Map<String, dynamic> data;
  final int orden;
}

Future<List<_Hijo>> _hijos(
  CollectionReference<Map<String, dynamic>> coleccion, {
  bool soloLocal = false,
}) async {
  final snap = await _leerHijos(coleccion, soloLocal: soloLocal);
  if (snap == null) return const [];
  return [
    for (final doc in snap.docs)
      _Hijo(doc.id, doc.data(), _ordenDe(doc.data())),
  ];
}

Future<QuerySnapshot<Map<String, dynamic>>?> _leerHijos(
  CollectionReference<Map<String, dynamic>> coleccion, {
  required bool soloLocal,
}) async {
  try {
    if (soloLocal) return await coleccion.get(const GetOptions(source: Source.cache));
    return await coleccion.get();
  } catch (_) {
    if (soloLocal) return null;
  }
  try {
    return await coleccion.get(const GetOptions(source: Source.cache));
  } catch (_) {
    return null;
  }
}

int _ordenDe(Map<String, dynamic> data) {
  final valor = data['orden'];
  if (valor is int) return valor;
  if (valor is num) return valor.toInt();
  return 0;
}
