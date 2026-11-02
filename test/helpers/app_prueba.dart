// Utilidades para tests de widgets que montan la app completa con el router.
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaval/app.dart';
import 'package:kaval/core/red/cliente_api.dart';
import 'package:kaval/data/servicio_auth.dart';
import 'package:kaval/l10n/app_localizations.dart';
import 'package:kaval/models/evento.dart';
import 'package:kaval/router/app_router.dart';
import 'package:kaval/state/kaval_state.dart';
import 'package:provider/provider.dart';

final es = lookupAppLocalizations(const Locale('es'));

/// Sin red en los tests: registra Roboto del SDK con los nombres que pide google_fonts.
Future<void> cargarFuentes() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  final sep = Platform.pathSeparator;
  final exe = Platform.resolvedExecutable;
  final corte = exe.indexOf('${sep}bin${sep}cache');
  final raiz = Platform.environment['FLUTTER_ROOT'] ?? (corte > 0 ? exe.substring(0, corte) : '');
  final dir = '$raiz${sep}bin${sep}cache${sep}artifacts${sep}material_fonts';
  ByteData leer(String nombre) => ByteData.sublistView(File('$dir$sep$nombre').readAsBytesSync());
  Future<void> registrar(String familia, ByteData datos) async {
    final loader = FontLoader(familia)..addFont(Future.value(datos));
    await loader.load();
  }

  final regular = leer('roboto-regular.ttf');
  final medium = leer('roboto-medium.ttf');
  final bold = leer('roboto-bold.ttf');
  final black = leer('roboto-black.ttf');
  for (final familia in ['Poppins', 'Nunito']) {
    for (final peso in [100, 200, 300, 400, 500, 600, 700, 800, 900]) {
      final nombre = peso == 400 ? '${familia}_regular' : '${familia}_$peso';
      final datos = peso >= 800 ? black : (peso >= 600 ? bold : (peso >= 500 ? medium : regular));
      await registrar(nombre, datos);
    }
  }
  await registrar('MaterialIcons', leer('materialicons-regular.otf'));
}

DateTime get hoy {
  final ahora = DateTime.now();
  return DateTime(ahora.year, ahora.month, ahora.day);
}

/// Copia de [base] con otro id y fechas de hoy, para que cuente como activo.
Evento activoHoy(Evento base, {String? id}) {
  return Evento(
    id: id ?? base.id,
    nombre: base.nombre,
    lugar: base.lugar,
    inicio: hoy,
    fin: hoy.add(const Duration(days: 2)),
    portada: base.portada,
    codigo: base.codigo,
    integrantes: base.integrantes,
    gastos: base.gastos,
    aportes: base.aportes,
    custodioId: base.custodioId,
  );
}

Future<void> vistaTelefono(WidgetTester tester, {Brightness brillo = Brightness.light}) async {
  tester.view.devicePixelRatio = 2.0;
  tester.view.physicalSize = const Size(720, 1400);
  tester.platformDispatcher.platformBrightnessTestValue = brillo;
  addTearDown(() {
    tester.view.reset();
    tester.platformDispatcher.clearPlatformBrightnessTestValue();
  });
}

Future<void> montarApp(WidgetTester tester, KavalState estado, {required String ruta}) async {
  // El router es global: se navega antes y después de montar para no pintar la ruta del test anterior.
  appRouter.go(ruta);
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<KavalState>.value(value: estado),
        Provider<ClienteApi>(create: (_) => ClienteApi()),
        Provider<ServicioAuth>(create: (_) => ServicioAuth()),
      ],
      child: const KavalApp(),
    ),
  );
  appRouter.go(ruta);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(milliseconds: 400));
}

double luminancia(Color c) {
  double canal(double v) => v <= 0.04045 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * canal(c.r) + 0.7152 * canal(c.g) + 0.0722 * canal(c.b);
}

/// Razón de contraste WCAG 2.1.
double contraste(Color a, Color b) {
  final la = luminancia(a);
  final lb = luminancia(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

Color colorTexto(WidgetTester tester, Finder texto) {
  return tester.renderObject<RenderParagraph>(texto).text.style!.color!;
}

/// Fondo real del Scaffold de [pagina]: el suyo o el del tema que lo rodea.
Color fondoScaffold(WidgetTester tester, Type pagina) {
  final scaffold = find.descendant(of: find.byType(pagina), matching: find.byType(Scaffold)).first;
  final widget = tester.widget<Scaffold>(scaffold);
  return widget.backgroundColor ?? Theme.of(tester.element(scaffold)).scaffoldBackgroundColor;
}
