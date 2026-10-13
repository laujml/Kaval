import 'package:flutter/material.dart';

import '../core/liquidacion/liquidacion.dart';
import '../core/red/cliente_api.dart';
import '../data/datos_ejemplo.dart';
import '../models/aporte_efectivo.dart';
import '../models/evento.dart';
import '../models/gasto.dart';
import '../models/transferencia.dart';
import '../models/usuario.dart';

/// Estado de la materia: un ChangeNotifier que las pantallas escuchan.
class KavalState extends ChangeNotifier {
  KavalState()
      : usuario = usuarioDemo(),
        eventos = eventosIniciales(),
        borrador = borradorGasolina();

  Locale locale = const Locale('es');
  Usuario usuario;
  List<Evento> eventos;
  Gasto borrador;
  bool sincronizarNube = true;
  PortadaEvento? filtro;

  /// Se gasta en la siguiente llamada y vuelve a ninguno.
  FalloForzado falloForzado = FalloForzado.ninguno;

  /// Claves de transferencias marcadas como pagadas, por evento.
  final Set<String> _pagadas = {};

  String get idioma => locale.languageCode;

  void cambiarIdioma(Locale value) {
    if (locale == value) return;
    locale = value;
    notifyListeners();
  }

  void cambiarFiltro(PortadaEvento? portada) {
    filtro = portada;
    notifyListeners();
  }

  void alternarSincronizacion(bool valor) {
    sincronizarNube = valor;
    notifyListeners();
  }

  void prepararFallo(FalloForzado fallo) {
    falloForzado = fallo;
    notifyListeners();
  }

  FalloForzado consumirFallo() {
    final actual = falloForzado;
    if (actual == FalloForzado.ninguno) return actual;
    falloForzado = FalloForzado.ninguno;
    notifyListeners();
    return actual;
  }

  Evento? buscar(String id) {
    for (final evento in eventos) {
      if (evento.id == id) return evento;
    }
    return null;
  }

  ResultadoLiquidacion? liquidacionDe(String id) {
    final evento = buscar(id);
    if (evento == null) return null;
    return calcularLiquidacion(evento);
  }

  List<Evento> get eventosFiltrados {
    final portada = filtro;
    if (portada == null) return eventos;
    return eventos.where((evento) => evento.portada == portada).toList();
  }

  int saldoEn(Evento evento) => calcularLiquidacion(evento).saldoDe(usuario.id);

  /// Suma de saldos a favor, en todos los viajes. En el inicio es $15.25.
  int get teDeben {
    var suma = 0;
    for (final evento in eventos) {
      final saldo = saldoEn(evento);
      if (saldo > 0) suma += saldo;
    }
    return suma;
  }

  /// Suma de lo que se debe, sin netearlo con lo que te deben.
  int get debes {
    var suma = 0;
    for (final evento in eventos) {
      final saldo = saldoEn(evento);
      if (saldo < 0) suma += -saldo;
    }
    return suma;
  }

  int get balanceGeneral => teDeben - debes;

  void entrar({required String nombre, required String correo, bool local = false}) {
    final limpio = nombre.trim().isEmpty ? usuario.nombre : nombre.trim();
    usuario = Usuario(
      id: usuario.id,
      nombre: limpio,
      correo: correo.trim().isEmpty ? usuario.correo : correo.trim(),
      local: local,
    );
    notifyListeners();
  }

  void crearEvento(Evento evento) {
    eventos = [evento, ...eventos];
    notifyListeners();
  }

  void agregarGasto(String eventoId, Gasto gasto) {
    _reemplazar(eventoId, (evento) {
      return evento.copyWith(gastos: [gasto, ...evento.gastos]);
    });
  }

  void actualizarGasto(String eventoId, Gasto gasto) {
    _reemplazar(eventoId, (evento) {
      return evento.copyWith(
        gastos: [
          for (final actual in evento.gastos)
            if (actual.id == gasto.id) gasto else actual,
        ],
      );
    });
  }

  void agregarAporte(String eventoId, AporteEfectivo aporte) {
    _reemplazar(eventoId, (evento) {
      return evento.copyWith(aportes: [...evento.aportes, aporte]);
    });
  }

  void confirmarBorrador(String eventoId) {
    final evento = buscar(eventoId);
    if (evento == null) return;
    final yaExiste = evento.gastos.any(
      (gasto) =>
          gasto.concepto == borrador.concepto &&
          gasto.montoCentavos == borrador.montoCentavos &&
          gasto.dictado,
    );
    if (!yaExiste) {
      agregarGasto(
        eventoId,
        Gasto(
          id: 'voz-${DateTime.now().microsecondsSinceEpoch}',
          concepto: borrador.concepto,
          montoCentavos: borrador.montoCentavos,
          pagadorId: borrador.pagadorId,
          participanteIds: borrador.participanteIds,
          categoria: borrador.categoria,
          metodo: borrador.metodo,
          emoji: borrador.emoji,
          dictado: true,
          fecha: DateTime.now(),
        ),
      );
    }
  }

  void marcarPagada(String eventoId, Transferencia pago) {
    final clave = '$eventoId|${pago.clave}';
    if (!_pagadas.add(clave)) _pagadas.remove(clave);
    notifyListeners();
  }

  bool estaPagada(String eventoId, Transferencia pago) {
    return _pagadas.contains('$eventoId|${pago.clave}');
  }

  Evento? porCodigo(String codigo) {
    final normalizado = codigo.trim().toUpperCase();
    for (final evento in eventos) {
      if (evento.codigo.toUpperCase() == normalizado) return evento;
    }
    return null;
  }

  void _reemplazar(String eventoId, Evento Function(Evento actual) cambio) {
    eventos = [
      for (final evento in eventos)
        if (evento.id == eventoId) cambio(evento) else evento,
    ];
    notifyListeners();
  }
}
