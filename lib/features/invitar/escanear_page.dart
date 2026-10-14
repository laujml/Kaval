import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../core/invitaciones/codigo_leido.dart';
import '../../core/theme/kaval_medidas.dart';
import '../../core/theme/kaval_paleta.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/widgets/aviso.dart';
import '../../core/widgets/estado_vacio.dart';
import '../../l10n/app_localizations.dart';
import '../../state/kaval_state.dart';

/// Lee un QR con el código del viaje y reutiliza unirse.
class EscanearPage extends StatefulWidget {
  const EscanearPage({super.key});

  @override
  State<EscanearPage> createState() => _EscanearPageState();
}

class _EscanearPageState extends State<EscanearPage> {
  final _camara = MobileScannerController();
  var _ocupado = false;

  @override
  void dispose() {
    _camara.dispose();
    super.dispose();
  }

  Future<void> _seguir() async {
    _ocupado = false;
    await _camara.start();
  }

  Future<void> _alDetectar(BarcodeCapture captura) async {
    if (_ocupado || captura.barcodes.isEmpty) return;
    final raw = captura.barcodes.first.rawValue;
    if (raw == null || raw.trim().isEmpty) return;
    final textos = AppLocalizations.of(context);
    final codigo = codigoEnTexto(raw);
    if (codigo == null) {
      _ocupado = true;
      mostrarAviso(context, textos.qrInvalido);
      await Future<void>.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      await _seguir();
      return;
    }
    _ocupado = true;
    await _camara.stop();
    if (!mounted) return;
    try {
      final evento = await context.read<KavalState>().unirse(codigo);
      if (!mounted) return;
      if (evento == null) {
        mostrarAviso(context, textos.codigoInvalido);
        await _seguir();
        return;
      }
      mostrarAviso(context, textos.teUniste);
      context.go('/evento/${evento.id}');
    } catch (error) {
      debugPrint('[kaval] no se pudo unir con el QR: $error');
      if (!mounted) return;
      mostrarAviso(context, textos.errorGenerico);
      await _seguir();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final paleta = KavalPaleta.de(context);
    return Scaffold(
      body: SafeArea(
        child: MarcoKaval(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(KavalMedidas.sm, KavalMedidas.xs, KavalMedidas.sm, KavalMedidas.xs),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: textos.cerrar,
                      onPressed: () => volver(context),
                      icon: Icon(Icons.close, color: paleta.marino),
                    ),
                    Expanded(
                      child: Text(
                        textos.escanearCodigo,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(width: KavalMedidas.toque),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: KavalMedidas.lg),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(KavalMedidas.radioTarjeta),
                    child: Semantics(
                      label: textos.apuntaQr,
                      child: MobileScanner(
                        controller: _camara,
                        onDetect: (captura) => unawaited(_alDetectar(captura)),
                        errorBuilder: (context, error) {
                          final permiso = error.errorCode == MobileScannerErrorCode.permissionDenied;
                          return _AvisoCamara(texto: permiso ? textos.camaraPermiso : textos.errorGenerico);
                        },
                        overlayBuilder: (context, _) => const _Marco(),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(KavalMedidas.xl, KavalMedidas.md, KavalMedidas.xl, KavalMedidas.lg),
                child: Text(
                  textos.apuntaQr,
                  textAlign: TextAlign.center,
                  style: KavalTexto.cuerpo(color: paleta.gris),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvisoCamara extends StatelessWidget {
  const _AvisoCamara({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final paleta = KavalPaleta.de(context);
    return ColoredBox(
      color: paleta.crema,
      child: EstadoVacio(icono: Icons.photo_camera_outlined, titulo: texto, fondo: paleta.durazno, tinta: paleta.coral),
    );
  }
}

class _Marco extends StatelessWidget {
  const _Marco();

  @override
  Widget build(BuildContext context) {
    final paleta = KavalPaleta.de(context);
    return Center(
      child: Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          border: Border.all(color: paleta.coral, width: 3),
          borderRadius: BorderRadius.circular(KavalMedidas.radioTarjeta),
        ),
      ),
    );
  }
}
