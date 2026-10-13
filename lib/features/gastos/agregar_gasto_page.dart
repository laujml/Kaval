import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/liquidacion/liquidacion.dart';
import '../../core/red/cliente_api.dart';
import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/utils/dinero.dart';
import '../../core/utils/etiquetas.dart';
import '../../core/widgets/aviso.dart';
import '../../core/widgets/boton_coral.dart';
import '../../core/widgets/campo_kaval.dart';
import '../../core/widgets/chip_categoria.dart';
import '../../core/widgets/kaval_avatar.dart';
import '../../core/widgets/logo_kaval.dart';
import '../../l10n/app_localizations.dart';
import '../../models/gasto.dart';
import '../../models/integrante.dart';
import '../../state/kaval_state.dart';
import '../errores/control_errores_page.dart';

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
  final _monto = TextEditingController(text: '36.00');
  final _concepto = TextEditingController();
  final _montoFocus = FocusNode();
  final _conceptoFocus = FocusNode();

  CategoriaGasto _categoria = CategoriaGasto.comida;
  String? _pagadorId;
  Set<String> _participantes = {};
  MetodoPago _metodo = MetodoPago.tarjeta;
  bool _ajustar = false;
  bool _enviando = false;
  bool _editando = false;
  bool _dictado = false;
  String? _errorMonto;
  String? _errorConcepto;
  var _ejemploListo = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ejemploListo) return;
    _ejemploListo = true;
    final textos = AppLocalizations.of(context);
    final evento = context.read<KavalState>().buscar(widget.eventoId);
    final ids = evento?.integrantes.map((p) => p.id).toList() ?? [];
    final existente = _buscarGasto(evento?.gastos ?? const []);
    if (existente != null) {
      _editando = true;
      _concepto.text = existente.concepto;
      _monto.text = (existente.montoCentavos / 100).toStringAsFixed(2);
      _categoria = existente.categoria;
      _metodo = existente.metodo;
      _pagadorId = existente.pagadorId ?? (ids.isEmpty ? null : ids.first);
      _participantes = existente.participanteIds.toSet();
      _dictado = existente.dictado;
      return;
    }
    if (widget.desdeVoz) {
      final estado = context.read<KavalState>();
      final borrador = estado.borrador;
      _concepto.text = borrador.concepto;
      _monto.text = (borrador.montoCentavos / 100).toStringAsFixed(2);
      _categoria = borrador.categoria;
      _dictado = true;
      _participantes = ids.toSet();
      final pagador = borrador.pagadorId;
      _pagadorId = pagador != null && ids.contains(pagador)
          ? pagador
          : (ids.contains(estado.usuario.id) ? estado.usuario.id : (ids.isEmpty ? null : ids.first));
      return;
    }
    _concepto.text = textos.conceptoEjemplo;
    _participantes = ids.toSet();
    _pagadorId = ids.length > 4 ? ids[4] : (ids.isEmpty ? null : ids.first);
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
    super.dispose();
  }

  Future<void> _guardar() async {
    final textos = AppLocalizations.of(context);
    final formulario = _formKey.currentState;
    if (formulario == null || !formulario.validate() || _enviando) return;
    if (_metodo == MetodoPago.tarjeta && _pagadorId == null) {
      mostrarAviso(context, textos.eligePagador);
      return;
    }
    if (_participantes.isEmpty) {
      mostrarAviso(context, textos.eligeParticipantes);
      return;
    }
    formulario.save();
    final centavos = centavosDesdeTexto(_monto.text)!;
    final gasto = _gastoDesde(centavos);
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

  Gasto _gastoDesde(int centavos) {
    return Gasto(
      id: widget.gastoId ?? 'gasto-${DateTime.now().microsecondsSinceEpoch}',
      concepto: _concepto.text.trim(),
      montoCentavos: centavos,
      pagadorId: _metodo == MetodoPago.efectivoGrupo ? null : _pagadorId,
      participanteIds: _participantes.toList(),
      categoria: _categoria,
      metodo: _metodo,
      emoji: emojiCategoria(_categoria),
      dictado: _dictado,
      fecha: DateTime.now(),
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

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = context.watch<KavalState>();
    final evento = estado.buscar(widget.eventoId);
    if (evento == null) return Scaffold(body: Center(child: Text(textos.sinEventos)));
    final centavos = centavosDesdeTexto(_monto.text) ?? 0;
    final partes = repartirCentavos(centavos, _participantes.toList());
    final cuota = _participantes.isEmpty ? 0 : (partes.values.isEmpty ? 0 : partes.values.first);

    return Scaffold(
      backgroundColor: KavalColors.crema,
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
                        Text('${evento.nombre} ${evento.emoji}', style: KavalTexto.cuerpo(size: 12)),
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
                            decoration: decoracionCampo(),
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
                            emoji: emojiCategoria(categoria),
                            texto: nombreCategoria(textos, categoria),
                            activo: _categoria == categoria,
                            onTap: () => setState(() => _categoria = categoria),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _Paso(numero: '2', texto: textos.quienPago),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (final persona in evento.integrantes)
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                            onTap: () => setState(() => _pagadorId = persona.id),
                            child: Column(
                              children: [
                                avatarDe(persona, tamano: 44, seleccionado: persona.id == _pagadorId),
                                const SizedBox(height: 4),
                                Text(
                                  etiquetaIntegrante(textos, persona, estado.usuario.id),
                                  style: KavalTexto.cuerpo(
                                    size: 11,
                                    weight: FontWeight.w800,
                                    color: persona.id == _pagadorId ? KavalColors.coral : KavalColors.marino,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ),
                      ],
                    ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _Paso(numero: '3', texto: textos.entreQuienes),
                        const Spacer(),
                        ChipCategoria(
                          texto: '✓ ${textos.todosChip}',
                          activo: _participantes.length == evento.integrantes.length,
                          onTap: () => setState(() {
                            _participantes = evento.integrantes.map((p) => p.id).toSet();
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _ListaParticipantes(
                      personas: evento.integrantes,
                      usuarioId: estado.usuario.id,
                      participantes: _participantes,
                      partes: partes,
                      ajustar: _ajustar,
                      cuota: cuota,
                      onAjustar: () => setState(() => _ajustar = !_ajustar),
                      onToggle: (id) => setState(() {
                        if (!_participantes.add(id)) _participantes.remove(id);
                      }),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _Metodo(
                            texto: '💳 ${textos.tarjeta}',
                            activo: _metodo == MetodoPago.tarjeta,
                            onTap: () => setState(() => _metodo = MetodoPago.tarjeta),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _Metodo(
                            texto: '💵 ${textos.efectivoGrupo}',
                            activo: _metodo == MetodoPago.efectivoGrupo,
                            onTap: () => setState(() => _metodo = MetodoPago.efectivoGrupo),
                          ),
                        ),
                      ],
                    ),
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

class _ListaParticipantes extends StatelessWidget {
  const _ListaParticipantes({
    required this.personas,
    required this.usuarioId,
    required this.participantes,
    required this.partes,
    required this.ajustar,
    required this.cuota,
    required this.onAjustar,
    required this.onToggle,
  });

  final List<Integrante> personas;
  final String usuarioId;
  final Set<String> participantes;
  final Map<String, int> partes;
  final bool ajustar;
  final int cuota;
  final VoidCallback onAjustar;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final visibles = ajustar ? personas : personas.take(2).toList();
    final ocultos = personas.length - visibles.length;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: KavalColors.borde),
      ),
      child: Column(
        children: [
          for (final persona in visibles)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: avatarDe(persona, tamano: 36),
              title: Text(
                persona.id == usuarioId ? textos.tuEntre(persona.nombre) : persona.nombre,
                style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(usd(partes[persona.id] ?? 0), style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800)),
                  Icon(
                    participantes.contains(persona.id) ? Icons.check_circle : Icons.circle_outlined,
                    color: participantes.contains(persona.id) ? KavalColors.coral : KavalColors.gris,
                  ),
                ],
              ),
              onTap: () => onToggle(persona.id),
            ),
          if (ocultos > 0)
            Row(
              children: [
                Text(textos.masCuota(ocultos, usd(cuota)), style: KavalTexto.cuerpo(size: 13)),
                const Spacer(),
                TextButton(
                  onPressed: onAjustar,
                  child: Text(ajustar ? textos.ocultarAjuste : textos.ajustar, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.coral)),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _Metodo extends StatelessWidget {
  const _Metodo({required this.texto, required this.activo, required this.onTap});

  final String texto;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: activo ? Colors.white : KavalColors.campo,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: activo ? KavalColors.marino : Colors.transparent),
          ),
          child: Text(texto, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.marino)),
        ),
      ),
    );
  }
}
