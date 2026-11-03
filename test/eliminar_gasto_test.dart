// BUG-007 (EXP-033, EXP-033-D): no existía forma de eliminar un gasto.
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaval/core/liquidacion/liquidacion.dart';
import 'package:kaval/data/repositorios/repositorio_datos.dart';
import 'package:kaval/features/gastos/agregar_gasto_page.dart';
import 'package:kaval/models/usuario.dart';
import 'package:kaval/router/app_router.dart';
import 'package:kaval/state/kaval_state.dart';

import 'fixtures/datos_ejemplo.dart';
import 'helpers/app_prueba.dart';

const _id = 'qa-borrar';

Future<KavalState> _estadoLocal() async {
  final estado = KavalState();
  await estado.entrarEnLaNube(const Usuario(id: idLaura, nombre: 'Laura', correo: 'laura@example.com'));
  estado.crearEvento(activoHoy(eventoPlayaTunco(), id: _id));
  return estado;
}

void main() {
  setUpAll(cargarFuentes);

  group('BUG-007 KavalState.eliminarGasto', () {
    test('quita el gasto y los saldos se recalculan sin él', () async {
      final estado = await _estadoLocal();
      final antes = estado.liquidacionDe(_id)!;
      final balanceAntes = estado.balanceGeneral;

      estado.eliminarGasto(_id, 'hospedaje');

      final evento = estado.buscar(_id)!;
      expect(evento.gastos.map((g) => g.id), isNot(contains('hospedaje')));
      expect(evento.gastos, hasLength(eventoPlayaTunco().gastos.length - 1));
      final despues = estado.liquidacionDe(_id)!;
      expect(despues.totalGastos, antes.totalGastos - 12000);
      expect(despues.saldos, calcularSaldos(evento).saldos);
      expect(despues.saldoDe(idSofi), lessThan(antes.saldoDe(idSofi)));
      expect(despues.saldos.values.fold(0, (a, b) => a + b), 0);
      expect(estado.balanceGeneral, isNot(balanceAntes));
    });

    test('un id que no existe no cambia nada', () async {
      final estado = await _estadoLocal();
      final antes = estado.buscar(_id)!;
      estado.eliminarGasto(_id, 'no-existe');
      expect(estado.buscar(_id)!.gastos, antes.gastos);
    });

    test('con sesión en la nube también lo borra de Firestore', () async {
      final db = FakeFirebaseFirestore();
      final datos = RepositorioDatos(db);
      const cuenta = Usuario(id: 'abcdefghijklmnopqrst', nombre: 'Laura Angel', correo: 'laura.angel@email.com');
      await guardarTunco(datos, cuenta);
      final estado = KavalState(datos: datos);
      await estado.entrarEnLaNube(cuenta);
      final eventoId = 'tunco-${cuenta.id}';
      await pumpEventQueue();
      expect(estado.buscar(eventoId)!.gastos.map((g) => g.id), contains('gasolina'));
      final actualizadoAntes = (await db.collection('eventos').doc(eventoId).get()).data()!['actualizado'];

      estado.eliminarGasto(eventoId, 'gasolina');
      await pumpEventQueue();

      final doc = await db.collection('eventos').doc(eventoId).collection('gastos').doc('gasolina').get();
      expect(doc.exists, isFalse);
      expect((await datos.gastos.listar(eventoId)).map((g) => g.id), isNot(contains('gasolina')));
      expect((await db.collection('eventos').doc(eventoId).get()).data()!['actualizado'], isNot(actualizadoAntes));
      expect(estado.buscar(eventoId)!.gastos.map((g) => g.id), isNot(contains('gasolina')));
      estado.dispose();
    });
  });

  group('BUG-007 botón Eliminar gasto en Editar gasto', () {
    testWidgets('pide confirmación; Cancelar lo conserva y Eliminar lo quita', (tester) async {
      await vistaTelefono(tester);
      final estado = await _estadoLocal();
      await montarApp(tester, estado, ruta: '/evento/$_id');
      appRouter.push('/evento/$_id/gasto?editar=hospedaje');
      await tester.pumpAndSettle();
      expect(find.text(es.editarGasto), findsOneWidget);

      final boton = find.byKey(const ValueKey('gasto-eliminar'));
      await tester.scrollUntilVisible(boton, 200, scrollable: find.byType(Scrollable).first);
      await tester.tap(boton);
      await tester.pumpAndSettle();
      expect(find.text(es.eliminarGastoPregunta('Hospedaje')), findsOneWidget);
      await tester.tap(find.text(es.cancelar));
      await tester.pumpAndSettle();
      expect(estado.buscar(_id)!.gastos.map((g) => g.id), contains('hospedaje'));
      expect(find.byType(AgregarGastoPage), findsOneWidget);

      await tester.tap(boton);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, es.eliminar));
      await tester.pumpAndSettle();
      expect(estado.buscar(_id)!.gastos.map((g) => g.id), isNot(contains('hospedaje')));
      expect(find.byType(AgregarGastoPage), findsNothing);
      expect(find.text(es.gastoEliminado), findsOneWidget);
      expect(find.text('Hospedaje'), findsNothing);
    });

    testWidgets('un gasto nuevo no muestra el botón', (tester) async {
      await vistaTelefono(tester);
      await montarApp(tester, await _estadoLocal(), ruta: '/evento/$_id/gasto');
      expect(find.byKey(const ValueKey('gasto-eliminar')), findsNothing);
    });
  });
}
