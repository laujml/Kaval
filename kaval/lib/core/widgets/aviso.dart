import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Si la pantalla se abrió con push, regresa. Si no, vuelve al inicio.
void volver(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go('/inicio');
  }
}

void mostrarAviso(
  BuildContext context,
  String texto, {
  String? accion,
  VoidCallback? alAccionar,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(texto),
      action: accion == null
          ? null
          : SnackBarAction(label: accion, onPressed: alAccionar ?? () {}),
    ),
  );
}
