import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/barra_inferior.dart';
import '../../l10n/app_localizations.dart';
import '../../state/kaval_state.dart';

class NavShell extends StatelessWidget {
  const NavShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final ruta = GoRouterState.of(context).uri.path;
    final indice = switch (ruta) {
      '/eventos' => 1,
      '/historial' => 3,
      '/perfil' => 4,
      _ => 0,
    };

    return Scaffold(
      body: child,
      bottomNavigationBar: BarraInferiorKaval(
        indice: indice,
        inicio: textos.inicio,
        eventos: textos.eventos,
        historial: textos.historial,
        perfil: textos.perfil,
        onTap: (valor) {
          final destino = switch (valor) {
            1 => '/eventos',
            3 => '/historial',
            4 => '/perfil',
            _ => '/inicio',
          };
          context.go(destino);
        },
        onMicrofono: () {
          final estado = context.read<KavalState>();
          final id = estado.eventos.firstOrNull?.id;
          if (id == null) {
            context.push('/nuevo-evento');
            return;
          }
          context.push('/evento/$id/dictar');
        },
      ),
    );
  }
}
