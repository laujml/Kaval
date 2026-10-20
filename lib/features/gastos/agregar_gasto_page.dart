import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/liquidacion/liquidacion.dart';
import '../../core/red/cliente_api.dart';
import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_medidas.dart';
import '../../core/theme/kaval_paleta.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/utils/dinero.dart';
import '../../core/utils/etiquetas.dart';
import '../../core/widgets/aviso.dart';
import '../../core/widgets/boton_coral.dart';
import '../../core/widgets/campo_kaval.dart';
import '../../core/widgets/chip_categoria.dart';
import '../../core/widgets/logo_kaval.dart';
import '../../l10n/app_localizations.dart';
import '../../models/gasto.dart';
import '../../models/integrante.dart';
import '../../state/kaval_state.dart';
import '../errores/control_errores_page.dart';
import 'editor_division.dart';
import 'resumen_division.dart';
import 'selector_pagador.dart';

class AgregarGastoPage extends StatefulWidget {
  const AgregarGastoPage({super.key, required this.eventoId, this.gastoId, this.desdeVoz = false});

  final String eventoId;
  final String? gastoId;
  final bool desdeVoz;

  @override
  State<AgregarGastoPage> createState() => _AgregarGastoPageState();
}

class _AgregarGastoPageState extends State<AgregarGastoPage> {
  final _formKey = GlobalKey<FormState>();
  final _monto = TextEditingController();
  final _concepto = TextEditingController();
  final _montoFocus = FocusNode();
  final _conceptoFocus = FocusNode();
  final _propina = TextEditingController();
  final _extras = TextEditingController();
  final _propinaFocus = FocusNode();
  final _extrasFocus = FocusNode();
  final Map<String, TextEditingController> _montosPersona = {};
  final List<BorradorItem> _items = [];

  CategoriaGasto _categoria = CategoriaGasto.comida;
  String? _pagadorId;
  Set<String> _participantes = {};
  ModoDivision _modo = ModoDivision.iguales;
  bool _enviando = false;
  bool _editando = false;
  bool _dictado = false;
  String? _errorMonto;
  String? _errorConcepto;
  String? _errorPagador;
  var _ejemploListo = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ejemploListo) return;
    _ejemploListo = true;
    final evento = context.read<KavalState>().buscar(widget.eventoId);
    final ids = evento?.integrantes.map((p) => p.id).toList() ?? [];
    final existente = _buscarGasto(evento?.gastos ?? const []);
    if (existente != null) {
      _editando = true;
      _cargar(existente, ids);
      return;
    }
    if (widget.desdeVoz) {
      final estado = context.read<KavalState>();
      final borrador = estado.borrador;
      _cargar(borrador, ids);
      _dictado = true;
      if (borrador.participanteIds.isNotEmpty) {
        _participantes = borrador.participanteIds.toSet();
      }
      return;
    }
    _participantes = ids.toSet();
    final usuarioId = context.read<KavalState>().usuario.id;
    _pagadorId = ids.contains(usuarioId) ? usuarioId : null;
  }

  void _cargar(Gasto gasto, List<String> ids) {
    _concepto.text = gasto.concepto;
    if (gasto.modoDivision != ModoDivision.consumo && gasto.montoCentavos > 0) {
      _monto.text = (gasto.montoCentavos / 100).toStringAsFixed(2);
    }
    _categoria = gasto.categoria;
    _modo = gasto.modoDivision;
    _dictado = gasto.dictado;
    _participantes = gasto.participanteIds.isEmpty ? ids.toSet() : gasto.participanteIds.toSet();
    _pagadorId = gasto.metodo == MetodoPago.efectivoGrupo
        ? idEfectivoGrupo
        : (gasto.pagadorId != null && ids.contains(gasto.pagadorId) ? gasto.pagadorId : null);
    if (gasto.propinaPorcentaje > 0) _propina.text = '${gasto.propinaPorcentaje}';
    if (gasto.extrasCentavos > 0) _extras.text = (gasto.extrasCentavos / 100).toStringAsFixed(2);
    for (final entrada in gasto.partes.entries) {
      _montoDe(entrada.key).text = (entrada.value / 100).toStringAsFixed(2);
    }
    for (final item in gasto.items) {
      _items.add(BorradorItem.desde(item));
    }
  }

  TextEditingController _montoDe(String id) {
    return _montosPersona.putIfAbsent(id, TextEditingController.new);
  }

  Gasto? _buscarGasto(List<Gasto> gastos) {
    final id = widget.gastoId;
    if (id == null) return null;
    for (final gasto in gastos) {
      if (gasto.id == id) return gasto;
    }
    return null;
  }

  @override
  void dispose() {
    _monto.dispose();
    _concepto.dispose();
    _montoFocus.dispose();
    _conceptoFocus.dispose();
    _propina.dispose();
    _extras.dispose();
    _propinaFocus.dispose();
    _extrasFocus.dispose();
    for (final control in _montosPersona.values) {
      control.dispose();
    }
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  Future<void> _guardar() async {
    final textos = AppLocalizations.of(context);
    final formulario = _formKey.currentState;
    if (formulario == null || !formulario.validate() || _enviando) return;
    final evento = context.read<KavalState>().buscar(widget.eventoId);
    if (evento == null) return;
    final centavos = _totalDe(evento.integrantes);
    final error = _validarDivision(textos, evento.integrantes, centavos);
    if (error != null) {
      setState(() => _errorPagador = _pagadorId == null ? textos.eligePagador : null);
      mostrarAviso(context, error);
      return;
    }
    formulario.save();
    final gasto = _gastoDesde(centavos, evento.integrantes);
    final estado = context.read<KavalState>();
    final cliente = context.read<ClienteApi>();
    final fallo = estado.consumirFallo();
    setState(() => _enviando = true);
    try {
      await cliente.guardarGasto(
        datos: {
          'title': gasto.concepto,
          'body': '${gasto.montoCentavos}|${gasto.categoria.name}',
          'userId': 1,
        },
        edicion: _editando,
        fallo: fallo,
      );
      if (!mounted) return;
      _guardarLocal(estado, gasto, textos);
    } on DioException catch (error) {
      if (!mounted) return;
      setState(() => _enviando = false);
      _alFallar(error, textos, estado, gasto);
    }
  }

  List<String> _orden(List<Integrante> personas) {
    return [for (final persona in personas) if (_participantes.contains(persona.id)) persona.id];
  }

  int _propinaPorcentaje() {
    final numero = int.tryParse(_propina.text.trim());
    if (numero == null || numero < 0) return 0;
    return numero > 100 ? 100 : numero;
  }

  int _extrasCentavos() => centavosDesdeTexto(_extras.text) ?? 0;

  List<ItemGasto> _itemsListos(List<Integrante> personas) {
    final orden = [for (final persona in personas) persona.id];
    return [
      for (final item in _items)
        ItemGasto(
          id: item.id,
          nombre: item.nombre.text.trim(),
          precioCentavos: centavosDesdeTexto(item.precio.text) ?? 0,
          cantidad: int.tryParse(item.cantidad.text.trim()) ?? 0,
          participanteIds: [for (final id in orden) if (item.asignados.contains(id)) id],
        ),
    ];
  }

  Map<String, int> _partesDe(List<Integrante> personas, int total) {
    final orden = _orden(personas);
    return switch (_modo) {
      ModoDivision.iguales => repartirCentavos(total, orden),
      ModoDivision.montos => {for (final id in orden) id: centavosDesdeTexto(_montoDe(id).text) ?? 0},
      ModoDivision.consumo => partesConsumo(
          items: _itemsListos(personas),
          propinaPorcentaje: _propinaPorcentaje(),
          extrasCentavos: _extrasCentavos(),
        ),
    };
  }

  int _totalDe(List<Integrante> personas) {
    if (_modo == ModoDivision.consumo) return sumaPartes(_partesDe(personas, 0));
    return centavosDesdeTexto(_monto.text) ?? 0;
  }

  String? _validarDivision(AppLocalizations textos, List<Integrante> personas, int total) {
    if (_pagadorId == null) return textos.eligePagador;
    if (_modo == ModoDivision.consumo) {
      if (_items.isEmpty || total <= 0) return textos.sinItems;
      for (final item in _items) {
        if (item.nombre.text.trim().isEmpty) return textos.itemIncompleto;
        final precio = centavosDesdeTexto(item.precio.text);
        final cantidad = int.tryParse(item.cantidad.text.trim());
        if (precio == null || precio <= 0 || cantidad == null || cantidad <= 0) return textos.itemIncompleto;
        if (item.asignados.isEmpty) return textos.itemSinPersona;
      }
      return null;
    }
    if (_orden(personas).isEmpty) return textos.eligeParticipantes;
    if (_modo == ModoDivision.montos && sumaPartes(_partesDe(personas, total)) != total) {
      return textos.sumaNoCuadra;
    }
    return null;
  }

  Gasto _gastoDesde(int centavos, List<Integrante> personas) {
    final efectivo = _pagadorId == idEfectivoGrupo;
    final partes = _partesDe(personas, centavos);
    final participantes = _modo == ModoDivision.consumo
        ? [for (final persona in personas) if (partes.containsKey(persona.id)) persona.id]
        : _orden(personas);
    return Gasto(
      id: widget.gastoId ?? 'gasto-${DateTime.now().microsecondsSinceEpoch}',
      concepto: _concepto.text.trim(),
      montoCentavos: centavos,
      pagadorId: efectivo ? null : _pagadorId,
      participanteIds: participantes,
      categoria: _categoria,
      metodo: efectivo ? MetodoPago.efectivoGrupo : MetodoPago.tarjeta,
      dictado: _dictado,
      fecha: DateTime.now(),
      modoDivision: _modo,
      partes: partes,
      items: _modo == ModoDivision.consumo ? _itemsListos(personas) : const [],
      propinaPorcentaje: _modo == ModoDivision.consumo ? _propinaPorcentaje() : 0,
      extrasCentavos: _modo == ModoDivision.consumo ? _extrasCentavos() : 0,
    );
  }

  void _guardarLocal(KavalState estado, Gasto gasto, AppLocalizations textos) {
    if (_editando) {
      estado.actualizarGasto(widget.eventoId, gasto);
      mostrarAviso(context, textos.gastoActualizado);
    } else {
      estado.agregarGasto(widget.eventoId, gasto);
      mostrarAviso(context, textos.gastoGuardado);
    }
    volver(context);
  }

  void _alFallar(DioException error, AppLocalizations textos, KavalState estado, Gasto gasto) {
    switch (clasificar(error)) {
      case TipoFallo.espera:
        mostrarAviso(
          context,
          textos.tiempoAgotadoAviso,
          accion: textos.reintentar,
          alAccionar: () => _guardar(),
        );
      case TipoFallo.sinRed:
        context.push(
          '/errores/red',
          extra: PasoError(
            alReintentar: () => _guardar(),
            alSeguirLocal: () => _guardarLocal(estado, gasto, textos),
          ),
        );
      case TipoFallo.sesion:
        context.push('/errores/sesion');
      case TipoFallo.rechazo:
        final mensaje = mensajeRechazo(error, textos.datosRechazados);
        setState(() {
          if (campoRechazado(error) == 'monto') {
            _errorMonto = mensaje;
            _errorConcepto = null;
          } else {
            _errorConcepto = mensaje;
            _errorMonto = null;
          }
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _formKey.currentState?.validate();
        });
      case TipoFallo.otro:
        mostrarAviso(context, textos.errorGenerico);
    }
  }

  String _textoResumen(
    AppLocalizations textos,
    String usuarioId,
    List<Integrante> personas,
    int total,
    Map<String, int> partes,
  ) {
    if (_pagadorId == null || total <= 0) return '';
    final efectivo = _pagadorId == idEfectivoGrupo;
    final deudas = <DeudaResumen>[];
    var nombrePagador = '';
    for (final persona in personas) {
      if (persona.id == _pagadorId) nombrePagador = persona.nombre;
      final cuota = partes[persona.id] ?? 0;
      if (cuota <= 0) continue;
      if (!efectivo && persona.id == _pagadorId) continue;
      deudas.add(DeudaResumen(etiquetaIntegrante(textos, persona, usuarioId), cuota));
    }
    return textoResumen(
      textos: textos,
      efectivo: efectivo,
      soyYo: _pagadorId == usuarioId,
      nombrePagador: nombrePagador,
      total: total,
      deudas: deudas,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final paleta = KavalPaleta.de(context);
    final estado = context.watch<KavalState>();
    final evento = estado.buscar(widget.eventoId);
    if (evento == null) return Scaffold(body: Center(child: Text(textos.sinEventos)));
    final personas = evento.integrantes;
    final centavos = _totalDe(personas);
    final partes = _partesDe(personas, centavos);
    final resumen = _textoResumen(textos, estado.usuario.id, personas, centavos, partes);

    return Scaffold(
      backgroundColor: paleta.crema,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                children: [
                  BotonRedondo(icono: Icons.close, onTap: () => volver(context)),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          _editando ? textos.editarGasto : textos.nuevoGasto,
                          style: KavalTexto.titulo(size: 18),
                        ),
                        Text(evento.nombre, style: KavalTexto.cuerpo(size: 12)),
                      ],
                    ),
                  ),
                  BotonRedondo(
                    icono: Icons.mic_none_rounded,
                    tinta: KavalColors.coral,
                    onTap: () => context.push('/evento/${evento.id}/dictar'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  children: [
                    if (widget.desdeVoz)
                      _AvisoVoz(
                        revisa: textos.vozRevisa,
                        oido: estado.fraseOida.trim().isEmpty ? null : textos.vozOido(estado.fraseOida.trim()),
                      ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: KavalColors.durazno,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          _Paso(numero: '1', texto: textos.monto),
                          if (_modo != ModoDivision.consumo)
                            TextFormField(
                              controller: _monto,
                              focusNode: _montoFocus,
                              textAlign: TextAlign.center,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_conceptoFocus),
                              style: KavalTexto.titulo(size: 36),
                              decoration: const InputDecoration(border: InputBorder.none, prefixText: '\$'),
                              onChanged: (_) => setState(() => _errorMonto = null),
                              validator: (valor) {
                                if (_modo == ModoDivision.consumo) return null;
                                if (_errorMonto != null) return _errorMonto;
                                final monto = centavosDesdeTexto(valor ?? '');
                                if (monto == null || monto <= 0) return textos.montoInvalido;
                                return null;
                              },
                            ),
                          TextFormField(
                            controller: _concepto,
                            focusNode: _conceptoFocus,
                            textAlign: TextAlign.center,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _guardar(),
                            style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800),
                            decoration: decoracionCampo(context, hint: textos.conceptoEjemplo),
                            onChanged: (_) => setState(() => _errorConcepto = null),
                            validator: (valor) {
                              if (_errorConcepto != null) return _errorConcepto;
                              if ((valor?.trim() ?? '').isEmpty) return textos.conceptoObligatorio;
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final categoria in CategoriaGasto.values)
                          ChipCategoria(
                            icono: iconoCategoria(categoria),
                            texto: nombreCategoria(textos, categoria),
                            activo: _categoria == categoria,
                            onTap: () => setState(() => _categoria = categoria),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _Paso(numero: '2', texto: textos.quienPago),
                    const SizedBox(height: 4),
                    Text(textos.ayudaPagador, style: KavalTexto.cuerpo(size: 12)),
                    const SizedBox(height: 8),
                    SelectorPagador(
                      personas: personas,
                      usuarioId: estado.usuario.id,
                      seleccionId: _pagadorId,
                      onElegir: (id) => setState(() {
                        _pagadorId = id;
                        _errorPagador = null;
                      }),
                    ),
                    if (_errorPagador != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(_errorPagador!, style: KavalTexto.cuerpo(color: KavalColors.coral, weight: FontWeight.w800)),
                      ),
                    const SizedBox(height: 16),
                    _Paso(numero: '3', texto: textos.entreQuienes),
                    const SizedBox(height: 8),
                    EditorDivision(
                      modo: _modo,
                      alCambiarModo: (modo) => setState(() => _modo = modo),
                      personas: personas,
                      usuarioId: estado.usuario.id,
                      participantes: _participantes,
                      alAlternar: (id) => setState(() {
                        if (!_participantes.add(id)) _participantes.remove(id);
                      }),
                      partesIguales: partes,
                      controlMonto: _montoDe,
                      alCambiarMonto: () => setState(() {}),
                      totalReferencia: centavosDesdeTexto(_monto.text) ?? 0,
                      items: _items,
                      alAgregarItem: () => setState(() {
                        _items.add(BorradorItem(asignados: personas.map((p) => p.id).toSet()));
                      }),
                      alQuitarItem: (item) {
                        setState(() => _items.remove(item));
                        WidgetsBinding.instance.addPostFrameCallback((_) => item.dispose());
                      },
                      alAlternarAsignado: (item, id) => setState(() {
                        if (!item.asignados.add(id)) item.asignados.remove(id);
                      }),
                      propina: _propina,
                      extras: _extras,
                      propinaFocus: _propinaFocus,
                      extrasFocus: _extrasFocus,
                      totalConsumoCentavos: _modo == ModoDivision.consumo ? centavos : 0,
                    ),
                    const SizedBox(height: KavalMedidas.sm),
                    TarjetaResumen(texto: resumen),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: BotonCoral(
                texto: _enviando ? textos.enviando : textos.guardarGasto(usd(centavos)),
                icono: const _Numero('4'),
                onPressed: _enviando ? null : () => _guardar(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvisoVoz extends StatelessWidget {
  const _AvisoVoz({required this.revisa, this.oido});

  final String revisa;
  final String? oido;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        label: oido ?? revisa,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: KavalColors.menta, borderRadius: BorderRadius.circular(16)),
          child: Text(
            oido == null ? revisa : '$revisa\n$oido',
            style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}

class _Paso extends StatelessWidget {
  const _Paso({required this.numero, required this.texto});

  final String numero;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Numero(numero),
        const SizedBox(width: 8),
        Text(texto, style: KavalTexto.titulo(size: 16)),
      ],
    );
  }
}

class _Numero extends StatelessWidget {
  const _Numero(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: Colors.white,
      child: Text(texto, style: KavalTexto.cuerpo(size: 12, weight: FontWeight.w800, color: KavalColors.coral)),
    );
  }
}

