import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaval/models/usuario.dart';
import 'package:kaval/state/kaval_state.dart';

import 'fixtures/auth_falsa.dart';
import 'fixtures/datos_ejemplo.dart';

void main() {
  const laura = Usuario(id: 'laura-uid', nombre: 'Laura', correo: 'laura@email.com');
  const ana = Usuario(id: 'ana-uid', nombre: 'Ana', correo: 'ana@email.com');

  // BUG-011 (SYNC-006): con la red de Firestore apagada, guardar el usuario
  // no termina nunca. El login no puede esperar esa escritura.
  test('entrar en la nube termina aunque guardar el usuario no responda', () async {
    final datos = DatosControlados(FakeFirebaseFirestore());
    final estado = KavalState(datos: datos);

    var termino = false;
    unawaited(estado.entrarEnLaNube(laura).then((_) => termino = true));
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(termino, isTrue, reason: 'el login se queda en Enviando…');
    expect(datos.eventos.escuchando, 1);
  });

  // BUG-015 (SYNC-015): dos entradas solapadas dejan un solo listener,
  // el de la última cuenta.
  test('dos entradas solapadas dejan un solo listener, el de la última cuenta', () async {
    final datos = DatosControlados(FakeFirebaseFirestore());
    final estado = KavalState(datos: datos);

    final primera = estado.entrarEnLaNube(laura);
    final segunda = estado.entrarEnLaNube(ana);
    datos.usuarios.pendientes.putIfAbsent(laura.id, Completer<void>.new).complete();
    datos.usuarios.pendientes.putIfAbsent(ana.id, Completer<void>.new).complete();
    await Future.wait([primera, segunda]);

    expect(datos.eventos.escuchando, 1);
    datos.eventos.flujos[laura.id]?.add([eventoPlayaTunco()]);
    await Future<void>.delayed(Duration.zero);
    expect(estado.usuario.id, ana.id);
    expect(estado.eventos, isEmpty, reason: 'no deben llegar eventos de otra cuenta');
  });
}
