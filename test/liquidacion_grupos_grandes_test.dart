// BUG-010 (SETT-022, SETT-027, SETT-031): la búsqueda de transferencias mínimas
// era exhaustiva y congelaba la UI con 13-14 integrantes.
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kaval/core/liquidacion/liquidacion.dart';
import 'package:kaval/models/evento.dart';
import 'package:kaval/models/gasto.dart';
import 'package:kaval/models/integrante.dart';
import 'package:kaval/models/transferencia.dart';
import 'package:kaval/state/kaval_state.dart';

import 'fixtures/datos_ejemplo.dart';

final _fecha = DateTime(2026, 10, 1);

/// [n] personas; cada una paga un gasto distinto para todos (mismo conjunto que SETT-022).
Evento _grupo(int n, {int pagadores = -1}) {
  final rng = Random(20261101 + n);
  final ids = [for (var i = 0; i < n; i++) 'p${i.toString().padLeft(2, '0')}'];
  final cuantos = pagadores < 0 ? n : pagadores;
  return Evento(
    id: 'grupo-$n',
    nombre: 'Grupo de $n',
    lugar: '',
    inicio: _fecha,
    fin: _fecha,
    portada: PortadaEvento.playa,
    codigo: 'G$n',
    custodioId: ids.first,
    integrantes: [for (final id in ids) Integrante(id: id, nombre: id, colorFondo: 0, colorInicial: 0)],
    aportes: const [],
    gastos: [
      for (var i = 0; i < cuantos; i++)
        Gasto(
          id: 'g$i',
          concepto: 'g$i',
          montoCentavos: 1000 + rng.nextInt(90000),
          pagadorId: ids[i],
          participanteIds: ids,
          categoria: CategoriaGasto.comida,
          metodo: MetodoPago.tarjeta,
          fecha: _fecha,
        ),
    ],
  );
}

/// Saldos al azar que suman cero: [deudores] negativos y [acreedores] positivos.
Map<String, int> _saldosAzar(Random r, int deudores, int acreedores) {
  final saldos = <String, int>{};
  var total = 0;
  for (var i = 0; i < acreedores; i++) {
    final monto = 100 + r.nextInt(50000);
    saldos['c$i'] = monto;
    total += monto;
  }
  final cortes = [for (var i = 0; i < deudores - 1; i++) 1 + r.nextInt(total - 1)]..sort();
  var previo = 0;
  for (var i = 0; i < deudores; i++) {
    final corte = i < deudores - 1 ? cortes[i] : total;
    if (corte > previo) saldos['d$i'] = -(corte - previo);
    previo = corte;
  }
  return saldos;
}

void _quedaEnCero(Map<String, int> saldos, List<Transferencia> pagos) {
  final resto = Map<String, int>.of(saldos);
  for (final pago in pagos) {
    expect(pago.montoCentavos, greaterThan(0));
    resto[pago.deudorId] = (resto[pago.deudorId] ?? 0) + pago.montoCentavos;
    resto[pago.acreedorId] = (resto[pago.acreedorId] ?? 0) - pago.montoCentavos;
  }
  expect(resto.values.where((v) => v != 0), isEmpty, reason: 'saldos sin cuadrar: $resto');
}

int _distintosDeCero(Map<String, int> saldos) => saldos.values.where((v) => v != 0).length;

void main() {
  group('BUG-010 mismas transferencias que la búsqueda exhaustiva', () {
    test('hasta 8 saldos distintos de cero: lista idéntica a la del algoritmo original', () {
      final r = Random(7);
      for (var m = 2; m <= 8; m++) {
        for (var deudores = 1; deudores < m; deudores++) {
          for (var k = 0; k < 6; k++) {
            final saldos = _saldosAzar(r, deudores, m - deudores);
            expect(_firma(deudaMinima(saldos)), _firma(_deudaMinimaOriginal(saldos)), reason: 'saldos=$saldos');
          }
        }
      }
    });

    test('9 y 10 saldos: el mismo número de transferencias que el óptimo exhaustivo', () {
      final r = Random(11);
      for (final m in [9, 10]) {
        for (var deudores = 2; deudores < m - 1; deudores++) {
          final saldos = _saldosAzar(r, deudores, m - deudores);
          final pagos = deudaMinima(saldos);
          _quedaEnCero(saldos, pagos);
          expect(pagos.length, lessThanOrEqualTo(_deudaMinimaOriginal(saldos).length), reason: 'saldos=$saldos');
        }
      }
    }, timeout: const Timeout(Duration(minutes: 3)));

    test('aprovecha subgrupos que se saldan solos (óptimo < n-1)', () {
      // a<->b y c,d<->e se cancelan por separado: 3 pagos, no 4.
      final saldos = {'a': -500, 'b': 500, 'c': -300, 'd': -200, 'e': 500, 'f': -700, 'g': 400, 'h': 300, 'i': -100, 'j': 100};
      final pagos = deudaMinima(saldos);
      _quedaEnCero(saldos, pagos);
      expect(pagos.length, 6);
    });

    test('los fixtures de siempre siguen con las mismas cifras', () {
      final tunco = calcularLiquidacion(eventoPlayaTunco());
      expect(tunco.transferencias.length, lessThanOrEqualTo(tunco.saldos.length - 1));
      _quedaEnCero(tunco.saldos, tunco.transferencias);
      expect(_firma(tunco.transferencias), _firma(_deudaMinimaOriginal(tunco.saldos)));
      final flores = calcularLiquidacion(eventoRutaFlores());
      expect(_firma(flores.transferencias), _firma(_deudaMinimaOriginal(flores.saldos)));
    });
  });

  group('BUG-010 grupos grandes en menos de 1 s', () {
    for (final n in [13, 14, 15, 16, 20, 30]) {
      test('$n integrantes, cada uno paga un gasto', () {
        final cuentas = calcularSaldos(_grupo(n));
        final reloj = Stopwatch()..start();
        final pagos = liquidar(cuentas.saldos);
        reloj.stop();
        _quedaEnCero(cuentas.saldos, pagos);
        expect(pagos.length, lessThanOrEqualTo(_distintosDeCero(cuentas.saldos) - 1));
        expect(reloj.elapsedMilliseconds, lessThan(1000));
      }, timeout: const Timeout(Duration(seconds: 30)));
    }

    test('14 integrantes con 5 pagadores (datos del dispositivo, SETT-031)', () {
      final cuentas = calcularSaldos(_grupo(14, pagadores: 5));
      final reloj = Stopwatch()..start();
      final pagos = liquidar(cuentas.saldos);
      reloj.stop();
      _quedaEnCero(cuentas.saldos, pagos);
      expect(reloj.elapsedMilliseconds, lessThan(1000));
    }, timeout: const Timeout(Duration(seconds: 30)));

    test('un deudor frente a 12 acreedores (peor caso de la búsqueda exhaustiva)', () {
      final saldos = _saldosAzar(Random(3), 1, 12);
      final reloj = Stopwatch()..start();
      final pagos = deudaMinima(saldos);
      reloj.stop();
      _quedaEnCero(saldos, pagos);
      expect(pagos.length, 12);
      expect(reloj.elapsedMilliseconds, lessThan(1000));
    }, timeout: const Timeout(Duration(seconds: 30)));
  });

  group('BUG-010 KavalState calcula una vez por cambio de datos', () {
    test('la misma versión del evento reutiliza la liquidación y un cambio la recalcula', () {
      final estado = KavalState()..entrar(nombre: 'Laura', correo: 'laura@example.com', local: true);
      final evento = _grupo(14, pagadores: 5);
      estado.crearEvento(evento);

      final primera = estado.liquidacionDe(evento.id)!;
      expect(identical(estado.liquidacionDe(evento.id), primera), isTrue);

      final reloj = Stopwatch()..start();
      for (var i = 0; i < 50; i++) {
        estado.teDeben;
        estado.debes;
        estado.balanceGeneral;
        estado.saldoEn(estado.buscar(evento.id)!);
      }
      reloj.stop();
      expect(reloj.elapsedMilliseconds, lessThan(1000));

      estado.agregarGasto(
        evento.id,
        Gasto(
          id: 'extra',
          concepto: 'extra',
          montoCentavos: 1400,
          pagadorId: 'p13',
          participanteIds: [for (final p in evento.integrantes) p.id],
          categoria: CategoriaGasto.comida,
          metodo: MetodoPago.tarjeta,
          fecha: _fecha,
        ),
      );
      final segunda = estado.liquidacionDe(evento.id)!;
      expect(identical(segunda, primera), isFalse);
      expect(segunda.saldoDe('p13'), isNot(primera.saldoDe('p13')));
      expect(segunda.saldos, calcularSaldos(estado.buscar(evento.id)!).saldos);
    }, timeout: const Timeout(Duration(seconds: 30)));
  });
}

String _firma(List<Transferencia> pagos) =>
    pagos.map((p) => '${p.montoCentavos}:${p.deudorId}:${p.acreedorId}').join('|');

// ---------------------------------------------------------------------------
// Oráculo: copia literal de deudaMinima del commit 324331c (búsqueda exhaustiva).
// ---------------------------------------------------------------------------

List<Transferencia> _deudaMinimaOriginal(Map<String, int> saldos) {
  final deudores = <String, int>{};
  final acreedores = <String, int>{};
  for (final entrada in saldos.entries) {
    if (entrada.value < 0) {
      deudores[entrada.key] = -entrada.value;
    } else if (entrada.value > 0) {
      acreedores[entrada.key] = entrada.value;
    }
  }
  if (deudores.isEmpty || acreedores.isEmpty) return const [];

  List<Transferencia>? mejor;

  void buscar(List<Transferencia> camino) {
    final deudorId = _primeroConMonto(deudores);
    if (deudorId == null) {
      if (mejor == null || _esPreferible(camino, mejor!)) {
        mejor = List<Transferencia>.of(camino);
      }
      return;
    }
    if (mejor != null && camino.length >= mejor!.length) return;

    final acreedorIds = acreedores.keys.where((id) => (acreedores[id] ?? 0) > 0).toList()..sort();
    for (final acreedorId in acreedorIds) {
      final deuda = deudores[deudorId]!;
      final credito = acreedores[acreedorId]!;
      final pago = deuda < credito ? deuda : credito;
      _aplicar(deudores, deudorId, deuda - pago);
      _aplicar(acreedores, acreedorId, credito - pago);
      camino.add(Transferencia(deudorId: deudorId, acreedorId: acreedorId, montoCentavos: pago));
      buscar(camino);
      camino.removeLast();
      _aplicar(deudores, deudorId, deuda);
      _aplicar(acreedores, acreedorId, credito);
    }
  }

  buscar([]);
  return _ordenar(mejor ?? const <Transferencia>[]);
}

void _aplicar(Map<String, int> montos, String id, int valor) {
  if (valor == 0) {
    montos.remove(id);
  } else {
    montos[id] = valor;
  }
}

String? _primeroConMonto(Map<String, int> montos) {
  String? elegido;
  for (final id in montos.keys) {
    if ((montos[id] ?? 0) <= 0) continue;
    if (elegido == null || id.compareTo(elegido) < 0) elegido = id;
  }
  return elegido;
}

bool _esPreferible(List<Transferencia> candidata, List<Transferencia> actual) {
  if (candidata.length != actual.length) return candidata.length < actual.length;
  final porPagador = _pagadorDelMenor(candidata).compareTo(_pagadorDelMenor(actual));
  if (porPagador != 0) return porPagador < 0;
  return _firma(_ordenar(candidata)).compareTo(_firma(_ordenar(actual))) < 0;
}

String _pagadorDelMenor(List<Transferencia> lista) {
  var mejor = lista.first;
  for (final pago in lista.skip(1)) {
    final esMenor = pago.montoCentavos < mejor.montoCentavos;
    final empataYVaAntes = pago.montoCentavos == mejor.montoCentavos && pago.deudorId.compareTo(mejor.deudorId) < 0;
    if (esMenor || empataYVaAntes) mejor = pago;
  }
  return mejor.deudorId;
}

List<Transferencia> _ordenar(List<Transferencia> lista) {
  return List<Transferencia>.of(lista)
    ..sort((a, b) {
      final porMonto = b.montoCentavos.compareTo(a.montoCentavos);
      if (porMonto != 0) return porMonto;
      final porDeudor = a.deudorId.compareTo(b.deudorId);
      if (porDeudor != 0) return porDeudor;
      return a.acreedorId.compareTo(b.acreedorId);
    });
}
