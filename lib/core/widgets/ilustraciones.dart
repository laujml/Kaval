import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/evento.dart';

/// Ilustración SVG de la paleta coral. En oscuro recolorea los fondos.
class IlustracionKaval extends StatelessWidget {
  const IlustracionKaval({
    super.key,
    required this.asset,
    this.alto,
    this.ancho,
    this.ajuste = BoxFit.cover,
    this.semanticsLabel,
  });

  final String asset;
  final double? alto;
  final double? ancho;
  final BoxFit ajuste;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final oscuro = Theme.of(context).brightness == Brightness.dark;
    return SvgPicture.asset(
      asset,
      height: alto,
      width: ancho,
      fit: ajuste,
      colorMapper: oscuro ? const _MapaOscuro() : null,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: semanticsLabel == null,
    );
  }
}

class _MapaOscuro extends ColorMapper {
  const _MapaOscuro();

  static const _colores = <int, Color>{
    0xFFD7F0FA: Color(0xFF1A3344),
    0xFF7EC8E3: Color(0xFF2E6D88),
    0xFF5BB6D6: Color(0xFF245E78),
    0xFFF6D7A8: Color(0xFF6A5340),
    0xFFFFE9DE: Color(0xFF3A2A24),
    0xFF9AA8BE: Color(0xFF5C6B80),
    0xFF6D7C90: Color(0xFF4A5568),
    0xFF3A4454: Color(0xFF2A3038),
    0xFFB7D99A: Color(0xFF2C5A38),
    0xFF8FCB7A: Color(0xFF3A7048),
    0xFF5C6B73: Color(0xFF3A444C),
    0xFFB7E4C7: Color(0xFF1B3A32),
    0xFFDFF5EB: Color(0xFF24483C),
    0xFF1F2A3B: Color(0xFFFFF8F0),
    0xFFFFFFFF: Color(0xFFF4EFE8),
  };

  @override
  Color substitute(String? id, String elementName, String attributeName, Color color) {
    return _colores[color.toARGB32()] ?? color;
  }
}

/// Portada de un evento. En tarjetas y encabezados es decorativa.
class IlustracionPortada extends StatelessWidget {
  const IlustracionPortada({
    super.key,
    required this.portada,
    this.alto = 140,
    this.semanticsLabel,
  });

  final PortadaEvento portada;
  final double alto;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return IlustracionKaval(
      asset: assetPortada(portada),
      alto: alto,
      ancho: double.infinity,
      semanticsLabel: semanticsLabel,
    );
  }
}

String assetPortada(PortadaEvento portada) {
  return switch (portada) {
    PortadaEvento.playa => 'assets/illustrations/playa.svg',
    PortadaEvento.volcan => 'assets/illustrations/volcan.svg',
    PortadaEvento.comida => 'assets/illustrations/comida.svg',
    PortadaEvento.carretera => 'assets/illustrations/carretera.svg',
  };
}

class IlustracionPaisaje extends StatelessWidget {
  const IlustracionPaisaje({super.key, this.semanticsLabel});

  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return IlustracionKaval(
      asset: 'assets/illustrations/paisaje.svg',
      alto: 280,
      ancho: double.infinity,
      semanticsLabel: semanticsLabel,
    );
  }
}

class IlustracionVoz extends StatelessWidget {
  const IlustracionVoz({super.key, this.semanticsLabel});

  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return IlustracionKaval(
      asset: 'assets/illustrations/voz.svg',
      alto: 220,
      ancho: double.infinity,
      semanticsLabel: semanticsLabel,
    );
  }
}

class IlustracionCuentas extends StatelessWidget {
  const IlustracionCuentas({super.key, this.ancho = 92, this.alto = 78, this.semanticsLabel});

  final double ancho;
  final double alto;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return IlustracionKaval(
      asset: 'assets/illustrations/cuentas.svg',
      ancho: ancho,
      alto: alto,
      ajuste: BoxFit.contain,
      semanticsLabel: semanticsLabel,
    );
  }
}

class IlustracionCarretera extends StatelessWidget {
  const IlustracionCarretera({super.key, this.semanticsLabel});

  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: IlustracionKaval(
        asset: 'assets/illustrations/carretera.svg',
        alto: 200,
        ancho: double.infinity,
        semanticsLabel: semanticsLabel,
      ),
    );
  }
}

class IlustracionBilletera extends StatelessWidget {
  const IlustracionBilletera({super.key, this.semanticsLabel});

  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return IlustracionKaval(
      asset: 'assets/illustrations/billetera.svg',
      ancho: 92,
      alto: 72,
      ajuste: BoxFit.contain,
      semanticsLabel: semanticsLabel,
    );
  }
}
