import 'dart:async';

import 'package:flutter/material.dart';

import '../core/eventos/actividad_evento.dart';
import '../core/gastos/pagador.dart';
import '../core/liquidacion/liquidacion.dart';
import '../core/red/cliente_api.dart';
import '../core/voz/interpretar_dictado.dart';
import '../data/repositorios/repositorio_datos.dart';
import '../models/aporte_efectivo.dart';
import '../models/evento.dart';
import '../models/gasto.dart';
import '../models/integrante.dart';
import '../models/transferencia.dart';
import '../models/usuario.dart';

/// Estado de la materia: un ChangeNotifier que las pantallas escuchan.
class KavalState extends ChangeNotifier {
  KavalState({this.datos})
      : usuario = const Usuario(id: '', nombre: '', correo: ''),
        eventos = const [],
        borrador = KavalState.borradorVacio;

  final RepositorioDatos? datos;
  StreamSubscription<List<Evento>>? _nube;

  static final borradorVacio = Gasto(
    id: 'borrador',
    concepto: '',
    montoCentavos: 0,
    participanteIds: const [],
    categoria: CategoriaGasto.comida,
    metodo: MetodoPago.tarjeta,
    fecha: DateTime.utc(2026, 1, 1),
  );

  Locale locale = const Locale('es');
  Usuario usuario;
  List<Evento> eventos;
  Gasto borrador;

  /// Frase que el micrófono entendió, para mostrarla al revisar el gasto.
  String fraseOida = '';
  bool sincronizarNube = true;
  PortadaEvento? filtro;
  bool _sesionNube = false;

  /// Se gasta en la siguiente llamada y vuelve a ninguno.
  FalloForzado falloForzado = FalloForzado.ninguno;

  /// Claves de transferencias marcadas como pagadas, por evento.
  final Set<String> _pagadas = {};

  String get idioma => locale.languageCode;

  bool get enLaNube => _sesionNube && datos != null;

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
    final db = datos?.db;
    if (db == null || !enLaNube) return;
    if (valor) {
      unawaited(db.enableNetwork());
    } else {
      unawaited(db.disableNetwork());
    }
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

  /// Viajes que todavía no terminan: futuros o en curso.
  List<Evento> get eventosActivos => eventosActivosEn(eventos, DateTime.now());

  /// Solo los que ya pasaron su fecha de fin.
  List<Evento> get eventosHistorial => eventosHistorialEn(eventos, DateTime.now());

  /// Activos, y si hay filtro de portada, solo esa.
  List<Evento> get eventosFiltrados {
    final base = eventosActivos;
    final portada = filtro;
    if (portada == null) return base;
    return base.where((evento) => evento.portada == portada).toList();
  }

  int saldoEn(Evento evento) => calcularLiquidacion(evento).saldoDe(usuario.id);

  /// Suma de saldos a favor, en todos los viajes.
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
    _soltarNube();
    _sesionNube = false;
    usuario = Usuario(
      id: local ? 'local' : usuario.id,
      nombre: nombre.trim(),
      correo: correo.trim(),
      local: local,
    );
    eventos = const [];
    notifyListeners();
  }

  Future<void> entrarEnLaNube(Usuario cuenta) async {
    _soltarNube();
    _sesionNube = datos != null;
    usuario = cuenta;
    eventos = const [];
    notifyListeners();
    final nube = datos;
    if (nube == null) return;
    await nube.usuarios.guardar(cuenta);
    _nube = nube.eventos.escuchar(cuenta.id).listen(
      (lista) {
        eventos = fusionarEventos(eventos, lista);
        notifyListeners();
      },
      onError: (Object error) {
        debugPrint('[kaval] no se pudieron leer los eventos: $error');
      },
    );
  }

  Future<void> salir() async {
    _soltarNube();
    _sesionNube = false;
    usuario = const Usuario(id: '', nombre: '', correo: '');
    eventos = const [];
    borrador = borradorVacio;
    notifyListeners();
  }

  Future<void> borrarCuentaEnLaNube() async {
    final nube = datos;
    if (!enLaNube || nube == null) return;
    await nube.usuarios.borrar(usuario.id);
  }

  void crearEvento(Evento evento) {
    var listo = evento;
    if (enLaNube) {
      final sinDueno = listo.integrante(usuario.id) == null;
      listo = listo.copyWith(
        sincronizado: false,
        integrantes: sinDueno
            ? [
                Integrante(
                  id: usuario.id,
                  nombre: usuario.primerNombre,
                  colorFondo: 0xFFFFD9E0,
                  colorInicial: 0xFFE56B8A,
                  estado: EstadoUnion.admin,
                ),
                ...listo.integrantes,
              ]
            : listo.integrantes,
      );
    }
    eventos = [listo, ...eventos];
    notifyListeners();
    if (enLaNube) unawaited(datos!.eventos.guardar(listo, duenoId: usuario.id));
  }

  void agregarIntegrante(String eventoId, Integrante persona) {
    _reemplazar(eventoId, (evento) {
      return evento.copyWith(
        integrantes: [...evento.integrantes, persona],
        sincronizado: !enLaNube,
      );
    });
    if (enLaNube) unawaited(datos!.integrantes.guardar(eventoId, persona));
  }

  void agregarGasto(String eventoId, Gasto gasto) {
    _reemplazar(eventoId, (evento) {
      return evento.copyWith(
        gastos: [gasto, ...evento.gastos],
        sincronizado: !enLaNube,
      );
    });
    if (enLaNube) unawaited(datos!.gastos.guardar(eventoId, gasto));
  }

  void actualizarGasto(String eventoId, Gasto gasto) {
    _reemplazar(eventoId, (evento) {
      return evento.copyWith(
        gastos: [
          for (final actual in evento.gastos)
            if (actual.id == gasto.id) gasto else actual,
        ],
        sincronizado: !enLaNube,
      );
    });
    if (enLaNube) unawaited(datos!.gastos.guardar(eventoId, gasto));
  }

  void agregarAporte(String eventoId, AporteEfectivo aporte) {
    _reemplazar(eventoId, (evento) {
      return evento.copyWith(
        aportes: [...evento.aportes, aporte],
        sincronizado: !enLaNube,
      );
    });
    if (enLaNube) unawaited(datos!.aportes.guardar(eventoId, aporte));
  }

  /// Deja el gasto dictado listo para el formulario. No lo guarda.
  void aplicarDictado({
    required String eventoId,
    required int montoCentavos,
    required String concepto,
    required CategoriaGasto categoria,
    required String frase,
    QuienPagoDictado quien = QuienPagoDictado.ninguno,
    String? nombrePagador,
    bool entreTodos = false,
  }) {
    final evento = buscar(eventoId);
    if (evento == null) return;
    final ids = [for (final persona in evento.integrantes) persona.id];
    final propio = ids.contains(usuario.id) ? usuario.id : null;
    String? pagador = propio;
    var metodo = MetodoPago.tarjeta;
    if (quien == QuienPagoDictado.fondo) {
      pagador = null;
      metodo = MetodoPago.efectivoGrupo;
    } else if (quien == QuienPagoDictado.nombrado && nombrePagador != null) {
      pagador = buscarPagador(evento.integrantes, nombrePagador);
      metodo = MetodoPago.tarjeta;
    } else if (quien == QuienPagoDictado.tu) {
      pagador = propio;
      metodo = MetodoPago.tarjeta;
    }
    fraseOida = frase;
    borrador = Gasto(
      id: 'borrador-voz',
      concepto: concepto,
      montoCentavos: montoCentavos,
      pagadorId: pagador,
      participanteIds: entreTodos || ids.isNotEmpty ? ids : const [],
      categoria: categoria,
      metodo: metodo,
      dictado: true,
      fecha: DateTime.now(),
    );
    notifyListeners();
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
          dictado: true,
          fecha: DateTime.now(),
          modoDivision: borrador.modoDivision,
          partes: borrador.partes,
          items: borrador.items,
          propinaPorcentaje: borrador.propinaPorcentaje,
          extrasCentavos: borrador.extrasCentavos,
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

  Future<Evento?> unirse(String codigo) async {
    if (!enLaNube) return porCodigo(codigo);
    final evento = await datos!.eventos.unirse(codigo, usuario);
    if (evento == null) return null;
    if (!eventos.any((actual) => actual.id == evento.id)) {
      eventos = [evento, ...eventos];
      notifyListeners();
    }
    return evento;
  }

  void _reemplazar(String eventoId, Evento Function(Evento actual) cambio) {
    eventos = [
      for (final evento in eventos)
        if (evento.id == eventoId) cambio(evento) else evento,
    ];
    notifyListeners();
  }

  void _soltarNube() {
    unawaited(_nube?.cancel());
    _nube = null;
  }

  @override
  void dispose() {
    _soltarNube();
    super.dispose();
  }
}
