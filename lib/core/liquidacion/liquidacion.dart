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
    this.faltanteEfectivo = 0,
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

  /// Lo gastado del fondo que nadie aportó. No entra en los saldos entre personas.
  final int faltanteEfectivo;

  int saldoDe(String id) => saldos[id] ?? 0;

  int parteDe(String id) => parte[id] ?? 0;

  ResultadoLiquidacion copyWith({List<Transferencia>? transferencias}) {
    return ResultadoLiquidacion(
      saldos: saldos,
      parte: parte,
      transferencias: transferencias ?? this.transferencias,
      totalGastos: totalGastos,
      reunido: reunido,
      gastadoEfectivo: gastadoEfectivo,
      sobrante: sobrante,
      devolucion: devolucion,
      faltanteEfectivo: faltanteEfectivo,
    );
  }
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

/// Centavos de propina o servicio. El recorte es entero, así no depende del redondeo de double.
int propinaDe(int subtotal, int porcentaje) {
  if (subtotal <= 0 || porcentaje <= 0) return 0;
  final tope = porcentaje > 100 ? 100 : porcentaje;
  return (subtotal * tope) ~/ 100;
}

/// Parte de cada persona según el modo del gasto.
///
/// Iguales usa el orden de [Gasto.participanteIds]. Montos usa las cuotas
/// guardadas. Consumo reparte cada ítem y luego propina y extras en proporción.
Map<String, int> partesDeGasto(Gasto gasto) {
  if (gasto.modoDivision == ModoDivision.consumo && gasto.items.isNotEmpty) {
    final calculadas = partesConsumo(
      items: gasto.items,
      propinaPorcentaje: gasto.propinaPorcentaje,
      extrasCentavos: gasto.extrasCentavos,
    );
    if (calculadas.isNotEmpty) return calculadas;
  }
  final cuotas = gasto.partes;
  if (cuotas.isNotEmpty) {
    final suma = sumaPartes(cuotas);
    final usarCuotas = gasto.modoDivision != ModoDivision.iguales || suma == gasto.montoCentavos;
    if (usarCuotas && suma > 0) return Map<String, int>.of(cuotas);
  }
  return repartirCentavos(gasto.montoCentavos, gasto.participanteIds);
}

/// Reparte ítems, propina y extras. El residuo de cada ítem sigue el orden
/// de sus asignados; propina y extras usan el residuo proporcional.
Map<String, int> partesConsumo({
  required List<ItemGasto> items,
  required int propinaPorcentaje,
  required int extrasCentavos,
}) {
  final subtotales = <String, int>{};
  for (final item in items) {
    if (item.participanteIds.isEmpty || item.cantidad <= 0 || item.precioCentavos <= 0) {
      continue;
    }
    final partes = repartirCentavos(item.totalCentavos, item.participanteIds);
    for (final entrada in partes.entries) {
      subtotales[entrada.key] = (subtotales[entrada.key] ?? 0) + entrada.value;
    }
  }
  if (subtotales.isEmpty) return const {};
  final subtotal = subtotales.values.fold(0, (suma, monto) => suma + monto);
  final porPropina = proporcional(propinaDe(subtotal, propinaPorcentaje), subtotales);
  final porExtras = proporcional(extrasCentavos < 0 ? 0 : extrasCentavos, subtotales);
  return {
    for (final id in subtotales.keys)
      id: subtotales[id]! + (porPropina[id] ?? 0) + (porExtras[id] ?? 0),
  };
}

int sumaPartes(Map<String, int> partes) {
  return partes.values.fold(0, (suma, monto) => suma + monto);
}

bool saldosEnCero(Map<String, int> saldos) {
  for (final monto in saldos.values) {
    if (monto != 0) return false;
  }
  return true;
}

/// Saldos y partes en centavos, sin armar todavía las transferencias.
///
/// Un pago personal resta la cuota real y le suma el total a quien pagó.
/// El efectivo del grupo solo genera deuda entre personas por la parte que
/// el fondo sí cubre. Lo que falta en el fondo se anota aparte y no descuadra
/// los saldos: tienen que sumar cero.
ResultadoLiquidacion calcularSaldos(Evento evento) {
  final saldos = {for (final persona in evento.integrantes) persona.id: 0};
  final parte = {for (final persona in evento.integrantes) persona.id: 0};
  final consumoFondo = <String, int>{};
  var totalGastos = 0;
  var gastadoEfectivo = 0;

  for (final gasto in evento.gastos) {
    totalGastos += gasto.montoCentavos;
    var partes = _partesCanonicas(evento, partesDeGasto(gasto));
    final suma = sumaPartes(partes);
    if (gasto.montoCentavos > 0 && suma > 0 && suma != gasto.montoCentavos) {
      partes = proporcional(gasto.montoCentavos, partes);
    }
    final cargado = sumaPartes(partes);
    for (final entrada in partes.entries) {
      saldos[entrada.key] = (saldos[entrada.key] ?? 0) - entrada.value;
      parte[entrada.key] = (parte[entrada.key] ?? 0) + entrada.value;
    }
    final delFondo = gasto.metodo == MetodoPago.efectivoGrupo || gasto.pagadorId == null;
    if (delFondo) {
      final movido = cargado > 0 ? cargado : gasto.montoCentavos;
      gastadoEfectivo += movido;
      for (final entrada in partes.entries) {
        consumoFondo[entrada.key] = (consumoFondo[entrada.key] ?? 0) + entrada.value;
      }
    } else {
      final pagador = _idCanonico(evento, gasto.pagadorId!);
      final credito = cargado > 0 ? cargado : gasto.montoCentavos;
      saldos[pagador] = (saldos[pagador] ?? 0) + credito;
    }
  }

  final pesos = <String, int>{};
  for (final aporte in evento.aportes) {
    final id = _idCanonico(evento, aporte.integranteId);
    pesos[id] = (pesos[id] ?? 0) + aporte.montoCentavos;
  }
  final reunido = pesos.values.fold(0, (suma, monto) => suma + monto);
  final cubierto = reunido < gastadoEfectivo ? reunido : gastadoEfectivo;
  final faltante = gastadoEfectivo - cubierto;

  final credito = proporcional(cubierto, pesos);
  for (final entrada in credito.entries) {
    saldos[entrada.key] = (saldos[entrada.key] ?? 0) + entrada.value;
  }
  if (faltante > 0 && consumoFondo.isNotEmpty) {
    final rebate = proporcional(faltante, consumoFondo);
    for (final entrada in rebate.entries) {
      saldos[entrada.key] = (saldos[entrada.key] ?? 0) + entrada.value;
    }
  }

  final sumaSaldos = saldos.values.fold(0, (suma, monto) => suma + monto);
  assert(sumaSaldos == 0, 'Los saldos deben sumar 0 y suman $sumaSaldos');

  final sobrante = reunido - gastadoEfectivo;
  return ResultadoLiquidacion(
    saldos: saldos,
    parte: parte,
    transferencias: const [],
    totalGastos: totalGastos,
    reunido: reunido,
    gastadoEfectivo: gastadoEfectivo,
    sobrante: sobrante < 0 ? 0 : sobrante,
    devolucion: proporcional(sobrante < 0 ? 0 : sobrante, pesos),
    faltanteEfectivo: faltante,
  );
}

/// Transferencias mínimas a partir de los saldos de [calcularSaldos].
List<Transferencia> liquidar(Map<String, int> saldos) {
  final exacta = deudaMinima(saldos);
  if (exacta.isNotEmpty || saldosEnCero(saldos)) return exacta;
  return _pagosPosibles(saldos);
}

ResultadoLiquidacion calcularLiquidacion(Evento evento) {
  final cuentas = calcularSaldos(evento);
  return cuentas.copyWith(transferencias: liquidar(cuentas.saldos));
}

String _idCanonico(Evento evento, String id) {
  for (final persona in evento.integrantes) {
    if (persona.id == id) return persona.id;
  }
  final busca = id.trim().toLowerCase();
  final porNombre = [
    for (final persona in evento.integrantes)
      if (persona.nombre.trim().toLowerCase() == busca) persona.id,
  ];
  if (porNombre.length == 1) return porNombre.single;
  final porPrimero = [
    for (final persona in evento.integrantes)
      if (persona.nombre.trim().toLowerCase().split(RegExp(r'\s+')).first == busca) persona.id,
  ];
  if (porPrimero.length == 1) return porPrimero.single;
  return id;
}

Map<String, int> _partesCanonicas(Evento evento, Map<String, int> partes) {
  final salida = <String, int>{};
  for (final entrada in partes.entries) {
    final id = _idCanonico(evento, entrada.key);
    salida[id] = (salida[id] ?? 0) + entrada.value;
  }
  return salida;
}

List<Transferencia> _pagosPosibles(Map<String, int> saldos) {
  final deudores = <String, int>{};
  final acreedores = <String, int>{};
  for (final entrada in saldos.entries) {
    if (entrada.value < 0) deudores[entrada.key] = -entrada.value;
    if (entrada.value > 0) acreedores[entrada.key] = entrada.value;
  }
  final pagos = <Transferencia>[];
  final ordenDeudores = deudores.keys.toList()..sort();
  final ordenAcreedores = acreedores.keys.toList()..sort();
  for (final deudor in ordenDeudores) {
    for (final acreedor in ordenAcreedores) {
      final deuda = deudores[deudor] ?? 0;
      final credito = acreedores[acreedor] ?? 0;
      if (deuda == 0 || credito == 0) continue;
      final pago = deuda < credito ? deuda : credito;
      deudores[deudor] = deuda - pago;
      acreedores[acreedor] = credito - pago;
      pagos.add(Transferencia(deudorId: deudor, acreedorId: acreedor, montoCentavos: pago));
    }
  }
  return _ordenarParaMostrar(pagos);
}

/// Arma la lista más corta de pagos que deja todos los saldos en cero.
///
/// Con grupos de viaje el número de personas es pequeño, así que se prueban
/// las combinaciones. Si hay varias listas igual de cortas, se queda la que
/// hace que el pago más chico lo haga el deudor que va primero en el alfabeto.
/// Así el resultado no cambia entre corridas.
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
