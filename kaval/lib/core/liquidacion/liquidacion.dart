import '../../models/aporte_efectivo.dart';
import '../../models/evento.dart';
import '../../models/gasto.dart';
import '../../models/transferencia.dart';

/// Saldos, pagos mínimos y devolución del efectivo que sobró.
class ResultadoLiquidacion {
  const ResultadoLiquidacion({
    required this.saldos,
    required this.parte,
    required this.transferencias,
    required this.totalGastos,
    required this.reunido,
    required this.gastadoEfectivo,
    required this.sobrante,
    required this.devolucion,
  });

  /// Positivo: a esa persona le deben. Negativo: esa persona debe.
  final Map<String, int> saldos;

  /// Lo que le corresponde pagar, sin restar lo que ya puso.
  final Map<String, int> parte;
  final List<Transferencia> transferencias;
  final int totalGastos;
  final int reunido;
  final int gastadoEfectivo;
  final int sobrante;

  /// Efectivo que se le regresa a quien aportó, en proporción a su aporte.
  final Map<String, int> devolucion;

  int saldoDe(String id) => saldos[id] ?? 0;

  int parteDe(String id) => parte[id] ?? 0;
}

/// Reparte [monto] en partes enteras. Los centavos que sobran se dan de uno
/// en uno a los primeros de la lista: el orden del evento es la regla fija.
Map<String, int> repartirCentavos(int monto, List<String> participantes) {
  if (participantes.isEmpty || monto == 0) {
    return {for (final id in participantes) id: 0};
  }
  final base = monto ~/ participantes.length;
  var resto = monto % participantes.length;
  final partes = <String, int>{};
  for (final id in participantes) {
    final extra = resto > 0 ? 1 : 0;
    if (resto > 0) resto--;
    partes[id] = base + extra;
  }
  return partes;
}

/// Reparte [monto] según [pesos] sin perder centavos.
/// Cada quien recibe el piso de su proporción y los centavos que faltan
/// van a los restos más grandes. Si empatan, gana el id alfabético.
Map<String, int> proporcional(int monto, Map<String, int> pesos) {
  final activos = <String, int>{};
  for (final entrada in pesos.entries) {
    if (entrada.value > 0) activos[entrada.key] = entrada.value;
  }
  if (activos.isEmpty || monto == 0) {
    return {for (final id in pesos.keys) id: 0};
  }
  final total = activos.values.fold(0, (suma, peso) => suma + peso);
  final asignado = <String, int>{};
  final restos = <String, int>{};
  var usado = 0;
  for (final entrada in activos.entries) {
    final producto = monto * entrada.value;
    asignado[entrada.key] = producto ~/ total;
    restos[entrada.key] = producto % total;
    usado += asignado[entrada.key]!;
  }
  var faltan = monto - usado;
  final orden = activos.keys.toList()
    ..sort((a, b) {
      final porResto = restos[b]!.compareTo(restos[a]!);
      if (porResto != 0) return porResto;
      return a.compareTo(b);
    });
  for (final id in orden) {
    if (faltan == 0) break;
    asignado[id] = asignado[id]! + 1;
    faltan--;
  }
  for (final id in pesos.keys) {
    asignado.putIfAbsent(id, () => 0);
  }
  return asignado;
}

ResultadoLiquidacion calcularLiquidacion(Evento evento) {
  final saldos = {for (final persona in evento.integrantes) persona.id: 0};
  final parte = {for (final persona in evento.integrantes) persona.id: 0};
  var totalGastos = 0;
  var gastadoEfectivo = 0;

  for (final gasto in evento.gastos) {
    totalGastos += gasto.montoCentavos;
    final partes = repartirCentavos(gasto.montoCentavos, gasto.participanteIds);
    for (final entrada in partes.entries) {
      saldos[entrada.key] = (saldos[entrada.key] ?? 0) - entrada.value;
      parte[entrada.key] = (parte[entrada.key] ?? 0) + entrada.value;
    }
    if (gasto.metodo == MetodoPago.efectivoGrupo) {
      gastadoEfectivo += gasto.montoCentavos;
    } else if (gasto.pagadorId != null) {
      // Quien pagó de su bolsillo recupera el monto completo.
      saldos[gasto.pagadorId!] =
          (saldos[gasto.pagadorId!] ?? 0) + gasto.montoCentavos;
    }
  }

  final pesos = <String, int>{};
  for (final aporte in evento.aportes) {
    pesos[aporte.integranteId] =
        (pesos[aporte.integranteId] ?? 0) + aporte.montoCentavos;
  }
  final reunido = pesos.values.fold(0, (suma, monto) => suma + monto);

  // Lo gastado del fondo se acredita a quien aportó, en proporción.
  final credito = proporcional(gastadoEfectivo, pesos);
  for (final entrada in credito.entries) {
    saldos[entrada.key] = (saldos[entrada.key] ?? 0) + entrada.value;
  }

  final sobrante = reunido - gastadoEfectivo;
  final devolucion = proporcional(sobrante < 0 ? 0 : sobrante, pesos);

  return ResultadoLiquidacion(
    saldos: saldos,
    parte: parte,
    transferencias: deudaMinima(saldos),
    totalGastos: totalGastos,
    reunido: reunido,
    gastadoEfectivo: gastadoEfectivo,
    sobrante: sobrante < 0 ? 0 : sobrante,
    devolucion: devolucion,
  );
}

/// Arma la lista más corta de pagos que deja todos los saldos en cero.
///
/// Con grupos de viaje el número de personas es pequeño, así que se prueban
/// las combinaciones. Si hay varias listas igual de cortas, se queda la que
/// hace que el pago más chico lo haga el deudor que va primero en el alfabeto.
/// Así el resultado no cambia entre corridas. En El Tunco eso elige a Ana
/// para cubrir los $2.40 de Luis y deja los otros pagos enteros hacia Sofi.
List<Transferencia> deudaMinima(Map<String, int> saldos) {
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

    final acreedorIds = acreedores.keys.where((id) => (acreedores[id] ?? 0) > 0).toList()
      ..sort();
    for (final acreedorId in acreedorIds) {
      final deuda = deudores[deudorId]!;
      final credito = acreedores[acreedorId]!;
      final pago = deuda < credito ? deuda : credito;

      _aplicar(deudores, deudorId, deuda - pago);
      _aplicar(acreedores, acreedorId, credito - pago);
      camino.add(
        Transferencia(
          deudorId: deudorId,
          acreedorId: acreedorId,
          montoCentavos: pago,
        ),
      );
      buscar(camino);
      camino.removeLast();
      _aplicar(deudores, deudorId, deuda);
      _aplicar(acreedores, acreedorId, credito);
    }
  }

  buscar([]);
  final resultado = mejor ?? const <Transferencia>[];
  return _ordenarParaMostrar(resultado);
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
  if (candidata.length != actual.length) {
    return candidata.length < actual.length;
  }
  final porPagador = _pagadorDelMenor(candidata).compareTo(_pagadorDelMenor(actual));
  if (porPagador != 0) return porPagador < 0;
  return _firma(candidata).compareTo(_firma(actual)) < 0;
}

String _pagadorDelMenor(List<Transferencia> lista) {
  var mejor = lista.first;
  for (final pago in lista.skip(1)) {
    final esMenor = pago.montoCentavos < mejor.montoCentavos;
    final empataYVaAntes = pago.montoCentavos == mejor.montoCentavos &&
        pago.deudorId.compareTo(mejor.deudorId) < 0;
    if (esMenor || empataYVaAntes) mejor = pago;
  }
  return mejor.deudorId;
}

String _firma(List<Transferencia> lista) {
  final copia = _ordenarParaMostrar(lista);
  return copia
      .map((pago) => '${pago.montoCentavos}:${pago.deudorId}:${pago.acreedorId}')
      .join('|');
}

List<Transferencia> _ordenarParaMostrar(List<Transferencia> lista) {
  final copia = List<Transferencia>.of(lista)
    ..sort((a, b) {
      final porMonto = b.montoCentavos.compareTo(a.montoCentavos);
      if (porMonto != 0) return porMonto;
      final porDeudor = a.deudorId.compareTo(b.deudorId);
      if (porDeudor != 0) return porDeudor;
      return a.acreedorId.compareTo(b.acreedorId);
    });
  return copia;
}

/// Suma de aportes de una persona. Útil para el porcentaje del fondo.
int totalAportado(List<AporteEfectivo> aportes, String integranteId) {
  var suma = 0;
  for (final aporte in aportes) {
    if (aporte.integranteId == integranteId) suma += aporte.montoCentavos;
  }
  return suma;
}
