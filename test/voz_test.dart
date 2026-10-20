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

  test('pagué, yo pagué e invité dejan al usuario y reparten entre todos', () {
    for (final frase in ['pagué 25 dólares de pupusas', 'yo pagué 24 de gasolina', 'invité 40 de cena']) {
      final oido = interpretarDictado(frase);
      expect(oido?.quien, QuienPagoDictado.tu, reason: frase);
      expect(oido?.entreTodos, isTrue, reason: frase);
      expect(oido?.nombrePagador, isNull, reason: frase);
    }
    expect(interpretarDictado('I paid 25 dollars for gas')?.quien, QuienPagoDictado.tu);
    expect(interpretarDictado('yo pagué 24 de gasolina')?.concepto, 'Gasolina');
    expect(interpretarDictado('invité 40 de cena')?.concepto, 'Cena');
  });

  test('gastamos y del fondo usan el efectivo del grupo', () {
    final gastamos = interpretarDictado('gastamos 10 de cafe');
    expect(gastamos?.quien, QuienPagoDictado.fondo);
    expect(gastamos?.entreTodos, isTrue);
    expect(gastamos?.concepto, 'Cafe');
    expect(gastamos?.montoCentavos, 1000);

    final fondo = interpretarDictado('del fondo 15 de agua');
    expect(fondo?.quien, QuienPagoDictado.fondo);
    expect(fondo?.concepto, 'Agua');
    expect(fondo?.montoCentavos, 1500);
    expect(interpretarDictado('we spent 12 dollars on gas')?.quien, QuienPagoDictado.fondo);
  });

  test('Ana pagó asigna a Ana y no mete el nombre en el concepto', () {
    final oido = interpretarDictado('Ana pagó 18.50 de comida');
    expect(oido?.quien, QuienPagoDictado.nombrado);
    expect(oido?.nombrePagador, 'Ana');
    expect(oido?.entreTodos, isTrue);
    expect(oido?.montoCentavos, 1850);
    expect(oido?.concepto, 'Comida');
    expect(interpretarDictado('Jose paid 10 dollars for gas')?.nombrePagador, 'Jose');
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
