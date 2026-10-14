import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/kaval_medidas.dart';
import '../../core/theme/kaval_paleta.dart';
import '../../core/widgets/boton_coral.dart';
import '../../core/widgets/estado_vacio.dart';
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
    final paleta = KavalPaleta.de(context);
    final copia = _copia(textos, paleta);
    return Scaffold(
      body: SafeArea(
        child: MarcoKaval(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(KavalMedidas.xl, KavalMedidas.sm, KavalMedidas.xl, KavalMedidas.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    tooltip: textos.cerrar,
                    onPressed: () => volverDeError(context),
                    icon: Icon(Icons.close, color: paleta.marino),
                  ),
                ),
                const Spacer(),
                EstadoVacio(icono: copia.icono, titulo: copia.titulo, cuerpo: copia.cuerpo, fondo: copia.fondo, tinta: copia.tinta),
                const Spacer(),
                BotonCoral(texto: copia.principal, onPressed: () => _principal(context)),
                if (copia.secundario != null) ...[
                  const SizedBox(height: KavalMedidas.sm),
                  BotonBlanco(texto: copia.secundario!, onPressed: () => _secundario(context)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  _Copia _copia(AppLocalizations textos, KavalPaleta paleta) {
    return switch (tipo) {
      TipoPantallaError.red => _Copia(
          icono: Icons.wifi_off_rounded,
          fondo: paleta.durazno,
          tinta: paleta.coral,
          titulo: textos.errorSinRedTitulo,
          cuerpo: textos.errorSinRedCuerpo,
          principal: textos.reintentar,
          secundario: textos.seguirSinConexion,
        ),
      TipoPantallaError.espera => _Copia(
          icono: Icons.hourglass_top_rounded,
          fondo: paleta.aviso,
          tinta: paleta.oro,
          titulo: textos.errorEsperaTitulo,
          cuerpo: textos.errorEsperaCuerpo,
          principal: textos.reintentar,
        ),
      TipoPantallaError.sesion => _Copia(
          icono: Icons.lock_outline_rounded,
          fondo: paleta.rosa,
          tinta: paleta.rojo,
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

