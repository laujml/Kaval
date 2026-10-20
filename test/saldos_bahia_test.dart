import 'package:flutter_test/flutter_test.dart';
import 'package:kaval/core/liquidacion/liquidacion.dart';
import 'package:kaval/models/aporte_efectivo.dart';
import 'package:kaval/models/evento.dart';
import 'package:kaval/models/gasto.dart';
import 'package:kaval/models/integrante.dart';

void main() {
  test('Bahía Dorada: el hotel se cobra entre personas y el fondo no descuadra', () {
    final resultado = calcularLiquidacion(_bahia());
    final suma = resultado.saldos.values.fold(0, (total, saldo) => total + saldo);

    expect(suma, 0);
    expect(resultado.saldoDe('mer'), -5000);
    expect(resultado.saldoDe('sheyla'), 15000);
    expect(resultado.saldoDe('jorge'), -5000);
    expect(resultado.saldoDe('luna'), -5000);
    expect(resultado.parteDe('mer'), 9225);
    expect(resultado.gastadoEfectivo, 2500);
    expect(resultado.faltanteEfectivo, 2500);
    expect(resultado.transferencias, hasLength(3));
    expect(
      resultado.transferencias.map((pago) => (pago.deudorId, pago.acreedorId, pago.montoCentavos)).toList(),
      [
        ('jorge', 'sheyla', 5000),
        ('luna', 'sheyla', 5000),
        ('mer', 'sheyla', 5000),
      ],
    );
    expect(saldosEnCero(resultado.saldos), isFalse);
  });

  test('partes iguales usan el reparto guardado y un gasto viejo sigue en iguales', () {
    final viejo = Gasto.fromMap('viejo', {
      'concepto': 'Taxi',
      'montoCentavos': 1000,
      'participanteIds': ['mer', 'sheyla'],
      'pagadorId': 'mer',
      'categoria': 'transporte',
      'metodo': 'tarjeta',
      'fecha': 0,
    });
    expect(viejo.modoDivision, ModoDivision.iguales);
    final resultado = calcularLiquidacion(_evento([viejo]));
    expect(resultado.saldoDe('mer'), 500);
    expect(resultado.saldoDe('sheyla'), -500);
    expect(resultado.saldos.values.fold(0, (total, saldo) => total + saldo), 0);
    expect(resultado.transferencias.single.montoCentavos, 500);
  });

  test('montos exactos liquidan las cuotas, no un reparto entre todos', () {
    final gasto = Gasto(
      id: 'cena',
      concepto: 'Cena',
      montoCentavos: 1000,
      pagadorId: 'mer',
      participanteIds: const ['mer', 'sheyla', 'jorge', 'luna'],
      categoria: CategoriaGasto.comida,
      metodo: MetodoPago.tarjeta,
      fecha: DateTime(2026, 10, 20),
      modoDivision: ModoDivision.montos,
      partes: const {'mer': 100, 'sheyla': 700, 'jorge': 200, 'luna': 0},
    );
    final resultado = calcularLiquidacion(_evento([gasto]));
    expect(resultado.parteDe('sheyla'), 700);
    expect(resultado.saldoDe('mer'), 900);
    expect(resultado.saldoDe('sheyla'), -700);
    expect(resultado.saldoDe('jorge'), -200);
    expect(resultado.saldoDe('luna'), 0);
    expect(resultado.saldos.values.fold(0, (total, saldo) => total + saldo), 0);
  });

  test('los ítems se dividen entre quien los consumió', () {
    final gasto = Gasto(
      id: 'cuenta',
      concepto: 'Cuenta',
      montoCentavos: 1300,
      pagadorId: 'sheyla',
      participanteIds: const ['mer', 'sheyla', 'jorge'],
      categoria: CategoriaGasto.comida,
      metodo: MetodoPago.tarjeta,
      fecha: DateTime(2026, 10, 20),
      modoDivision: ModoDivision.consumo,
      items: const [
        ItemGasto(
          id: 'pizza',
          nombre: 'Pizza',
          precioCentavos: 1000,
          cantidad: 1,
          participanteIds: ['mer', 'sheyla'],
        ),
        ItemGasto(
          id: 'soda',
          nombre: 'Soda',
          precioCentavos: 300,
          cantidad: 1,
          participanteIds: ['jorge'],
        ),
      ],
    );
    final resultado = calcularLiquidacion(_evento([gasto]));
    expect(resultado.parteDe('mer'), 500);
    expect(resultado.parteDe('jorge'), 300);
    expect(resultado.saldoDe('sheyla'), 800);
    expect(resultado.saldoDe('mer'), -500);
    expect(resultado.saldos.values.fold(0, (total, saldo) => total + saldo), 0);
  });

  test('el efectivo del grupo sin aportes no crea deudas y el cubierto sí', () {
    final fondo = Gasto(
      id: 'fondo',
      concepto: 'Agua',
      montoCentavos: 1000,
      participanteIds: const ['mer', 'sheyla'],
      categoria: CategoriaGasto.comida,
      metodo: MetodoPago.efectivoGrupo,
      fecha: DateTime(2026, 10, 20),
    );
    final vacio = calcularLiquidacion(_evento([fondo]));
    expect(vacio.saldoDe('mer'), 0);
    expect(vacio.saldoDe('sheyla'), 0);
    expect(vacio.parteDe('mer'), 500);
    expect(vacio.faltanteEfectivo, 1000);
    expect(vacio.transferencias, isEmpty);
    expect(saldosEnCero(vacio.saldos), isTrue);

    final cubierto = calcularLiquidacion(
      _evento(
        [fondo],
        aportes: [
          AporteEfectivo(
            id: 'a',
            integranteId: 'sheyla',
            montoCentavos: 1000,
            descripcion: 'fondo',
            fecha: DateTime(2026, 10, 20),
          ),
        ],
      ),
    );
    expect(cubierto.faltanteEfectivo, 0);
    expect(cubierto.saldoDe('mer'), -500);
    expect(cubierto.saldoDe('sheyla'), 500);
    expect(cubierto.transferencias.single.deudorId, 'mer');
    expect(cubierto.transferencias.single.acreedorId, 'sheyla');
  });

  test('un pagador guardado por nombre se acredita a la persona del evento', () {
    final gasto = Gasto(
      id: 'hotel',
      concepto: 'Hotel',
      montoCentavos: 2000,
      pagadorId: 'Sheyla',
      participanteIds: const ['mer', 'sheyla'],
      categoria: CategoriaGasto.hospedaje,
      metodo: MetodoPago.tarjeta,
      fecha: DateTime(2026, 10, 20),
    );
    final resultado = calcularLiquidacion(_evento([gasto]));
    expect(resultado.saldoDe('sheyla'), 1000);
    expect(resultado.saldoDe('mer'), -1000);
    expect(resultado.saldos.values.fold(0, (total, saldo) => total + saldo), 0);
  });
}

Evento _bahia() {
  return _evento([
    Gasto(
      id: 'hotel',
      concepto: 'Hotel inn',
      montoCentavos: 20000,
      pagadorId: 'sheyla',
      participanteIds: const ['mer', 'sheyla', 'jorge', 'luna'],
      categoria: CategoriaGasto.hospedaje,
      metodo: MetodoPago.tarjeta,
      fecha: DateTime(2026, 10, 18),
      modoDivision: ModoDivision.iguales,
      partes: const {'mer': 5000, 'sheyla': 5000, 'jorge': 5000, 'luna': 5000},
    ),
    Gasto(
      id: 'cena',
      concepto: 'Cena',
      montoCentavos: 3600,
      pagadorId: 'mer',
      participanteIds: const ['mer'],
      categoria: CategoriaGasto.comida,
      metodo: MetodoPago.tarjeta,
      fecha: DateTime(2026, 10, 18),
      modoDivision: ModoDivision.iguales,
      partes: const {'mer': 3600},
    ),
    Gasto(
      id: 'wendy',
      concepto: "En wendy's",
      montoCentavos: 2500,
      participanteIds: const ['mer', 'sheyla', 'jorge', 'luna'],
      categoria: CategoriaGasto.comida,
      metodo: MetodoPago.efectivoGrupo,
      fecha: DateTime(2026, 10, 18),
      modoDivision: ModoDivision.iguales,
      partes: const {'mer': 625, 'sheyla': 625, 'jorge': 625, 'luna': 625},
    ),
  ]);
}

Evento _evento(List<Gasto> gastos, {List<AporteEfectivo> aportes = const []}) {
  return Evento(
    id: 'bahia',
    nombre: 'Bahía Dorada',
    lugar: '',
    inicio: DateTime(2026, 10, 18),
    fin: DateTime(2026, 10, 20),
    portada: PortadaEvento.playa,
    codigo: 'BAHIA-1A',
    custodioId: 'mer',
    integrantes: const [
      Integrante(id: 'mer', nombre: 'Mer', colorFondo: 0, colorInicial: 0),
      Integrante(id: 'sheyla', nombre: 'Sheyla', colorFondo: 0, colorInicial: 0),
      Integrante(id: 'jorge', nombre: 'Jorge', colorFondo: 0, colorInicial: 0),
      Integrante(id: 'luna', nombre: 'Luna', colorFondo: 0, colorInicial: 0),
    ],
    gastos: gastos,
    aportes: aportes,
  );
}
