import 'package:flutter_test/flutter_test.dart';
import 'package:kaval/core/invitaciones/codigo_leido.dart';
import 'package:kaval/core/voz/interpretar_dictado.dart';
import 'package:kaval/models/gasto.dart';

void main() {
  test('pagué 25 dólares de pupusas deja monto, concepto y comida', () {
    final oido = interpretarDictado('pagué 25 dólares de pupusas');
    expect(oido, isNotNull);
    expect(oido!.montoCentavos, 2500);
    expect(oido.concepto, 'Pupusas');
    expect(oido.categoria, CategoriaGasto.comida);
  });

  test('acepta la frase sin tildes y en inglés', () {
    expect(interpretarDictado('pague 25 dolares de pupusas')?.montoCentavos, 2500);
    final gas = interpretarDictado('I paid 25 dollars for gas');
    expect(gas?.montoCentavos, 2500);
    expect(gas?.concepto, 'Gas');
    expect(gas?.categoria, CategoriaGasto.transporte);
  });

  test('pagué 24 de gasolina es transporte', () {
    final oido = interpretarDictado('pagué 24 de gasolina');
    expect(oido?.montoCentavos, 2400);
    expect(oido?.concepto, 'Gasolina');
    expect(oido?.categoria, CategoriaGasto.transporte);
  });

  test('lee decimales con punto o coma, y miles', () {
    expect(interpretarDictado('18.50 de pupusas')?.montoCentavos, 1850);
    expect(interpretarDictado('25,50 de tacos')?.concepto, 'Tacos');
    expect(interpretarDictado('25,50 de tacos')?.montoCentavos, 2550);
    expect(interpretarDictado('1,250 de hotel')?.montoCentavos, 125000);
    expect(interpretarDictado('1,250 de hotel')?.categoria, CategoriaGasto.hospedaje);
  });

  test('sin monto no hay gasto', () {
    expect(interpretarDictado(''), isNull);
    expect(interpretarDictado('hola equipo'), isNull);
    expect(interpretarDictado('pagué pupusas')?.concepto, isNull);
  });

  test('un monto solo prellena el número y deja el concepto vacío', () {
    final oido = interpretarDictado('25 dólares');
    expect(oido?.montoCentavos, 2500);
    expect(oido?.concepto, isEmpty);
  });

  test('el idioma elige es_SV o en_US entre los que ofrece el teléfono', () {
    const locales = ['en_US', 'es_ES', 'es_SV', 'es_MX'];
    expect(localeDeVoz(locales, 'es'), 'es_SV');
    expect(localeDeVoz(locales, 'en'), 'en_US');
    expect(localeDeVoz(const ['es_MX', 'es_ES'], 'es'), 'es_ES');
    expect(localeDeVoz(const ['fr_FR'], 'es'), 'es_SV');
  });

  test('el QR puede ser el código solo o dentro de una frase', () {
    expect(codigoEnTexto('tunco-7k2'), 'TUNCO-7K2');
    expect(codigoEnTexto('Únete a Kaval. Código: TUNCO-7K2'), 'TUNCO-7K2');
    expect(codigoEnTexto('https://ejemplo.test/viaje/FLORES-3M'), 'FLORES-3M');
    expect(codigoEnTexto('hola'), isNull);
    expect(codigoEnTexto('   '), isNull);
  });
}
