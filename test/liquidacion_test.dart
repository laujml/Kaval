import 'package:flutter_test/flutter_test.dart';
import 'package:kaval/core/liquidacion/liquidacion.dart';
import 'fixtures/datos_ejemplo.dart';
import 'package:kaval/models/aporte_efectivo.dart';
import 'package:kaval/models/evento.dart';
import 'package:kaval/models/gasto.dart';
import 'package:kaval/models/integrante.dart';

void main() {
  test('Playa El Tunco cuadra con los saldos del mockup', () {
    final resultado = calcularLiquidacion(eventoPlayaTunco());

    expect(resultado.totalGastos, 20200);
    expect(resultado.saldos[idLaura], -1060);
    expect(resultado.saldos[idAna], -1360);
    expect(resultado.saldos[idLuis], 240);
    expect(resultado.saldos[idSofi], 8540);
    expect(resultado.saldos[idDiego], -3460);
    expect(resultado.saldos[idCarla], -2900);
    expect(resultado.parte[idLaura], 3460);
    expect(resultado.parte[idCarla], 2900);

    final suma = resultado.saldos.values.fold(0, (a, b) => a + b);
    expect(suma, 0);
  });

  test('la deuda mínima de El Tunco son las 5 transferencias del mockup', () {
    final pagos = calcularLiquidacion(eventoPlayaTunco()).transferencias;

    expect(pagos, hasLength(5));
    expect(pagos.map((p) => (p.deudorId, p.acreedorId, p.montoCentavos)).toList(), [
      (idDiego, idSofi, 3460),
      (idCarla, idSofi, 2900),
      (idAna, idSofi, 1120),
      (idLaura, idSofi, 1060),
      (idAna, idLuis, 240),
    ]);
  });

  test('el efectivo sobrante se devuelve 39 a Ana y 13 a Luis', () {
    final resultado = calcularLiquidacion(eventoPlayaTunco());

    expect(resultado.reunido, 8000);
    expect(resultado.gastadoEfectivo, 2800);
    expect(resultado.sobrante, 5200);
    expect(resultado.devolucion[idAna], 3900);
    expect(resultado.devolucion[idLuis], 1300);
    expect(
      resultado.devolucion.values.fold(0, (a, b) => a + b),
      resultado.sobrante,
    );
  });

  test('Ruta de las Flores le deja a Laura 15.25 a favor', () {
    final resultado = calcularLiquidacion(eventoRutaFlores());
    expect(resultado.totalGastos, 8600);
    expect(resultado.saldos[idLaura], 1525);
  });

  test('los centavos sobrantes de un reparto se dan en orden', () {
    final partes = repartirCentavos(100, ['a', 'b', 'c']);
    expect(partes, {'a': 34, 'b': 33, 'c': 33});
    expect(partes.values.fold(0, (a, b) => a + b), 100);
  });

  test('la proporción no pierde centavos y premia el resto mayor', () {
    final partes = proporcional(100, {'ana': 1, 'luis': 2});
    expect(partes['ana'], 33);
    expect(partes['luis'], 67);
    expect(partes.values.fold(0, (a, b) => a + b), 100);
  });

  test('un gasto simple genera una sola transferencia', () {
    final evento = Evento(
      id: 'cafe',
      nombre: 'Café',
      lugar: 'San Salvador',
      inicio: DateTime(2026, 10, 1),
      fin: DateTime(2026, 10, 1),
      portada: PortadaEvento.comida,
      codigo: 'CAFE',
      custodioId: idLaura,
      integrantes: const [
        Integrante(id: idLaura, nombre: 'Laura', colorFondo: 0, colorInicial: 0),
        Integrante(id: idAna, nombre: 'Ana', colorFondo: 0, colorInicial: 0),
      ],
      aportes: const <AporteEfectivo>[],
      gastos: [
        Gasto(
          id: 'g1',
          concepto: 'Café',
          montoCentavos: 1000,
          pagadorId: idLaura,
          participanteIds: const [idLaura, idAna],
          categoria: CategoriaGasto.comida,
          metodo: MetodoPago.tarjeta,
          fecha: DateTime(2026, 10, 1),
        ),
      ],
    );

    final resultado = calcularLiquidacion(evento);
    expect(resultado.saldos[idLaura], 500);
    expect(resultado.saldos[idAna], -500);
    expect(resultado.transferencias.single.deudorId, idAna);
    expect(resultado.transferencias.single.acreedorId, idLaura);
    expect(resultado.transferencias.single.montoCentavos, 500);
  });
}
