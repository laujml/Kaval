import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/evento.dart';
import '../theme/kaval_colors.dart';

/// Elige la portada pastel según el tipo de evento.
class IlustracionPortada extends StatelessWidget {
  const IlustracionPortada({super.key, required this.portada, this.alto = 140});

  final PortadaEvento portada;
  final double alto;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: alto,
      width: double.infinity,
      child: CustomPaint(painter: _pintor(portada), child: const SizedBox.expand()),
    );
  }
}

CustomPainter _pintor(PortadaEvento portada) {
  return switch (portada) {
    PortadaEvento.playa => const PintorPlaya(),
    PortadaEvento.volcan => const PintorVolcan(),
    PortadaEvento.comida => const PintorComida(),
    PortadaEvento.carretera => const PintorCerros(),
  };
}

class PintorPlaya extends CustomPainter {
  const PintorPlaya();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8E7D8), Color(0xFFD7F0FA), Color(0xFF7EC8E3)],
          stops: [0, 0.45, 0.72],
        ).createShader(rect),
    );
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.22),
      size.height * 0.12,
      Paint()..color = const Color(0xFFF6C445),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.22, size.height * 0.2),
        width: size.width * 0.22,
        height: size.height * 0.08,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );
    final volcan = Path()
      ..moveTo(size.width * 0.38, size.height * 0.62)
      ..lineTo(size.width * 0.52, size.height * 0.28)
      ..lineTo(size.width * 0.68, size.height * 0.62)
      ..close();
    canvas.drawPath(volcan, Paint()..color = const Color(0xFF9AA8BE));
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3),
      Paint()..color = const Color(0xFFF6D7A8),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.74, size.height * 0.66),
        width: size.width * 0.16,
        height: size.height * 0.12,
      ),
      Paint()..color = const Color(0xFF6D7C90),
    );
    final tronco = Paint()
      ..color = const Color(0xFFC48A5A)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.16, size.height * 0.78),
      Offset(size.width * 0.2, size.height * 0.48),
      tronco,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.14, size.height * 0.46),
        width: 28,
        height: 16,
      ),
      Paint()..color = const Color(0xFF3E9B4F),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.24, size.height * 0.44),
        width: 26,
        height: 14,
      ),
      Paint()..color = const Color(0xFF2F8A42),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.88, size.height * 0.78),
          width: 14,
          height: 36,
        ),
        const Radius.circular(6),
      ),
      Paint()..color = KavalColors.coral,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PintorVolcan extends CustomPainter {
  const PintorVolcan();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFE7F3FF),
    );
    final cono = Path()
      ..moveTo(size.width * 0.18, size.height * 0.82)
      ..lineTo(size.width * 0.5, size.height * 0.18)
      ..lineTo(size.width * 0.82, size.height * 0.82)
      ..close();
    canvas.drawPath(cono, Paint()..color = const Color(0xFF7E8CA3));
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.2),
      8,
      Paint()..color = KavalColors.coral,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PintorComida extends CustomPainter {
  const PintorComida();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFFFF1E4));
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.55),
      size.height * 0.28,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(size.width * 0.42, size.height * 0.52),
      10,
      Paint()..color = const Color(0xFFF0C36A),
    );
    canvas.drawCircle(
      Offset(size.width * 0.56, size.height * 0.5),
      10,
      Paint()..color = const Color(0xFFE7A15A),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PintorCerros extends CustomPainter {
  const PintorCerros();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFD7F0FA), Color(0xFFE7F6DF)],
        ).createShader(rect),
    );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.22),
      16,
      Paint()..color = const Color(0xFFF6C445),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-10, size.height * 0.48, size.width * 0.7, size.height * 0.28),
        const Radius.circular(40),
      ),
      Paint()..color = const Color(0xFFB7D99A),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.3, size.height * 0.4, size.width * 0.8, size.height * 0.32),
        const Radius.circular(40),
      ),
      Paint()..color = const Color(0xFF8FCB7A),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Carretera de la pantalla de registro. Viene de la semana 7.
class IlustracionCarretera extends StatelessWidget {
  const IlustracionCarretera({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: const SizedBox(
        height: 200,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: PintorCerros()),
            Positioned(left: 0, right: 0, bottom: 0, child: _Camino()),
            Positioned(left: 0, right: 0, bottom: 16, child: Center(child: _Carrito())),
            Positioned(top: 18, right: 16, child: _PlacaTunco()),
          ],
        ),
      ),
    );
  }
}

class _Camino extends StatelessWidget {
  const _Camino();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      color: const Color(0xFF5C6B73),
      alignment: Alignment.center,
      child: Container(
        height: 3,
        margin: const EdgeInsets.symmetric(horizontal: 28),
        color: const Color(0xFFE7E2D6),
      ),
    );
  }
}

class _PlacaTunco extends StatelessWidget {
  const _PlacaTunco();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF3E9B4F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'El Tunco',
        style: GoogleFonts.nunito(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _Carrito extends StatelessWidget {
  const _Carrito();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 124,
      height: 64,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 10,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: KavalColors.coral,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: SizedBox(width: 112, height: 32),
            ),
          ),
          Positioned(bottom: 32, child: _Cabina()),
          Positioned(bottom: 50, child: _Tabla()),
          Positioned(left: 22, bottom: 2, child: _Rueda()),
          Positioned(right: 22, bottom: 2, child: _Rueda()),
        ],
      ),
    );
  }
}

class _Cabina extends StatelessWidget {
  const _Cabina();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: const BoxDecoration(
        color: Color(0xFFFF8A70),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [_Ventana(), _Ventana()],
      ),
    );
  }
}

class _Ventana extends StatelessWidget {
  const _Ventana();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 12,
      decoration: BoxDecoration(
        color: const Color(0xFFD7EEF8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _Tabla extends StatelessWidget {
  const _Tabla();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 7,
      decoration: BoxDecoration(
        color: const Color(0xFFF6C445),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _Rueda extends StatelessWidget {
  const _Rueda();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: const Color(0xFF2C3338),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD7D3CC), width: 2),
      ),
    );
  }
}

class IlustracionBilletera extends StatelessWidget {
  const IlustracionBilletera({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 92,
      height: 72,
      child: Stack(
        children: [
          Positioned(left: 8, top: 8, child: _Billete()),
          Positioned(
            left: 0,
            bottom: 0,
            child: _Cartera(),
          ),
        ],
      ),
    );
  }
}

class _Billete extends StatelessWidget {
  const _Billete();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFB7E4C7),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: const Text('\$', style: TextStyle(color: Color(0xFF1FA971), fontWeight: FontWeight.w800)),
    );
  }
}

class _Cartera extends StatelessWidget {
  const _Cartera();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 46,
      decoration: BoxDecoration(
        color: KavalColors.coral,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        width: 16,
        height: 16,
        decoration: const BoxDecoration(color: Color(0xFFF6C445), shape: BoxShape.circle),
      ),
    );
  }
}

class IlustracionMonedas extends StatelessWidget {
  const IlustracionMonedas({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 70,
      height: 64,
      child: Stack(
        children: [
          Positioned(right: 0, top: 0, child: _Moneda(ancho: 36, alto: 22, color: Color(0xFFB7E4C7))),
          Positioned(right: 8, bottom: 4, child: _Moneda(ancho: 48, alto: 28, color: Color(0xFFF6C445))),
        ],
      ),
    );
  }
}

class _Moneda extends StatelessWidget {
  const _Moneda({required this.ancho, required this.alto, required this.color});

  final double ancho;
  final double alto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ancho,
      height: alto,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
    );
  }
}
