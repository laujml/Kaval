import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/kaval_theme.dart';
import 'l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'state/kaval_state.dart';

class KavalApp extends StatelessWidget {
  const KavalApp({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<KavalState>();
    return MaterialApp.router(
      title: 'Kaval',
      debugShowCheckedModeBanner: false,
      theme: temaKaval(),
      locale: estado.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: appRouter,
    );
  }
}
