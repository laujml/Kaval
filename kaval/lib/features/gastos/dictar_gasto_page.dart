import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/widgets/aviso.dart';
import '../../core/widgets/logo_kaval.dart';
import '../../l10n/app_localizations.dart';
import '../../state/kaval_state.dart';

/// Maqueta del dictado. El micrófono real queda para la fase 2.
class DictarGastoPage extends StatefulWidget {
  const DictarGastoPage({super.key, required this.eventoId});

  final String eventoId;

  @override
  State<DictarGastoPage> createState() => _DictarGastoPageState();
}

class _DictarGastoPageState extends State<DictarGastoPage> with SingleTickerProviderStateMixin {
  late final AnimationController _pulso;

  @override
  void initState() {
    super.initState();
    _pulso = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulso.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final evento = context.watch<KavalState>().buscar(widget.eventoId);
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
                      label: Text('${evento?.emoji ?? ''} ${evento?.nombre ?? ''}', style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800)),
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
                Text('● ${textos.escuchando}', style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.rojo)),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    style: KavalTexto.titulo(size: 26, height: 1.25),
                    children: [
                      const TextSpan(text: '“'),
                      TextSpan(text: textos.fraseDictado),
                      const TextSpan(text: '”'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(textos.transcribiendo, style: KavalTexto.cuerpo(size: 12)),
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _pulso,
                  builder: (context, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(12, (indice) {
                        final alto = 12 + 28 * ((indice.isEven ? _pulso.value : 1 - _pulso.value));
                        return Container(
                          width: 6,
                          height: alto,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(color: KavalColors.coral, borderRadius: BorderRadius.circular(4)),
                        );
                      }),
                    );
                  },
                ),
                const Spacer(),
                AnimatedBuilder(
                  animation: _pulso,
                  builder: (context, child) {
                    return Container(
                      padding: EdgeInsets.all(8 + 10 * _pulso.value),
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
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _Accion(icono: Icons.close, texto: textos.cancelar, onTap: () => volver(context)),
                    _Accion(
                      icono: Icons.stop_rounded,
                      texto: textos.listo,
                      oscuro: true,
                      onTap: () => context.push('/evento/${widget.eventoId}/confirmar'),
                    ),
                    _Accion(
                      icono: Icons.keyboard_alt_outlined,
                      texto: textos.escribir,
                      onTap: () => context.push('/evento/${widget.eventoId}/gasto'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('💡 ${textos.tipDictado}', textAlign: TextAlign.center, style: KavalTexto.cuerpo(size: 13)),
                const SizedBox(height: 8),
                Text('🔒 ${textos.soloTexto}', style: KavalTexto.cuerpo(size: 12)),
              ],
            ),
          ),
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
    return Column(
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
    );
  }
}
