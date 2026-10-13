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
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => KavalState(
            datos: listo ? RepositorioDatos(FirebaseFirestore.instance) : null,
          ),
        ),
        Provider(create: (_) => ClienteApi()),
        Provider(
          create: (_) => ServicioAuth(
            auth: listo ? FirebaseAuth.instance : null,
            listo: listo,
          ),
        ),
      ],
      child: const KavalApp(),
    ),
  );
}
