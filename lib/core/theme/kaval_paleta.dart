import 'package:flutter/material.dart';

import 'kaval_colors.dart';

/// Colores del tema, claros u oscuros. Las pantallas nuevas leen esto, no un hex suelto.
class KavalPaleta extends ThemeExtension<KavalPaleta> {
  const KavalPaleta({
    required this.crema,
    required this.coral,
    required this.menta,
    required this.durazno,
    required this.marino,
    required this.verde,
    required this.rojo,
    required this.gris,
    required this.borde,
    required this.campo,
    required this.aviso,
    required this.oro,
    required this.rosa,
    required this.sombra,
    required this.superficie,
  });

  final Color crema;
  final Color coral;
  final Color menta;
  final Color durazno;
  final Color marino;
  final Color verde;
  final Color rojo;
  final Color gris;
  final Color borde;
  final Color campo;
  final Color aviso;
  final Color oro;
  final Color rosa;
  final Color sombra;
  final Color superficie;

  static const clara = KavalPaleta(
    crema: KavalColors.crema,
    coral: KavalColors.coral,
    menta: KavalColors.menta,
    durazno: KavalColors.durazno,
    marino: KavalColors.marino,
    verde: KavalColors.verde,
    rojo: KavalColors.rojo,
    gris: KavalColors.gris,
    borde: KavalColors.borde,
    campo: KavalColors.campo,
    aviso: KavalColors.aviso,
    oro: KavalColors.oro,
    rosa: Color(0xFFFFE4E1),
    sombra: KavalColors.sombra,
    superficie: Colors.white,
  );

  static const oscura = KavalPaleta(
    crema: Color(0xFF1C1714),
    coral: KavalColors.coral,
    menta: Color(0xFF1B3A32),
    durazno: Color(0xFF3A2A24),
    marino: Color(0xFFFFF8F0),
    verde: Color(0xFF3DDC97),
    rojo: Color(0xFFFF8A8A),
    gris: Color(0xFFC4BBB2),
    borde: Color(0xFF4A3E36),
    campo: Color(0xFF2A241F),
    aviso: Color(0xFF3A321C),
    oro: Color(0xFFE0B15A),
    rosa: Color(0xFF3A2424),
    sombra: Color(0x66000000),
    superficie: Color(0xFF2A2420),
  );

  static KavalPaleta de(BuildContext context) {
    return Theme.of(context).extension<KavalPaleta>() ?? clara;
  }

  @override
  KavalPaleta copyWith({
    Color? crema,
    Color? coral,
    Color? menta,
    Color? durazno,
    Color? marino,
    Color? verde,
    Color? rojo,
    Color? gris,
    Color? borde,
    Color? campo,
    Color? aviso,
    Color? oro,
    Color? rosa,
    Color? sombra,
    Color? superficie,
  }) {
    return KavalPaleta(
      crema: crema ?? this.crema,
      coral: coral ?? this.coral,
      menta: menta ?? this.menta,
      durazno: durazno ?? this.durazno,
      marino: marino ?? this.marino,
      verde: verde ?? this.verde,
      rojo: rojo ?? this.rojo,
      gris: gris ?? this.gris,
      borde: borde ?? this.borde,
      campo: campo ?? this.campo,
      aviso: aviso ?? this.aviso,
      oro: oro ?? this.oro,
      rosa: rosa ?? this.rosa,
      sombra: sombra ?? this.sombra,
      superficie: superficie ?? this.superficie,
    );
  }

  @override
  KavalPaleta lerp(ThemeExtension<KavalPaleta>? other, double t) {
    if (other is! KavalPaleta) return this;
    return KavalPaleta(
      crema: Color.lerp(crema, other.crema, t)!,
      coral: Color.lerp(coral, other.coral, t)!,
      menta: Color.lerp(menta, other.menta, t)!,
      durazno: Color.lerp(durazno, other.durazno, t)!,
      marino: Color.lerp(marino, other.marino, t)!,
      verde: Color.lerp(verde, other.verde, t)!,
      rojo: Color.lerp(rojo, other.rojo, t)!,
      gris: Color.lerp(gris, other.gris, t)!,
      borde: Color.lerp(borde, other.borde, t)!,
      campo: Color.lerp(campo, other.campo, t)!,
      aviso: Color.lerp(aviso, other.aviso, t)!,
      oro: Color.lerp(oro, other.oro, t)!,
      rosa: Color.lerp(rosa, other.rosa, t)!,
      sombra: Color.lerp(sombra, other.sombra, t)!,
      superficie: Color.lerp(superficie, other.superficie, t)!,
    );
  }
}
