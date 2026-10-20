import '../utils/dinero.dart';
import '../../models/gasto.dart';

/// Quién adelantó el dinero, según la frase. `ninguno` deja el valor del formulario.
enum QuienPagoDictado { ninguno, tu, fondo, nombrado }

/// Lo que se entendió de una frase. El concepto puede ir vacío: el formulario lo pide.
class GastoDictado {
  const GastoDictado({
    required this.montoCentavos,
    required this.concepto,
    required this.categoria,
    this.quien = QuienPagoDictado.ninguno,
    this.nombrePagador,
    this.entreTodos = false,
  });

  final int montoCentavos;
  final String concepto;
  final CategoriaGasto categoria;
  final QuienPagoDictado quien;

  /// Primer nombre cuando la frase dice «Ana pagó».
  final String? nombrePagador;

  /// La frase reparte entre todo el grupo.
  final bool entreTodos;
}

const _relleno = [
  'pagué',
  'pague',
  'pagamos',
  'pagó',
  'pago',
  'paga',
  'gasté',
  'gaste',
  'gastamos',
  'gastó',
  'compré',
  'compre',
  'compramos',
  'compró',
  'paid',
  'spent',
  'pay',
  'spend',
  'i',
  'we',
  'dólares',
  'dolares',
  'dólar',
  'dolar',
  'dollars',
  'dollar',
  'usd',
  'bucks',
  'pesos',
  'peso',
  'yo',
  'me',
  'de',
  'del',
  'desde',
  'fondo',
  'fund',
  'from',
  'por',
  'para',
  'for',
  'on',
  'of',
  'the',
  'invite',
  'invité',
  'invitamos',
  'invited',
  'la',
  'el',
  'los',
  'las',
  'un',
  'una',
  'al',
  'a',
];

const _transporte = ['gasolina', 'gas', 'uber', 'taxi', 'bus', 'combustible', 'fuel', 'transporte', 'parqueo', 'parking'];
const _hospedaje = ['hotel', 'airbnb', 'hospedaje', 'hostal', 'lodging'];
const _diversion = ['entrada', 'entradas', 'ticket', 'tickets', 'club', 'tour', 'cine'];
const _comida = [
  'pupusa',
  'pupusas',
  'comida',
  'cena',
  'almuerzo',
  'desayuno',
  'taco',
  'tacos',
  'pizza',
  'restaurante',
  'restaurant',
  'food',
  'dinner',
  'lunch',
  'breakfast',
  'cafe',
  'café',
  'mariscos',
];

/// Saca monto y concepto de frases como «pagué 25 dólares de pupusas».
/// Devuelve null si no hay un monto.
GastoDictado? interpretarDictado(String frase) {
  final limpio = frase
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[¿?¡!«»"“”]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  final numero = RegExp(r'\d{1,3}(?:[.,]\d{3})+(?:[.,]\d{1,2})?|\d{1,6}(?:[.,]\d{1,2})?').firstMatch(limpio);
  if (numero == null) return null;
  final centavos = _centavos(numero.group(0)!);
  if (centavos == null) return null;
  final resto = '${limpio.substring(0, numero.start)} ${limpio.substring(numero.end)}';
  final quien = _quien(limpio);
  final concepto = _concepto(resto, quien.nombre);
  return GastoDictado(
    montoCentavos: centavos,
    concepto: concepto,
    categoria: _categoria('$limpio $concepto'),
    quien: quien.quien,
    nombrePagador: quien.nombre,
    entreTodos: quien.entreTodos,
  );
}

const _noEsNombre = {'yo', 'i', 'we', 'me', 'el', 'la', 'un', 'una', 'del', 'de'};

({QuienPagoDictado quien, String? nombre, bool entreTodos}) _quien(String frase) {
  // El acento no es «palabra» para \b, así que el corte se hace con espacio.
  const corte = r'(?=\s|$)';
  if (RegExp('(?:^|\\s)(?:gastamos|del fondo|desde el fondo|we spent|from the fund)$corte').hasMatch(frase)) {
    return (quien: QuienPagoDictado.fondo, nombre: null, entreTodos: true);
  }
  final nombrado = RegExp('(?:^|\\s)([a-záéíóúüñ]{2,})\\s+(pag[oó]|paid)$corte').firstMatch(frase);
  final crudo = nombrado?.group(1);
  if (crudo != null && !_noEsNombre.contains(crudo)) {
    return (
      quien: QuienPagoDictado.nombrado,
      nombre: crudo[0].toUpperCase() + crudo.substring(1),
      entreTodos: true,
    );
  }
  if (RegExp('(?:^|\\s)(?:yo pagu[eé]|pagu[eé]|invit[eé]|i paid|i spent)$corte').hasMatch(frase)) {
    return (quien: QuienPagoDictado.tu, nombre: null, entreTodos: true);
  }
  return (quien: QuienPagoDictado.ninguno, nombre: null, entreTodos: false);
}

/// Elige es-SV o inglés según el idioma de la app y lo que el teléfono ofrece.
String localeDeVoz(Iterable<String> disponibles, String idioma) {
  final lista = [for (final id in disponibles) id.replaceAll('-', '_')];
  final preferidos = idioma == 'en'
      ? const ['en_US', 'en_GB', 'en_AU', 'en']
      : const ['es_SV', 'es_ES', 'es_MX', 'es_419', 'es'];
  for (final quiere in preferidos) {
    for (final tiene in lista) {
      final normal = tiene.toLowerCase();
      final busca = quiere.toLowerCase();
      if (normal == busca || normal.startsWith('${busca}_')) return tiene;
    }
  }
  return idioma == 'en' ? 'en_US' : 'es_SV';
}

int? _centavos(String crudo) {
  final miles = RegExp(r'^(\d{1,3}(?:[.,]\d{3})+)(?:[.,](\d{1,2}))?$').firstMatch(crudo);
  if (miles != null) {
    final entero = int.tryParse(miles.group(1)!.replaceAll(RegExp(r'[.,]'), ''));
    if (entero == null || entero <= 0) return null;
    final decimales = miles.group(2);
    final extra = decimales == null ? 0 : int.parse(decimales.padRight(2, '0'));
    return entero * 100 + extra;
  }
  final valor = centavosDesdeTexto(crudo);
  if (valor == null || valor <= 0) return null;
  return valor;
}

String _concepto(String resto, String? nombrePagador) {
  final nombre = nombrePagador?.toLowerCase();
  final palabras = resto
      .replaceAll(RegExp(r'[$€]'), ' ')
      .split(RegExp(r'\s+'))
      .where((palabra) => palabra.isNotEmpty && !_relleno.contains(palabra) && palabra != nombre)
      .toList();
  if (palabras.isEmpty) return '';
  final texto = palabras.join(' ');
  return texto[0].toUpperCase() + texto.substring(1);
}

CategoriaGasto _categoria(String frase) {
  if (_tiene(frase, _transporte)) return CategoriaGasto.transporte;
  if (_tiene(frase, _hospedaje)) return CategoriaGasto.hospedaje;
  if (_tiene(frase, _diversion)) return CategoriaGasto.diversion;
  if (_tiene(frase, _comida)) return CategoriaGasto.comida;
  return CategoriaGasto.comida;
}

bool _tiene(String frase, List<String> palabras) {
  for (final palabra in palabras) {
    if (RegExp('\\b${RegExp.escape(palabra)}\\b').hasMatch(frase)) return true;
  }
  return false;
}
