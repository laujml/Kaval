import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/firebase/iniciar_firebase.dart';
import 'core/red/cliente_api.dart';
import 'data/repositorios/repositorio_datos.dart';
import 'data/servicio_auth.dart';
import 'state/kaval_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final listo = await iniciarFirebase();
  final auth = ServicioAuth(
    auth: listo ? FirebaseAuth.instance : null,
    listo: listo,
  );
  final estado = KavalState(
    datos: listo ? RepositorioDatos(FirebaseFirestore.instance) : null,
  );
  // Si Firebase guardó la sesión, se entra directo con esa cuenta.
  final cuenta = await auth.sesionGuardada();
  if (cuenta != null) unawaited(estado.entrarEnLaNube(cuenta));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: estado),
        Provider(create: (_) => ClienteApi()),
        Provider.value(value: auth),
      ],
      child: const KavalApp(),
    ),
  );
}
