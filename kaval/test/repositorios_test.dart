import 'dart:math';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaval/core/invitaciones/codigo_evento.dart';
import 'package:kaval/data/datos_ejemplo.dart';
import 'package:kaval/data/repositorios/repositorio_datos.dart';
import 'package:kaval/models/integrante.dart';
import 'package:kaval/models/usuario.dart';

void main() {
  const cuenta = Usuario(
    id: 'abcdefghijklmnopqrst',
    nombre: 'Laura Angel',
    correo: 'laura.angel@email.com',
  );

  test('el código sale de la última palabra, como TUNCO-7K2', () {
    final codigo = codigoDeEvento('Playa El Tunco', aleatorio: Random(1));
    expect(codigo, startsWith('TUNCO-'));
    expect(codigo.length, 9);
    expect(codigoDeEvento('Playa El Tunco', aleatorio: Random(1)), codigo);
  });

  test('guarda usuarios, gastos y aportes en centavos', () async {
    final datos = RepositorioDatos(FakeFirebaseFirestore());
    await datos.usuarios.guardar(cuenta);
    final perfil = await datos.usuarios.leer(cuenta.id);
    expect(perfil?.correo, cuenta.correo);

    await datos.cargarTunco(cuenta);
    final evento = await datos.eventos.leer('tunco-${cuenta.id}');
    final esperado = tuncoParaCuenta(cuenta);
    expect(evento, isNotNull);
    expect(evento!.gastos.map((gasto) => gasto.montoCentavos), esperado.gastos.map((gasto) => gasto.montoCentavos));
    expect(evento.aportes.first.montoCentavos, 6000);
    expect(evento.sincronizado, isTrue);
    expect(evento.integrante('diego')?.estado, EstadoUnion.soloNombre);
  });

  test('un invitado sin cuenta no queda en integranteIds', () async {
    final db = FakeFirebaseFirestore();
    final datos = RepositorioDatos(db);
    await datos.cargarTunco(cuenta);
    final doc = await db.collection('eventos').doc('tunco-${cuenta.id}').get();
    expect(doc.data()?['integranteIds'], [cuenta.id]);
  });

  test('unirse con el código agrega a la persona', () async {
    final datos = RepositorioDatos(FakeFirebaseFirestore());
    await datos.cargarTunco(cuenta);
    const ana = Usuario(
      id: 'ana-cuenta-de-prueba-123456',
      nombre: 'Ana Lopez',
      correo: 'ana@email.com',
    );
    final unido = await datos.eventos.unirse('tunco-7k2', ana);
    expect(unido?.integrante(ana.id)?.estado, EstadoUnion.unido);
    expect(await datos.eventos.unirse('NO-EXISTE', ana), isNull);
  });

  test('si el código ya existe, se genera otro', () async {
    final datos = RepositorioDatos(FakeFirebaseFirestore());
    await datos.cargarTunco(cuenta);
    const otra = Usuario(
      id: 'bbbbbbbbbbbbbbbbbbbb',
      nombre: 'Luis',
      correo: 'luis@email.com',
    );
    final segundo = tuncoParaCuenta(otra);
    final guardado = await datos.eventos.guardar(segundo, duenoId: otra.id);
    expect(guardado.codigo, isNot('TUNCO-7K2'));
    expect(guardado.codigo, startsWith('TUNCO-'));
  });

  test('la escucha marca sincronizado cuando la escritura ya se confirmó', () async {
    final datos = RepositorioDatos(FakeFirebaseFirestore());
    await datos.cargarTunco(cuenta);
    final lista = await datos.eventos.escuchar(cuenta.id).first;
    expect(lista.single.sincronizado, isTrue);
    expect(lista.single.nombre, 'Playa El Tunco');
  });
}
