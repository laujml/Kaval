import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../l10n/app_localizations.dart';
import '../widgets/aviso.dart';

/// Abre la hoja del sistema para compartir un texto. No inventa un enlace.
Future<void> compartirTexto(BuildContext context, String texto) async {
  try {
    await SharePlus.instance.share(ShareParams(text: texto));
  } catch (error, traza) {
    debugPrint('[kaval] no se pudo compartir: $error\n$traza');
    if (!context.mounted) return;
    mostrarAviso(context, AppLocalizations.of(context).compartirFallo);
  }
}
