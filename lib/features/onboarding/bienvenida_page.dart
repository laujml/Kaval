import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/widgets/boton_coral.dart';
import '../../core/widgets/ilustraciones.dart';
import '../../core/widgets/logo_kaval.dart';
import '../../core/widgets/tarjeta_kaval.dart';
import '../../l10n/app_localizations.dart';
import '../../models/evento.dart';

/// Tres pasos de bienvenida. El primero copia el mockup de onboarding.
class BienvenidaPage extends StatefulWidget {
  const BienvenidaPage({super.key});

  @override
  State<BienvenidaPage> createState() => _BienvenidaPageState();
}

class _BienvenidaPageState extends State<BienvenidaPage> {
  final _control = PageController();
  int _pagina = 0;

  @override
  void dispose() {
    _control.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: KavalColors.crema,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            children: [
              Row(
                children: [
                  LogoKaval(conNombre: true, nombre: textos.marca),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.go('/inicio'),
                    child: Text(
                      textos.saltar,
                      style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.marino),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView(
                  controller: _control,
                  onPageChanged: (valor) => setState(() => _pagina = valor),
                  children: [
                    _Paso(
                      ilustracion: const _CollagePlaya(),
                      titulo: Text.rich(
                        TextSpan(
                          style: KavalTexto.titulo(size: 32, height: 1.05),
                          children: [
                            TextSpan(text: textos.tituloViajen),
                            TextSpan(text: textos.claras, style: KavalTexto.titulo(size: 32, color: KavalColors.coral)),
                            const TextSpan(text: ' ✨'),
                          ],
                        ),
                      ),
                      subtitulo: textos.subtituloBienvenida,
                    ),
                    _Paso(
                      ilustracion: const ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(28)),
                        child: IlustracionPortada(portada: PortadaEvento.volcan, alto: 220),
                      ),
                      titulo: Text(textos.tituloVoz, style: KavalTexto.titulo(size: 32)),
                      subtitulo: textos.subtituloVoz,
                    ),
                    _Paso(
                      ilustracion: const Center(child: IlustracionMonedas()),
                      titulo: Text(textos.tituloCuentas, style: KavalTexto.titulo(size: 32)),
                      subtitulo: textos.subtituloCuentas,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(3, (indice) {
                  final activo = indice == _pagina;
                  return Container(
                    margin: const EdgeInsets.only(right: 6),
                    width: activo ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: activo ? KavalColors.coral : KavalColors.borde,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 18),
              BotonCoral(
                texto: textos.comenzar,
                icono: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                onPressed: () => context.go('/auth'),
              ),
              TextButton(
                onPressed: () => context.go('/auth?modo=login'),
                child: Text.rich(
                  TextSpan(
                    style: KavalTexto.cuerpo(),
                    children: [
                      TextSpan(text: textos.yaTienesCuenta),
                      TextSpan(
                        text: textos.iniciaSesion,
                        style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.coral),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Paso extends StatelessWidget {
  const _Paso({required this.ilustracion, required this.titulo, required this.subtitulo});

  final Widget ilustracion;
  final Widget titulo;
  final String subtitulo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          ilustracion,
          const SizedBox(height: 22),
          titulo,
          const SizedBox(height: 10),
          Text(subtitulo, style: KavalTexto.cuerpo(size: 16, height: 1.35)),
        ],
      ),
    );
  }
}

class _CollagePlaya extends StatelessWidget {
  const _CollagePlaya();

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: SizedBox(
        height: 280,
        child: Stack(
          children: [
            const Positioned.fill(child: CustomPaint(painter: PintorPlaya())),
            Positioned(
              left: 36,
              right: 16,
              top: 18,
              child: _TarjetaFlotante(
                emoji: '🫓',
                titulo: textos.pupusas,
                detalle: textos.efectivoCinco,
                monto: '\$18.50',
              ),
            ),
            Positioned(
              left: 12,
              right: 48,
              top: 92,
              child: TarjetaKaval(
                radio: 18,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: KavalColors.coral,
                      child: Icon(Icons.mic_rounded, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(textos.burbujaVoz, style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800)),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 28,
              right: 12,
              top: 158,
              child: _TarjetaFlotante(
                emoji: '⛽',
                titulo: textos.gasolina,
                detalle: textos.pagoLaura,
                monto: '\$24.00',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaFlotante extends StatelessWidget {
  const _TarjetaFlotante({
    required this.emoji,
    required this.titulo,
    required this.detalle,
    required this.monto,
  });

  final String emoji;
  final String titulo;
  final String detalle;
  final String monto;

  @override
  Widget build(BuildContext context) {
    return TarjetaKaval(
      radio: 18,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.marino)),
                Text(detalle, style: KavalTexto.cuerpo(size: 12)),
              ],
            ),
          ),
          Text(monto, style: KavalTexto.titulo(size: 16)),
        ],
      ),
    );
  }
}
