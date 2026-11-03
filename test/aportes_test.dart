// BUG-004 (CONTR-011, CONTR-011-D, CONTR-020): '+ Aporte' solo mostraba un
// SnackBar y no había forma de registrar un aporte al Efectivo del grupo.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaval/core/utils/dinero.dart';
import 'package:kaval/core/widgets/boton_coral.dart';
import 'package:kaval/models/usuario.dart';
import 'package:kaval/state/kaval_state.dart';

import 'fixtures/datos_ejemplo.dart';
import 'helpers/app_prueba.dart';

const _id = 'qa-aporte';

Future<KavalState> _estado() async {
  final estado = KavalState();
  await estado.entrarEnLaNube(const Usuario(id: idLaura, nombre: 'Laura', correo: 'laura@example.com'));
  estado.crearEvento(activoHoy(eventoPlayaTunco(), id: _id));
  return estado;
}

Future<void> _abrirFormulario(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(BotonBlanco, es.aporte));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(cargarFuentes);

  testWidgets('el botón + Aporte abre un formulario y el aporte queda en el fondo', (tester) async {
    await vistaTelefono(tester);
    final estado = await _estado();
    final antes = estado.liquidacionDe(_id)!;
    expect(antes.reunido, 8000);
    await montarApp(tester, estado, ruta: '/evento/$_id/efectivo');

    await _abrirFormulario(tester);
    expect(find.text(es.nuevoAporte), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('aporte-integrante-$idSofi')));
    await tester.pump();
    final chip = tester.widget<ChoiceChip>(find.byKey(const ValueKey('aporte-integrante-$idSofi')));
    final etiqueta = find.descendant(of: find.byKey(const ValueKey('aporte-integrante-$idSofi')), matching: find.text('Sofi'));
    expect(contraste(colorTexto(tester, etiqueta), chip.selectedColor!), greaterThanOrEqualTo(4.5));
    await tester.enterText(find.byKey(const ValueKey('aporte-monto')), '15.50');
    await tester.enterText(find.byKey(const ValueKey('aporte-descripcion')), 'Cajero de la playa');
    await tester.tap(find.byKey(const ValueKey('aporte-guardar')));
    await tester.pumpAndSettle();

    final aportes = estado.buscar(_id)!.aportes;
    expect(aportes, hasLength(3));
    expect(aportes.last.integranteId, idSofi);
    expect(aportes.last.montoCentavos, 1550);
    expect(aportes.last.descripcion, 'Cajero de la playa');

    final despues = estado.liquidacionDe(_id)!;
    expect(despues.reunido, 9550);
    expect(despues.saldos.values.fold(0, (a, b) => a + b), 0);
    expect(despues.saldoDe(idSofi), greaterThan(antes.saldoDe(idSofi)));

    expect(find.text(es.nuevoAporte), findsNothing);
    expect(find.text(es.deReunidos(usd(9550))), findsOneWidget);
    expect(find.text('Cajero de la playa'), findsOneWidget);
  });

  testWidgets('el + Aporte de la cabecera abre el mismo formulario', (tester) async {
    await vistaTelefono(tester);
    await montarApp(tester, await _estado(), ruta: '/evento/$_id/efectivo');
    await tester.tap(find.byKey(const ValueKey('aporte-cabecera')));
    await tester.pumpAndSettle();
    expect(find.text(es.nuevoAporte), findsOneWidget);
  });

  testWidgets('por defecto aporta quien usa la app y el monto es obligatorio', (tester) async {
    await vistaTelefono(tester);
    final estado = await _estado();
    await montarApp(tester, estado, ruta: '/evento/$_id/efectivo');
    await _abrirFormulario(tester);

    await tester.enterText(find.byKey(const ValueKey('aporte-monto')), '0');
    await tester.tap(find.byKey(const ValueKey('aporte-guardar')));
    await tester.pumpAndSettle();
    expect(find.text(es.montoInvalido), findsOneWidget);
    expect(estado.buscar(_id)!.aportes, hasLength(2));

    await tester.enterText(find.byKey(const ValueKey('aporte-monto')), '20');
    await tester.tap(find.byKey(const ValueKey('aporte-guardar')));
    await tester.pumpAndSettle();
    final ultimo = estado.buscar(_id)!.aportes.last;
    expect(ultimo.integranteId, idLaura);
    expect(ultimo.montoCentavos, 2000);
    expect(ultimo.descripcion, '');
  });

  testWidgets('con el sistema en oscuro el formulario se lee (va en claro, como Efectivo)', (tester) async {
    await vistaTelefono(tester, brillo: Brightness.dark);
    await montarApp(tester, await _estado(), ruta: '/evento/$_id/efectivo');
    await _abrirFormulario(tester);
    final campo = find.descendant(of: find.byKey(const ValueKey('aporte-monto')), matching: find.byType(TextField));
    final texto = tester.widget<TextField>(campo);
    expect(contraste(texto.style!.color!, texto.decoration!.fillColor!), greaterThanOrEqualTo(4.5));
  });

  testWidgets('Cancelar no registra nada', (tester) async {
    await vistaTelefono(tester);
    final estado = await _estado();
    await montarApp(tester, estado, ruta: '/evento/$_id/efectivo');
    await _abrirFormulario(tester);
    await tester.enterText(find.byKey(const ValueKey('aporte-monto')), '50');
    await tester.tap(find.text(es.cancelar));
    await tester.pumpAndSettle();
    expect(find.text(es.nuevoAporte), findsNothing);
    expect(estado.buscar(_id)!.aportes, hasLength(2));
  });
}
