import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../l10n/app_localizations.dart';
import 'firebase_no_configurado.dart';

/// Traduce los códigos de Firebase a una frase que se puede mostrar.
///
/// Un texto vacío significa que la persona canceló y no hay nada que avisar.
String mensajeAuth(Object error, AppLocalizations textos) {
  if (error is FirebaseNoConfigurado) return textos.firebaseSinConfigurar;
  if (error is GoogleSignInException) {
    if (error.code == GoogleSignInExceptionCode.canceled) return '';
    return textos.errorAuth;
  }
  if (error is! FirebaseAuthException) return textos.errorAuth;
  return switch (error.code) {
    'invalid-email' || 'invalid-credential' || 'user-not-found' || 'wrong-password' =>
      textos.credencialesInvalidas,
    'email-already-in-use' => textos.correoEnUso,
    'weak-password' => textos.contrasenaDebil,
    'too-many-requests' => textos.demasiadosIntentos,
    'network-request-failed' => textos.redAuth,
    'requires-recent-login' => textos.sesionReciente,
    'user-disabled' => textos.cuentaDesactivada,
    'operation-not-allowed' => textos.operacionNoPermitida,
    _ => textos.errorAuth,
  };
}
