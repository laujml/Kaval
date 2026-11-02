import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaval/data/repositorios/repositorio_datos.dart';
import 'package:kaval/data/repositorios/repositorio_eventos.dart';
import 'package:kaval/data/repositorios/repositorio_usuarios.dart';
import 'package:kaval/data/servicio_auth.dart';
import 'package:kaval/models/evento.dart';
import 'package:kaval/models/usuario.dart';

/// FirebaseAuth de prueba: solo lo que usa ServicioAuth.
class AuthFalsa implements FirebaseAuth {
  AuthFalsa([this.currentUser]);

  @override
  User? currentUser;

  @override
  Stream<User?> authStateChanges() => Stream.value(currentUser);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class CuentaFalsa implements User {
  CuentaFalsa({
    required this.uid,
    this.displayName,
    this.email,
    List<String> proveedores = const [],
  }) : providerData = [for (final id in proveedores) _Proveedor(id)];

  @override
  final String uid;
  @override
  final String? displayName;
  @override
  final String? email;
  @override
  final List<UserInfo> providerData;

  final reautenticadoCon = <String>[];
  var borrada = false;

  @override
  Future<UserCredential> reauthenticateWithProvider(AuthProvider provider) async {
    reautenticadoCon.add(provider.providerId);
    return _Credencial();
  }

  @override
  Future<UserCredential> reauthenticateWithCredential(AuthCredential credential) async {
    reautenticadoCon.add(credential.providerId);
    return _Credencial();
  }

  @override
  Future<void> delete() async => borrada = true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Proveedor implements UserInfo {
  _Proveedor(this.providerId);

  @override
  final String providerId;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Credencial implements UserCredential {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// ServicioAuth cuyo Google se queda esperando hasta que el test responda.
class ServicioAuthFalso extends ServicioAuth {
  var llamadasGoogle = 0;
  final google = Completer<Usuario?>();

  @override
  Future<Usuario?> entrarConGoogle() {
    llamadasGoogle++;
    return google.future;
  }
}

/// Repositorios donde el test decide cuándo termina guardar el usuario
/// y qué eventos llegan por cuenta.
class DatosControlados extends RepositorioDatos {
  DatosControlados(super.db)
      : _usuarios = UsuariosControlados(db),
        _eventos = EventosControlados(db);

  final UsuariosControlados _usuarios;
  final EventosControlados _eventos;

  @override
  UsuariosControlados get usuarios => _usuarios;

  @override
  EventosControlados get eventos => _eventos;
}

class UsuariosControlados extends RepositorioUsuarios {
  UsuariosControlados(super.db);

  /// Sin completar, guardar no termina: así se comporta Firestore sin red.
  final pendientes = <String, Completer<void>>{};

  @override
  Future<void> guardar(Usuario usuario) {
    return pendientes.putIfAbsent(usuario.id, Completer<void>.new).future;
  }
}

class EventosControlados extends RepositorioEventos {
  EventosControlados(super.db);

  final flujos = <String, StreamController<List<Evento>>>{};
  var escuchando = 0;

  @override
  Stream<List<Evento>> escuchar(String uid) {
    return flujos
        .putIfAbsent(
          uid,
          () => StreamController<List<Evento>>.broadcast(
            onListen: () => escuchando++,
            onCancel: () => escuchando--,
          ),
        )
        .stream;
  }
}
