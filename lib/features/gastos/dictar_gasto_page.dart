import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/voz/interpretar_dictado.dart';
import '../../core/widgets/aviso.dart';
import '../../core/widgets/logo_kaval.dart';
import '../../l10n/app_localizations.dart';
import '../../state/kaval_state.dart';

/// Escucha una frase y abre Nuevo gasto con el monto y el concepto para revisarlos.
class DictarGastoPage extends StatefulWidget {
  const DictarGastoPage({super.key, required this.eventoId});

  final String eventoId;

  @override
  State<DictarGastoPage> createState() => _DictarGastoPageState();
}

class _DictarGastoPageState extends State<DictarGastoPage> with SingleTickerProviderStateMixin {
  final _voz = SpeechToText();
  late final AnimationController _pulso;
  String _texto = '';
  String? _mensaje;
  var _escuchando = false;
  var _cerrando = false;
  var _listo = false;

  @override
  void initState() {
    super.initState();
    _pulso = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    WidgetsBinding.instance.addPostFrameCallback((_) => _empezar());
  }

  @override
  void dispose() {
    _pulso.dispose();
    unawaited(_voz.cancel());
    super.dispose();
  }

  Future<void> _empezar() async {
    final textos = AppLocalizations.of(context);
    final idioma = context.read<KavalState>().idioma;
    final ok = await _voz.initialize(onError: _alError, onStatus: _alEstado);
    if (!mounted) return;
    if (!ok) {
      final permiso = await _voz.hasPermission;
      if (!mounted) return;
      setState(() => _mensaje = permiso ? textos.vozNoDisponible : textos.vozPermiso);
      return;
    }
    final ofrecidos = await _voz.locales();
    if (!mounted) return;
    _listo = true;
    await _escuchar(localeDeVoz(ofrecidos.map((locale) => locale.localeId), idioma));
  }

  Future<void> _escuchar(String localeId) async {
    if (!_listo || _cerrando) return;
    await _voz.listen(
      onResult: (resultado) {
        if (!mounted) return;
        setState(() => _texto = resultado.recognizedWords);
      },
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        localeId: localeId,
        cancelOnError: true,
        partialResults: true,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
      ),
    );
    if (!mounted) return;
    setState(() => _escuchando = true);
    _pulso.repeat(reverse: true);
  }

  void _alError(SpeechRecognitionError error) {
    if (!mounted) return;
    final textos = AppLocalizations.of(context);
    final codigo = error.errorMsg.toLowerCase();
    final mensaje = codigo.contains('network') || codigo.contains('server')
        ? textos.vozSinRed
        : codigo.contains('permission') || codigo.contains('audio')
            ? textos.vozPermiso
            : textos.vozNoEntendida;
    _pulso.stop();
    setState(() {
      _escuchando = false;
      _mensaje = mensaje;
    });
  }

  void _alEstado(String estado) {
    if (!mounted) return;
    final activo = estado == 'listening';
    if (activo == _escuchando) return;
    if (!activo) _pulso.stop();
    setState(() => _escuchando = activo);
  }

  Future<void> _usarFrase() async {
    if (_cerrando) return;
    _cerrando = true;
    final textos = AppLocalizations.of(context);
    final idioma = context.read<KavalState>().idioma;
    if (_listo) await _voz.stop();
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    final oido = interpretarDictado(_texto);
    if (oido == null) {
      _cerrando = false;
      setState(() => _mensaje = textos.vozNoEntendida);
      if (_listo) {
        final ofrecidos = await _voz.locales();
        if (!mounted) return;
        await _escuchar(localeDeVoz(ofrecidos.map((locale) => locale.localeId), idioma));
      }
      return;
    }
    context.read<KavalState>().aplicarDictado(
          eventoId: widget.eventoId,
          montoCentavos: oido.montoCentavos,
          concepto: oido.concepto,
          categoria: oido.categoria,
          frase: _texto.trim(),
          quien: oido.quien,
          nombrePagador: oido.nombrePagador,
          entreTodos: oido.entreTodos,
        );
    if (!mounted) return;
    context.push('/evento/${widget.eventoId}/gasto?voz=1');
    _cerrando = false;
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final evento = context.watch<KavalState>().buscar(widget.eventoId);
    final frase = _texto.trim().isEmpty ? textos.tipDictado : _texto.trim();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [KavalColors.durazno, KavalColors.crema],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    BotonRedondo(icono: Icons.close, onTap: () => volver(context)),
                    const Spacer(),
                    Chip(
                      label: Text(
                        evento?.nombre ?? '',
                        style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    const Spacer(),
                    BotonRedondo(
                      icono: Icons.help_outline,
                      onTap: () => mostrarAviso(context, textos.ayudaVoz),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  _escuchando ? textos.escuchando : textos.transcribiendo,
                  style: KavalTexto.cuerpo(
                    weight: FontWeight.w800,
                    color: _escuchando ? KavalColors.rojo : KavalColors.gris,
                  ),
                ),
                const SizedBox(height: 16),
                Semantics(
                  liveRegion: true,
                  label: frase,
                  child: Text(
                    '“$frase”',
                    textAlign: TextAlign.center,
                    style: KavalTexto.titulo(size: 26, height: 1.25),
                  ),
                ),
                if (_mensaje != null) ...[
                  const SizedBox(height: 12),
                  Text(_mensaje!, textAlign: TextAlign.center, style: KavalTexto.cuerpo(color: KavalColors.marino)),
                ],
                const SizedBox(height: 20),
                _Onda(pulso: _pulso, activa: _escuchando),
                const Spacer(),
                _Microfono(pulso: _pulso, activa: _escuchando, etiqueta: textos.escuchando),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _Accion(icono: Icons.close, texto: textos.cancelar, onTap: () => volver(context)),
                    _Accion(icono: Icons.check_rounded, texto: textos.listo, oscuro: true, onTap: _usarFrase),
                    _Accion(
                      icono: Icons.keyboard_alt_outlined,
                      texto: textos.escribir,
                      onTap: () => context.push('/evento/${widget.eventoId}/gasto'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ExcludeSemantics(child: Icon(Icons.lightbulb_outline, size: 16, color: KavalColors.coral)),
                    const SizedBox(width: 6),
                    Flexible(child: Text(textos.tipDictado, textAlign: TextAlign.center, style: KavalTexto.cuerpo(size: 13))),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ExcludeSemantics(child: Icon(Icons.lock_outline, size: 14, color: KavalColors.gris)),
                    const SizedBox(width: 6),
                    Flexible(child: Text(textos.soloTexto, style: KavalTexto.cuerpo(size: 12))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Onda extends StatelessWidget {
  const _Onda({required this.pulso, required this.activa});

  final Animation<double> pulso;
  final bool activa;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulso,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(12, (indice) {
            final avance = activa ? (indice.isEven ? pulso.value : 1 - pulso.value) : 0.2;
            return Container(
              width: 6,
              height: 12 + 28 * avance,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(color: KavalColors.coral, borderRadius: BorderRadius.circular(4)),
            );
          }),
        );
      },
    );
  }
}

class _Microfono extends StatelessWidget {
  const _Microfono({required this.pulso, required this.activa, required this.etiqueta});

  final Animation<double> pulso;
  final bool activa;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: etiqueta,
      child: AnimatedBuilder(
        animation: pulso,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.all(activa ? 8 + 10 * pulso.value : 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: KavalColors.coral.withValues(alpha: 0.18),
            ),
            child: child,
          );
        },
        child: Container(
          width: 96,
          height: 96,
          decoration: const BoxDecoration(color: KavalColors.coral, shape: BoxShape.circle),
          child: const Icon(Icons.mic_rounded, color: Colors.white, size: 42),
        ),
      ),
    );
  }
}

class _Accion extends StatelessWidget {
  const _Accion({required this.icono, required this.texto, required this.onTap, this.oscuro = false});

  final IconData icono;
  final String texto;
  final VoidCallback onTap;
  final bool oscuro;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: texto,
      child: Column(
        children: [
          Material(
            color: oscuro ? KavalColors.marino : Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: SizedBox(
                width: 56,
                height: 56,
                child: Icon(icono, color: oscuro ? Colors.white : KavalColors.marino),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(texto, style: KavalTexto.cuerpo(size: 12, weight: FontWeight.w800, color: KavalColors.marino)),
        ],
      ),
    );
  }
}
