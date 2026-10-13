import 'package:flutter/material.dart';

import '../theme/kaval_colors.dart';
import '../theme/kaval_texto.dart';

/// Inicio, Eventos, micrófono central, Historial y Perfil.
class BarraInferiorKaval extends StatelessWidget {
  const BarraInferiorKaval({
    super.key,
    required this.indice,
    required this.onTap,
    required this.onMicrofono,
    required this.inicio,
    required this.eventos,
    required this.historial,
    required this.perfil,
  });

  /// 0 inicio, 1 eventos, 3 historial, 4 perfil. El 2 es el micrófono.
  final int indice;
  final ValueChanged<int> onTap;
  final VoidCallback onMicrofono;
  final String inicio;
  final String eventos;
  final String historial;
  final String perfil;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 68,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: KavalColors.sombra,
                  blurRadius: 18,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                _item(0, Icons.home_rounded, inicio),
                _item(1, Icons.luggage_rounded, eventos),
                const SizedBox(width: 64),
                _item(3, Icons.schedule_rounded, historial),
                _item(4, Icons.person_rounded, perfil),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: _Microfono(onTap: onMicrofono),
          ),
        ],
      ),
    );
  }

  Widget _item(int valor, IconData icono, String texto) {
    final activo = indice == valor;
    final color = activo ? KavalColors.coral : KavalColors.gris;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(valor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              texto,
              style: KavalTexto.cuerpo(
                size: 11,
                weight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Microfono extends StatelessWidget {
  const _Microfono({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: KavalColors.coral,
      shape: const CircleBorder(),
      elevation: 6,
      shadowColor: KavalColors.coral.withValues(alpha: 0.45),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 62,
          height: 62,
          child: Icon(Icons.mic_rounded, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
