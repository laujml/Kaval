import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

/// Arranca Firebase y deja Firestore listo para trabajar sin conexión.
///
/// Devuelve false si todavía no existe la configuración de flutterfire.
/// En ese caso el perfil local sigue disponible.
Future<bool> iniciarFirebase() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    }
    FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
    return true;
  } catch (error) {
    debugPrint('[kaval] Firebase no está configurado: $error');
    return false;
  }
}
