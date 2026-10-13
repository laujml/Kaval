import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kaval/core/auth/mensajes_auth.dart';
import 'package:kaval/l10n/app_localizations_en.dart';
import 'package:kaval/l10n/app_localizations_es.dart';

void main() {
  final es = AppLocalizationsEs();
  final en = AppLocalizationsEn();

  test('cancelar Google no muestra aviso', () {
    const error = GoogleSignInException(code: GoogleSignInExceptionCode.canceled);
    expect(mensajeAuth(error, es), isEmpty);
    expect(mensajeAuth(error, en), isEmpty);
  });

  test('un Google interrumpido o mal configurado tiene frase propia', () {
    expect(
      mensajeAuth(const GoogleSignInException(code: GoogleSignInExceptionCode.interrupted), es),
      es.googleInterrumpido,
    );
    expect(
      mensajeAuth(
        const GoogleSignInException(code: GoogleSignInExceptionCode.clientConfigurationError),
        en,
      ),
      en.googleMalConfigurado,
    );
    expect(
      mensajeAuth(const GoogleSignInException(code: GoogleSignInExceptionCode.uiUnavailable), es),
      es.googleNoDisponible,
    );
  });

  test('borrar la cuenta sin sesión reciente pide volver a entrar', () {
    final error = FirebaseAuthException(code: 'requires-recent-login');
    expect(mensajeAuth(error, es), es.sesionReciente);
    expect(mensajeAuth(error, en), en.sesionReciente);
  });
}
