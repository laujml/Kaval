import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/widgets/boton_coral.dart';
import '../../l10n/app_localizations.dart';

/// Qué hacer al volver: reintentar la misma operación o guardarla en local.
class PasoError {
  const PasoError({this.alReintentar, this.alSeguirLocal});

  final VoidCallback? alReintentar;
  final VoidCallback? alSeguirLocal;
}

enum TipoPantallaError { red, espera, sesion }

TipoPantallaError tipoDesdeRuta(String? valor) {
  return switch (valor) {
    'espera' => TipoPantallaError.espera,
    'sesion' => TipoPantallaError.sesion,
    _ => TipoPantallaError.red,
  };
}

/// Pantalla completa cuando el error no se puede resolver en el formulario.
class ControlErroresPage extends StatelessWidget {
  const ControlErroresPage({super.key, required this.tipo, this.paso});

  final TipoPantallaError tipo;
  final PasoError? paso;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final copia = _copia(textos);
    return Scaffold(
      backgroundColor: KavalColors.crema,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: textos.cerrar,
                  onPressed: () => volverDeError(context),
                  icon: const Icon(Icons.close, color: KavalColors.marino),
                ),
              ),
              const Spacer(),
              Center(child: _Circulo(icono: copia.icono, fondo: copia.fondo, tinta: copia.tinta)),
              const SizedBox(height: 28),
              Text(copia.titulo, textAlign: TextAlign.center, style: KavalTexto.titulo(size: 28)),
              const SizedBox(height: 12),
              Text(
                copia.cuerpo,
                textAlign: TextAlign.center,
                style: KavalTexto.cuerpo(size: 16),
              ),
              const Spacer(),
              BotonCoral(texto: copia.principal, onPressed: () => _principal(context)),
              if (copia.secundario != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: BotonBlanco(
                    texto: copia.secundario!,
                    onPressed: () => _secundario(context),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  _Copia _copia(AppLocalizations textos) {
    return switch (tipo) {
      TipoPantallaError.red => _Copia(
          icono: Icons.wifi_off_rounded,
          fondo: KavalColors.durazno,
          tinta: KavalColors.coral,
          titulo: textos.errorSinRedTitulo,
          cuerpo: textos.errorSinRedCuerpo,
          principal: textos.reintentar,
          secundario: textos.seguirSinConexion,
        ),
      TipoPantallaError.espera => _Copia(
          icono: Icons.hourglass_top_rounded,
          fondo: KavalColors.aviso,
          tinta: KavalColors.oro,
          titulo: textos.errorEsperaTitulo,
          cuerpo: textos.errorEsperaCuerpo,
          principal: textos.reintentar,
        ),
      TipoPantallaError.sesion => _Copia(
          icono: Icons.lock_outline_rounded,
          fondo: const Color(0xFFFFE0E0),
          tinta: KavalColors.rojo,
          titulo: textos.errorSesionTitulo,
          cuerpo: textos.errorSesionCuerpo,
          principal: textos.iniciarSesion,
        ),
    };
  }

  void _principal(BuildContext context) {
    if (tipo == TipoPantallaError.sesion) {
      context.go('/auth?modo=login');
      return;
    }
    final accion = paso?.alReintentar;
    volverDeError(context);
    accion?.call();
  }

  void _secundario(BuildContext context) {
    final accion = paso?.alSeguirLocal;
    volverDeError(context);
    accion?.call();
  }
}

void volverDeError(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go('/inicio');
  }
}

class _Copia {
  const _Copia({
    required this.icono,
    required this.fondo,
    required this.tinta,
    required this.titulo,
    required this.cuerpo,
    required this.principal,
    this.secundario,
  });

  final IconData icono;
  final Color fondo;
  final Color tinta;
  final String titulo;
  final String cuerpo;
  final String principal;
  final String? secundario;
}

class _Circulo extends StatelessWidget {
  const _Circulo({required this.icono, required this.fondo, required this.tinta});

  final IconData icono;
  final Color fondo;
  final Color tinta;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(color: fondo, shape: BoxShape.circle),
        child: Icon(icono, size: 64, color: tinta),
      ),
    );
  }
}
