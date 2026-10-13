import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/invitaciones/codigo_evento.dart';
import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/utils/fechas.dart';
import '../../core/widgets/aviso.dart';
import '../../core/widgets/boton_coral.dart';
import '../../core/widgets/campo_kaval.dart';
import '../../core/widgets/ilustraciones.dart';
import '../../core/widgets/kaval_avatar.dart';
import '../../core/widgets/logo_kaval.dart';
import '../../data/datos_ejemplo.dart';
import '../../l10n/app_localizations.dart';
import '../../models/evento.dart';
import '../../models/integrante.dart';
import '../../state/kaval_state.dart';

class CrearEventoPage extends StatefulWidget {
  const CrearEventoPage({super.key});

  @override
  State<CrearEventoPage> createState() => _CrearEventoPageState();
}

class _CrearEventoPageState extends State<CrearEventoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController(text: 'Playa El Tunco 🌊');
  final _integrante = TextEditingController();
  final _nombreFocus = FocusNode();
  final _integranteFocus = FocusNode();

  late List<Integrante> _personas;
  PortadaEvento _portada = PortadaEvento.playa;
  DateTime _inicio = DateTime(2026, 10, 2);
  DateTime _fin = DateTime(2026, 10, 4);

  static const _fondos = [0xFFD5F5E8, 0xFFD9ECFF, 0xFFE8D9FF, 0xFFFFE8C2, 0xFFFFE0D6];
  static const _tintas = [0xFF1FA971, 0xFF3A7BD5, 0xFF8B5CF6, 0xFFE0A100, 0xFFE07A5F];

  @override
  void initState() {
    super.initState();
    // Arranca con el grupo del mockup para que la pantalla se vea igual.
    _personas = [
      for (final persona in eventoPlayaTunco().integrantes) persona,
    ];
  }

  @override
  void dispose() {
    _nombre.dispose();
    _integrante.dispose();
    _nombreFocus.dispose();
    _integranteFocus.dispose();
    super.dispose();
  }

  void _agregar(AppLocalizations textos) {
    final nombre = _integrante.text.trim();
    if (nombre.length < 2) {
      _formKey.currentState?.validate();
      return;
    }
    setState(() {
      final indice = _personas.length % _fondos.length;
      _personas.add(
        Integrante(
          id: '${nombre.toLowerCase()}-${DateTime.now().millisecondsSinceEpoch}',
          nombre: nombre,
          colorFondo: _fondos[indice],
          colorInicial: _tintas[indice],
          estado: EstadoUnion.soloNombre,
        ),
      );
      _integrante.clear();
    });
  }

  Future<void> _elegirFecha({required bool inicio}) async {
    final actual = inicio ? _inicio : _fin;
    final elegida = await showDatePicker(
      context: context,
      initialDate: actual,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (elegida == null) return;
    setState(() {
      if (inicio) {
        _inicio = elegida;
        if (_fin.isBefore(_inicio)) _fin = _inicio;
      } else {
        _fin = elegida;
      }
    });
  }

  void _crear() {
    final textos = AppLocalizations.of(context);
    final formulario = _formKey.currentState;
    if (formulario == null || !formulario.validate()) return;
    if (_integrante.text.trim().isNotEmpty) _agregar(textos);
    if (_personas.isEmpty) {
      mostrarAviso(context, textos.faltaIntegrante);
      return;
    }
    formulario.save();
    final estado = context.read<KavalState>();
    final id = 'evento-${DateTime.now().millisecondsSinceEpoch}';
    final evento = Evento(
      id: id,
      nombre: _nombre.text.trim(),
      lugar: 'El Salvador',
      inicio: _inicio,
      fin: _fin,
      portada: _portada,
      codigo: codigoDeEvento(_nombre.text),
      emoji: _emoji(_portada),
      integrantes: _personas,
      gastos: const [],
      aportes: const [],
      custodioId: _personas.first.id,
    );
    estado.crearEvento(evento);
    mostrarAviso(context, textos.eventoCreado);
    final router = GoRouter.of(context);
    if (router.canPop()) router.pop();
    router.push('/evento/$id');
  }

  String _emoji(PortadaEvento portada) {
    return switch (portada) {
      PortadaEvento.playa => '🌊',
      PortadaEvento.volcan => '🌋',
      PortadaEvento.comida => '🍽️',
      PortadaEvento.carretera => '🚗',
    };
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = context.watch<KavalState>();
    final idioma = estado.idioma;
    return Scaffold(
      backgroundColor: KavalColors.crema,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                children: [
                  BotonRedondo(icono: Icons.chevron_left, onTap: () => volver(context)),
                  Expanded(
                    child: Text(textos.nuevoEvento, textAlign: TextAlign.center, style: KavalTexto.titulo(size: 18)),
                  ),
                  const SizedBox(width: 42),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  children: [
                    EtiquetaCampo(textos.nombreEvento),
                    TextFormField(
                      controller: _nombre,
                      focusNode: _nombreFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_integranteFocus),
                      style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800),
                      decoration: decoracionCampo(),
                      validator: (valor) {
                        if ((valor?.trim() ?? '').isEmpty) return textos.nombreEventoObligatorio;
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    EtiquetaCampo(textos.portada),
                    Row(
                      children: [
                        for (final portada in PortadaEvento.values) ...[
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _portada = portada),
                              child: Column(
                                children: [
                                  Container(
                                    height: 64,
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _portada == portada ? KavalColors.coral : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: IlustracionPortada(portada: portada, alto: 64),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(_nombrePortada(textos, portada), style: KavalTexto.cuerpo(size: 11)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _fecha(textos.inicioFecha, _inicio, idioma, () => _elegirFecha(inicio: true))),
                        const SizedBox(width: 12),
                        Expanded(child: _fecha(textos.finFecha, _fin, idioma, () => _elegirFecha(inicio: false))),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: KavalColors.menta,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.attach_money, color: KavalColors.verde),
                          const SizedBox(width: 6),
                          Expanded(child: Text(textos.monedaFija, style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800))),
                          Text(textos.fija, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.verde)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(textos.integrantesCount(_personas.length), style: KavalTexto.titulo(size: 16)),
                        const Spacer(),
                        TextButton(
                          onPressed: () => context.push('/evento/$idTunco/invitar'),
                          child: Text(textos.invitarCodigo, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.coral)),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final persona in _personas)
                          InputChip(
                            avatar: avatarDe(persona, tamano: 24),
                            label: Text(
                              persona.id == estado.usuario.id ? '${persona.nombre} · ${textos.tu}' : persona.nombre,
                              style: KavalTexto.cuerpo(size: 13, color: KavalColors.marino, weight: FontWeight.w800),
                            ),
                            onDeleted: persona.id == estado.usuario.id
                                ? null
                                : () => setState(() => _personas.remove(persona)),
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: KavalColors.borde),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _integrante,
                            focusNode: _integranteFocus,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _agregar(textos),
                            decoration: decoracionCampo(
                              icono: Icons.person_outline,
                              hint: textos.agregarPorNombre,
                            ),
                            validator: (valor) {
                              final nombre = valor?.trim() ?? '';
                              if (nombre.isEmpty) return null;
                              if (nombre.length < 2) return textos.nombreCorto;
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Material(
                          color: KavalColors.coral,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () => _agregar(textos),
                            borderRadius: BorderRadius.circular(16),
                            child: const SizedBox(
                              width: 52,
                              height: 52,
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: BotonCoral(
                texto: textos.crearEvento,
                icono: const Icon(Icons.check, color: Colors.white),
                onPressed: _crear,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fecha(String etiqueta, DateTime fecha, String idioma, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EtiquetaCampo(etiqueta),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: KavalColors.borde),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: KavalColors.coral),
                  const SizedBox(width: 8),
                  Text(fechaConAnio(fecha, idioma), style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _nombrePortada(AppLocalizations textos, PortadaEvento portada) {
    return switch (portada) {
      PortadaEvento.playa => textos.playa,
      PortadaEvento.volcan => textos.volcan,
      PortadaEvento.comida => textos.categoriaComida,
      PortadaEvento.carretera => textos.roadTrip,
    };
  }
}
