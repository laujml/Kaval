import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaval/data/servicio_auth.dart';
import 'package:kaval/features/auth/registro_page.dart';
import 'package:kaval/l10n/app_localizations.dart';
import 'package:kaval/state/kaval_state.dart';
import 'package:provider/provider.dart';

import 'fixtures/auth_falsa.dart';

Widget registro(ServicioAuth auth, {bool login = false}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => KavalState()),
      Provider.value(value: auth),
    ],
    child: MaterialApp(
      locale: const Locale('es'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: RegistroPage(empezarEnLogin: login),
    ),
  );
}

List<EditableText> campos(WidgetTester tester) {
  return tester.widgetList<EditableText>(find.byType(EditableText)).toList();
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  // BUG-003 (AUTH-030-D): cambiar de pestaña no mueve valores entre campos
  // ni deja la contraseña a la vista.
  testWidgets('cambiar entre crear cuenta e iniciar sesión deja cada valor en su campo',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(registro(ServicioAuth()));
    await tester.pumpAndSettle();

    final inicial = find.byType(TextFormField);
    expect(inicial, findsNWidgets(4));
    await tester.enterText(inicial.at(0), 'Ana Pérez');
    await tester.enterText(inicial.at(1), 'ana@email.com');
    await tester.enterText(inicial.at(2), 'secreta123');
    await tester.enterText(inicial.at(3), 'secreta123');

    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();
    var visibles = campos(tester);
    expect(visibles, hasLength(2));
    expect(visibles[0].controller.text, anyOf('', 'ana@email.com'));
    expect(visibles[1].obscureText, isTrue);

    await tester.tap(find.text('Crear cuenta').first);
    await tester.pumpAndSettle();
    visibles = campos(tester);
    expect(visibles, hasLength(4));
    expect(visibles[0].controller.text, anyOf('', 'Ana Pérez'));
    expect(visibles[1].controller.text, anyOf('', 'ana@email.com'));
    for (final campo in visibles) {
      if (campo.controller.text == 'secreta123') {
        expect(campo.obscureText, isTrue, reason: 'la contraseña no debe verse en texto plano');
      }
    }
    expect(visibles[2].obscureText, isTrue);
    expect(visibles[3].obscureText, isTrue);
  });

  // BUG-015 (SYNC-015): un segundo toque en Google mientras el primero
  // sigue en curso no abre otro inicio de sesión.
  testWidgets('tocar Google dos veces solo inicia un acceso', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    addTearDown(tester.view.reset);
    final auth = ServicioAuthFalso();
    await tester.pumpWidget(registro(auth, login: true));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Google'));
    await tester.pump();
    await tester.tap(find.text('Google'));
    await tester.pump();

    expect(auth.llamadasGoogle, 1);

    // Si la persona cancela Google, el botón vuelve a funcionar.
    auth.google.complete(null);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Google'));
    await tester.pump();
    expect(auth.llamadasGoogle, 2);
  });
}
