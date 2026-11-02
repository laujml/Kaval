// BUG-013 (UI-021, UI-035): con el sistema en oscuro, Inicio, Detalle y Nuevo
// gasto mezclaban fondos claros fijos con widgets que seguían la paleta oscura.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaval/core/theme/kaval_colors.dart';
import 'package:kaval/core/theme/kaval_paleta.dart';
import 'package:kaval/core/widgets/barra_inferior.dart';
import 'package:kaval/features/eventos/detalle_evento_page.dart';
import 'package:kaval/features/eventos/eventos_page.dart';
import 'package:kaval/features/gastos/agregar_gasto_page.dart';
import 'package:kaval/features/inicio/inicio_page.dart';
import 'package:kaval/models/evento.dart';
import 'package:kaval/models/usuario.dart';
import 'package:kaval/state/kaval_state.dart';

import 'fixtures/datos_ejemplo.dart';
import 'helpers/app_prueba.dart';

Future<KavalState> _estado({bool conEventos = true}) async {
  final estado = KavalState();
  await estado.entrarEnLaNube(const Usuario(id: idLaura, nombre: 'Laura', correo: 'laura@example.com'));
  if (conEventos) estado.crearEvento(activoHoy(eventoPlayaTunco(), id: 'qa-activo'));
  return estado;
}

Evento _sinGastos() {
  final base = activoHoy(eventoPlayaTunco(), id: 'qa-sin-gastos');
  return base.copyWith(gastos: const [], aportes: const []);
}

/// Color del texto del campo y su relleno: los dos los decide quien dibuja el campo.
(Color, Color) _campo(WidgetTester tester, Finder campo) {
  final texto = tester.widget<TextField>(find.descendant(of: campo, matching: find.byType(TextField)));
  final contexto = tester.element(find.descendant(of: campo, matching: find.byType(TextField)));
  final color = texto.style?.color ?? Theme.of(contexto).textTheme.bodyLarge!.color!;
  return (color, texto.decoration!.fillColor!);
}

SystemUiOverlayStyle? _estiloBarraEstado(WidgetTester tester, Type pagina) {
  final regiones = tester.widgetList<AnnotatedRegion<SystemUiOverlayStyle>>(
    find.descendant(of: find.byType(pagina), matching: find.byType(AnnotatedRegion<SystemUiOverlayStyle>)),
  );
  return regiones.isEmpty ? null : regiones.first.value;
}

void main() {
  setUpAll(cargarFuentes);

  group('BUG-013 sistema en oscuro', () {
    testWidgets('Nuevo gasto: título y texto de los campos legibles', (tester) async {
      await vistaTelefono(tester, brillo: Brightness.dark);
      await montarApp(tester, await _estado(), ruta: '/evento/qa-activo/gasto');
      final fondo = fondoScaffold(tester, AgregarGastoPage);
      expect(contraste(colorTexto(tester, find.text(es.nuevoGasto)), fondo), greaterThanOrEqualTo(4.5));
      expect(contraste(colorTexto(tester, find.text(es.quienPago)), fondo), greaterThanOrEqualTo(4.5));
      expect(contraste(colorTexto(tester, find.text(es.entreQuienes)), fondo), greaterThanOrEqualTo(4.5));
      final (texto, relleno) = _campo(tester, find.byType(TextFormField).at(1));
      expect(contraste(texto, relleno), greaterThanOrEqualTo(4.5));
    });

    testWidgets('Inicio vacío: el título del estado vacío se ve sobre el fondo', (tester) async {
      await vistaTelefono(tester, brillo: Brightness.dark);
      await montarApp(tester, await _estado(conEventos: false), ruta: '/inicio');
      final titulo = find.text(es.sinEventos);
      expect(contraste(colorTexto(tester, titulo), fondoScaffold(tester, InicioPage)), greaterThanOrEqualTo(4.5));
      // El cuerpo queda igual que en claro (gris sobre crema). Su contraste es UI-020e, otro hallazgo.
      expect(colorTexto(tester, find.text(es.sinEventosCuerpo)), KavalColors.gris);
    });

    testWidgets('Inicio con fondo claro pide iconos oscuros en la barra de estado', (tester) async {
      await vistaTelefono(tester, brillo: Brightness.dark);
      await montarApp(tester, await _estado(conEventos: false), ruta: '/inicio');
      expect(_estiloBarraEstado(tester, InicioPage)?.statusBarIconBrightness, Brightness.dark);
    });

    testWidgets('Detalle sin gastos: el estado vacío se ve sobre el fondo', (tester) async {
      await vistaTelefono(tester, brillo: Brightness.dark);
      final estado = await _estado(conEventos: false);
      estado.crearEvento(_sinGastos());
      await montarApp(tester, estado, ruta: '/evento/qa-sin-gastos');
      final titulo = find.text(es.sinGastos);
      await tester.scrollUntilVisible(titulo, 200, scrollable: find.byType(Scrollable).first);
      await tester.pump();
      expect(contraste(colorTexto(tester, titulo), fondoScaffold(tester, DetalleEventoPage)), greaterThanOrEqualTo(4.5));
      expect(_estiloBarraEstado(tester, DetalleEventoPage)?.statusBarIconBrightness, Brightness.dark);
    });

    testWidgets('la barra inferior sigue el tema y sus etiquetas se leen', (tester) async {
      await vistaTelefono(tester, brillo: Brightness.dark);
      await montarApp(tester, await _estado(), ruta: '/eventos');
      final caja = tester.widget<Container>(
        find.descendant(of: find.byType(BarraInferiorKaval), matching: find.byType(Container)).first,
      );
      final color = (caja.decoration! as BoxDecoration).color!;
      final paleta = KavalPaleta.de(tester.element(find.byType(EventosPage)));
      expect(color, paleta.superficie);
      final etiqueta = find.descendant(of: find.byType(BarraInferiorKaval), matching: find.text(es.historial));
      expect(contraste(colorTexto(tester, etiqueta), color), greaterThanOrEqualTo(4.5));
    });
  });

  group('BUG-013 el tema claro no cambia', () {
    testWidgets('Inicio, Detalle y Nuevo gasto conservan el fondo crema y el texto marino', (tester) async {
      await vistaTelefono(tester);
      final estado = await _estado();
      await montarApp(tester, estado, ruta: '/evento/qa-activo/gasto');
      expect(fondoScaffold(tester, AgregarGastoPage), KavalColors.crema);
      expect(colorTexto(tester, find.text(es.nuevoGasto)), KavalColors.marino);

      await montarApp(tester, estado, ruta: '/evento/qa-activo');
      expect(fondoScaffold(tester, DetalleEventoPage), KavalColors.crema);

      await montarApp(tester, estado, ruta: '/inicio');
      expect(fondoScaffold(tester, InicioPage), KavalColors.crema);
      final caja = tester.widget<Container>(
        find.descendant(of: find.byType(BarraInferiorKaval), matching: find.byType(Container)).first,
      );
      expect((caja.decoration! as BoxDecoration).color, Colors.white);
    });
  });
}
