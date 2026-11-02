import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaval/core/red/cliente_api.dart';
import 'package:kaval/data/repositorios/repositorio_datos.dart';
import 'package:kaval/data/servicio_auth.dart';
import 'package:kaval/features/inicio/inicio_page.dart';
import 'package:kaval/features/onboarding/bienvenida_page.dart';
import 'package:kaval/l10n/app_localizations.dart';
import 'package:kaval/models/usuario.dart';
import 'package:kaval/router/app_router.dart';
import 'package:kaval/state/kaval_state.dart';
import 'package:provider/provider.dart';

import 'fixtures/auth_falsa.dart';
import 'fixtures/datos_ejemplo.dart';

// BUG-001 (AUTH-003, E2E-002, SYNC-010): con sesión activa, reabrir la app
// debe entrar directo a /inicio con los eventos de la cuenta.
void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  const cuenta = Usuario(id: idLaura, nombre: 'Laura Angel', correo: 'laura@email.com');

  test('la sesión que Firebase guardó vuelve como la cuenta de Kaval', () async {
    final auth = ServicioAuth(
      auth: AuthFalsa(CuentaFalsa(uid: idLaura, displayName: 'Laura Angel', email: 'laura@email.com')),
      listo: true,
    );
    final restaurada = await auth.sesionGuardada();
    expect(restaurada?.id, idLaura);
    expect(restaurada?.nombre, 'Laura Angel');
    expect(restaurada?.correo, 'laura@email.com');
  });

  test('sin sesión guardada o sin Firebase no se restaura nada', () async {
    expect(await ServicioAuth(auth: AuthFalsa(), listo: true).sesionGuardada(), isNull);
    expect(await ServicioAuth().sesionGuardada(), isNull);
  });

  testWidgets('con sesión restaurada la app abre en /inicio con los eventos de la cuenta',
      (tester) async {
    final datos = RepositorioDatos(FakeFirebaseFirestore());
    await datos.eventos.guardar(eventoPlayaTunco(), duenoId: idLaura);
    final estado = KavalState(datos: datos);
    await estado.entrarEnLaNube(cuenta);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: estado),
          Provider(create: (_) => ClienteApi()),
          Provider(create: (_) => ServicioAuth()),
        ],
        child: MaterialApp.router(
          locale: const Locale('es'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: appRouter,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(BienvenidaPage), findsNothing);
    expect(find.byType(InicioPage), findsOneWidget);
    expect(estado.eventos.map((evento) => evento.id), contains(idTunco));
  });
}
