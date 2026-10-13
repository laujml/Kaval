import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/red/cliente_api.dart';
import 'state/kaval_state.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KavalState()),
        Provider(create: (_) => ClienteApi()),
      ],
      child: const KavalApp(),
    ),
  );
}
