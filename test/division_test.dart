import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaval/core/liquidacion/liquidacion.dart';
import 'package:kaval/data/repositorios/repositorio_gastos.dart';
import 'package:kaval/models/evento.dart';
import 'package:kaval/models/gasto.dart';
import 'package:kaval/models/integrante.dart';

void main() {
  final fecha = DateTime(2026, 10, 20);

  test('partes iguales dan el centavo sobrante al primero, siempre igual', () {
    final gasto = Gasto(
      id: 'g',
      concepto: 'Cena',
      montoCentavos: 1000,
      participanteIds: const ['ana', 'sheyla', 'jorge'],
      categoria: CategoriaGasto.comida,
      metodo: MetodoPago.tarjeta,
      fecha: fecha,
      pagadorId: 'ana',
    );
    final partes = partesDeGasto(gasto);
    expect(partes, {'ana': 334, 'sheyla': 333, 'jorge': 333});
    expect(partesDeGasto(gasto), partes);

    final cuentas = calcularLiquidacion(_evento([gasto]));
    expect(cuentas.parteDe('ana'), 334);
    expect(cuentas.parteDe('sheyla'), 333);
    expect(cuentas.saldoDe('ana'), 666);
    expect(cuentas.saldoDe('sheyla'), -333);
    expect(cuentas.saldoDe('jorge'), -333);
  });

  test('montos exactos liquidan con las cuotas guardadas', () {
    final gasto = Gasto(
      id: 'g',
      concepto: 'Cena',
      montoCentavos: 4000,
      participanteIds: const ['ana', 'sheyla', 'jorge'],
      categoria: CategoriaGasto.comida,
      metodo: MetodoPago.tarjeta,
      fecha: fecha,
      pagadorId: 'ana',
      modoDivision: ModoDivision.montos,
      partes: const {'ana': 1000, 'sheyla': 1500, 'jorge': 1500},
    );
    expect(sumaPartes(partesDeGasto(gasto)), 4000);
    final cuentas = calcularLiquidacion(_evento([gasto]));
    expect(cuentas.parteDe('sheyla'), 1500);
    expect(cuentas.parteDe('jorge'), 1500);
    expect(cuentas.saldoDe('ana'), 3000);
    expect(cuentas.saldoDe('sheyla'), -1500);
    expect(cuentas.transferencias, hasLength(2));
  });

  test('el consumo reparte cada ítem y la propina en proporción', () {
    final gasto = Gasto(
      id: 'g',
      concepto: 'Cena',
      montoCentavos: 1430,
      participanteIds: const ['ana', 'sheyla', 'jorge'],
      categoria: CategoriaGasto.comida,
      metodo: MetodoPago.tarjeta,
      fecha: fecha,
      pagadorId: 'sheyla',
      modoDivision: ModoDivision.consumo,
      propinaPorcentaje: 10,
      items: const [
        ItemGasto(
          id: 'pizza',
          nombre: 'Pizza',
          precioCentavos: 1000,
          cantidad: 1,
          participanteIds: ['ana', 'sheyla'],
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
    final partes = partesDeGasto(gasto);
    expect(partes, {'ana': 550, 'sheyla': 550, 'jorge': 330});
    expect(sumaPartes(partes), 1430);

    final cuentas = calcularLiquidacion(_evento([gasto]));
    expect(cuentas.parteDe('jorge'), 330);
    expect(cuentas.saldoDe('sheyla'), 1430 - 550);
    expect(cuentas.saldoDe('ana'), -550);
  });

  test('un ítem entre tres deja el residuo en el primer asignado', () {
    final partes = partesConsumo(
      items: const [
        ItemGasto(
          id: 'cuenta',
          nombre: 'Cuenta',
          precioCentavos: 1000,
          cantidad: 1,
          participanteIds: ['ana', 'sheyla', 'jorge'],
        ),
      ],
      propinaPorcentaje: 0,
      extrasCentavos: 0,
    );
    expect(partes, {'ana': 334, 'sheyla': 333, 'jorge': 333});
    expect(
      partesConsumo(
        items: const [
          ItemGasto(
            id: 'cuenta',
            nombre: 'Cuenta',
            precioCentavos: 1000,
            cantidad: 1,
            participanteIds: ['ana', 'sheyla'],
          ),
        ],
        propinaPorcentaje: 0,
        extrasCentavos: 100,
      ),
      {'ana': 550, 'sheyla': 550},
    );
    expect(partesConsumo(items: const [
      ItemGasto(
        id: 'cuenta',
        nombre: 'Cuenta',
        precioCentavos: 1000,
        cantidad: 1,
        participanteIds: ['ana', 'sheyla', 'jorge'],
      ),
    ], propinaPorcentaje: 0, extrasCentavos: 0), partes);
  });

  test('un gasto viejo sin splitMode se lee como partes iguales', () async {
    final db = FakeFirebaseFirestore();
    await db.collection('eventos').doc('e').set({'nombre': 'Salida'});
    await db.collection('eventos').doc('e').collection('gastos').doc('viejo').set({
      'concepto': 'Taxi',
      'montoCentavos': 1000,
      'participanteIds': ['ana', 'sheyla'],
      'categoria': 'transporte',
      'metodo': 'tarjeta',
      'fecha': 0,
      'pagadorId': 'ana',
    });
    final repo = RepositorioGastos(db);
    final viejo = (await repo.listar('e')).single;
    expect(viejo.modoDivision, ModoDivision.iguales);
    expect(partesDeGasto(viejo), {'ana': 500, 'sheyla': 500});

    final nuevo = Gasto(
      id: 'nuevo',
      concepto: 'Cena',
      montoCentavos: 4000,
      participanteIds: const ['ana', 'sheyla'],
      categoria: CategoriaGasto.comida,
      metodo: MetodoPago.efectivoGrupo,
      fecha: fecha,
      modoDivision: ModoDivision.montos,
      partes: const {'ana': 2500, 'sheyla': 1500},
      items: const [
        ItemGasto(id: 'i', nombre: 'Postre', precioCentavos: 400, cantidad: 1, participanteIds: ['ana']),
      ],
      propinaPorcentaje: 10,
      extrasCentavos: 50,
    );
    await repo.guardar('e', nuevo);
    final leido = (await repo.listar('e')).firstWhere((gasto) => gasto.id == 'nuevo');
    expect(leido.modoDivision, ModoDivision.montos);
    expect(leido.partes['sheyla'], 1500);
    expect(leido.items.single.nombre, 'Postre');
    expect(leido.propinaPorcentaje, 10);
    expect(leido.extrasCentavos, 50);
    expect(leido.pagadorId, isNull);
  });
}

Evento _evento(List<Gasto> gastos) {
  return Evento(
    id: 'e',
    nombre: 'Salida',
    lugar: '',
    inicio: DateTime(2026, 10, 20),
    fin: DateTime(2026, 10, 21),
    portada: PortadaEvento.comida,
    codigo: 'SALIDA-1A',
    custodioId: 'ana',
    integrantes: const [
      Integrante(id: 'ana', nombre: 'Ana', colorFondo: 0, colorInicial: 0),
      Integrante(id: 'sheyla', nombre: 'Sheyla', colorFondo: 0, colorInicial: 0),
      Integrante(id: 'jorge', nombre: 'Jorge', colorFondo: 0, colorInicial: 0),
    ],
    gastos: gastos,
    aportes: const [],
  );
}
