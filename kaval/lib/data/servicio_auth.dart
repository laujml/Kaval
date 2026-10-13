import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../core/auth/firebase_no_configurado.dart';
import '../models/usuario.dart';

/// Registro, sesión y borrado de la cuenta.
class ServicioAuth {
  ServicioAuth({this.auth, this.listo = false});

  final FirebaseAuth? auth;
  final bool listo;
  var _googleListo = false;

  bool get appleDisponible => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  FirebaseAuth get _sesion {
    final sesion = auth;
    if (!listo || sesion == null) throw const FirebaseNoConfigurado();
    return sesion;
  }

  Future<Usuario> registrar({
    required String nombre,
    required String correo,
    required String contrasena,
  }) async {
    final credencial = await _sesion.createUserWithEmailAndPassword(
      email: correo.trim(),
      password: contrasena,
    );
    final cuenta = credencial.user;
    if (cuenta == null) throw FirebaseAuthException(code: 'invalid-credential');
    await cuenta.updateDisplayName(nombre.trim());
    return _desde(cuenta, nombre: nombre.trim());
  }

  Future<Usuario> entrarConCorreo({
    required String correo,
    required String contrasena,
  }) async {
    final credencial = await _sesion.signInWithEmailAndPassword(
      email: correo.trim(),
      password: contrasena,
    );
    final cuenta = credencial.user;
    if (cuenta == null) throw FirebaseAuthException(code: 'invalid-credential');
    return _desde(cuenta);
  }

  Future<Usuario?> entrarConGoogle() async {
    if (!_googleListo) {
      await GoogleSignIn.instance.initialize();
      _googleListo = true;
    }
    try {
      final google = await GoogleSignIn.instance.authenticate();
      final idToken = google.authentication.idToken;
      if (idToken == null) throw FirebaseAuthException(code: 'invalid-credential');
      final credencial = GoogleAuthProvider.credential(idToken: idToken);
      final resultado = await _sesion.signInWithCredential(credencial);
      final cuenta = resultado.user;
      if (cuenta == null) throw FirebaseAuthException(code: 'invalid-credential');
      return _desde(cuenta, nombre: google.displayName);
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  Future<Usuario> entrarConApple() async {
    if (!appleDisponible) throw FirebaseAuthException(code: 'operation-not-allowed');
    final proveedor = AppleAuthProvider()
      ..addScope('email')
      ..addScope('name');
    final resultado = await _sesion.signInWithProvider(proveedor);
    final cuenta = resultado.user;
    if (cuenta == null) throw FirebaseAuthException(code: 'invalid-credential');
    return _desde(cuenta);
  }

  Future<void> recuperar(String correo) {
    return _sesion.sendPasswordResetEmail(email: correo.trim());
  }

  Future<void> cerrarSesion() async {
    if (_googleListo) await GoogleSignIn.instance.signOut();
    final sesion = auth;
    if (listo && sesion != null) await sesion.signOut();
  }

  Future<void> eliminarCuenta() async {
    final cuenta = _sesion.currentUser;
    if (cuenta == null) throw FirebaseAuthException(code: 'requires-recent-login');
    await cuenta.delete();
  }

  Usuario _desde(User cuenta, {String? nombre}) {
    final visible = (nombre ?? cuenta.displayName ?? '').trim();
    return Usuario(
      id: cuenta.uid,
      nombre: visible.isEmpty ? cuenta.email ?? 'Kaval' : visible,
      correo: cuenta.email ?? '',
    );
  }
}
