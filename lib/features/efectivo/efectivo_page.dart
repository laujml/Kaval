import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/theme/kaval_theme.dart';
import '../../core/utils/dinero.dart';
import '../../core/utils/etiquetas.dart';
import '../../core/utils/fechas.dart';
import '../../core/widgets/aviso.dart';
import '../../core/widgets/boton_coral.dart';
import '../../core/widgets/campo_kaval.dart';
import '../../core/widgets/ilustraciones.dart';
import '../../core/widgets/kaval_avatar.dart';
import '../../core/widgets/logo_kaval.dart';
import '../../core/widgets/tarjeta_kaval.dart';
import '../../l10n/app_localizations.dart';
import '../../models/aporte_efectivo.dart';
import '../../models/gasto.dart';
import '../../state/kaval_state.dart';

class EfectivoPage extends StatelessWidget {
  const EfectivoPage({super.key, required this.eventoId});

  final String eventoId;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = context.watch<KavalState>();
    final evento = estado.buscar(eventoId);
    if (evento == null) return Scaffold(body: Center(child: Text(textos.sinEventos)));
    final resultado = estado.liquidacionDe(eventoId)!;
    final custodio = evento.integrante(evento.custodioId);
    final porcentaje = resultado.reunido == 0 ? 0 : ((resultado.sobrante * 100) / resultado.reunido).round();
    final enEfectivo = evento.gastos.where((g) => g.esEfectivoGrupo).toList();

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
                  Expanded(child: Text(textos.efectivoTitulo, textAlign: TextAlign.center, style: KavalTexto.titulo(size: 18))),
                  BotonRedondo(icono: Icons.help_outline, onTap: () => mostrarAviso(context, textos.ayudaEfectivo)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: KavalColors.menta, borderRadius: BorderRadius.circular(28)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const ExcludeSemantics(child: Icon(Icons.payments_outlined, color: KavalColors.verde, size: 18)),
                                      const SizedBox(width: 6),
                                      Text(textos.efectivoTitulo, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.verde)),
                                    ],
                                  ),
                                  Text(textos.efectivoDisponible, style: KavalTexto.cuerpo()),
                                  Text(usd(resultado.sobrante), style: KavalTexto.titulo(size: 36)),
                                  Text(textos.deReunidos(usd(resultado.reunido)), style: KavalTexto.cuerpo()),
                                ],
                              ),
                            ),
                            IlustracionBilletera(semanticsLabel: textos.efectivoTitulo),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: resultado.reunido == 0 ? 0 : resultado.sobrante / resultado.reunido,
                            minHeight: 8,
                            backgroundColor: Colors.white,
                            color: KavalColors.verde,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(textos.quedaPorcentaje(porcentaje), style: KavalTexto.cuerpo(size: 12, weight: FontWeight.w800, color: KavalColors.marino)),
                            const Spacer(),
                            Text(textos.gastadoMonto(usd(resultado.gastadoEfectivo)), style: KavalTexto.cuerpo(size: 12)),
                          ],
                        ),
                        if (custodio != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              avatarDe(custodio, tamano: 28),
                              const SizedBox(width: 8),
                              Text(textos.loGuarda(custodio.nombre), style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(textos.quienAporto, style: KavalTexto.titulo(size: 18)),
                      const Spacer(),
                      TextButton(
                        key: const ValueKey('aporte-cabecera'),
                        onPressed: () => _registrarAporte(context, eventoId),
                        child: Text(textos.aporte, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.coral)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (final aporte in evento.aportes)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TarjetaKaval(
                        radio: 18,
                        child: Row(
                          children: [
                            avatarDe(evento.integrante(aporte.integranteId)!, tamano: 40),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(evento.integrante(aporte.integranteId)!.nombre, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.marino)),
                                  Text(textoAporte(textos, aporte.descripcion), style: KavalTexto.cuerpo(size: 12)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(usd(aporte.montoCentavos), style: KavalTexto.titulo(size: 16)),
                                Text(
                                  textos.delFondo(resultado.reunido == 0 ? 0 : ((aporte.montoCentavos * 100) / resultado.reunido).round()),
                                  style: KavalTexto.cuerpo(size: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(textos.pagadoEfectivo, style: KavalTexto.titulo(size: 18)),
                      const Spacer(),
                      Text(usd(resultado.gastadoEfectivo), style: KavalTexto.cuerpo()),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (final gasto in enEfectivo) _GastoEfectivo(gasto: gasto, idioma: estado.idioma),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: BotonBlanco(
                      texto: textos.aporte,
                      onPressed: () => _registrarAporte(context, eventoId),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: BotonCoral(
                      texto: textos.gastoEnEfectivo,
                      onPressed: () => context.push('/evento/$eventoId/gasto'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Hoja para registrar dinero que alguien pone en el fondo del grupo.
Future<void> _registrarAporte(BuildContext context, String eventoId) async {
  final textos = AppLocalizations.of(context);
  final guardado = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: KavalColors.crema,
    builder: (_) => TemaClaro(child: _FormularioAporte(eventoId: eventoId)),
  );
  if (guardado == true && context.mounted) mostrarAviso(context, textos.aporteGuardado);
}

class _FormularioAporte extends StatefulWidget {
  const _FormularioAporte({required this.eventoId});

  final String eventoId;

  @override
  State<_FormularioAporte> createState() => _FormularioAporteState();
}

class _FormularioAporteState extends State<_FormularioAporte> {
  final _formKey = GlobalKey<FormState>();
  final _monto = TextEditingController();
  final _descripcion = TextEditingController();
  String? _integranteId;

  @override
  void initState() {
    super.initState();
    final estado = context.read<KavalState>();
    final ids = [for (final persona in estado.buscar(widget.eventoId)?.integrantes ?? const []) persona.id];
    _integranteId = ids.contains(estado.usuario.id) ? estado.usuario.id : (ids.isEmpty ? null : ids.first);
  }

  @override
  void dispose() {
    _monto.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  void _guardar() {
    final integranteId = _integranteId;
    if (!_formKey.currentState!.validate() || integranteId == null) return;
    context.read<KavalState>().agregarAporte(
          widget.eventoId,
          AporteEfectivo(
            id: 'aporte-${DateTime.now().microsecondsSinceEpoch}',
            integranteId: integranteId,
            montoCentavos: centavosDesdeTexto(_monto.text)!,
            descripcion: _descripcion.text.trim(),
            fecha: DateTime.now(),
          ),
        );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final evento = context.watch<KavalState>().buscar(widget.eventoId);
    if (evento == null) return const SizedBox.shrink();
    final estiloCampo = KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + MediaQuery.viewInsetsOf(context).bottom),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(textos.nuevoAporte, style: KavalTexto.titulo(size: 18)),
              const SizedBox(height: 12),
              EtiquetaCampo(textos.quienAporto),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final persona in evento.integrantes)
                    ChoiceChip(
                      key: ValueKey('aporte-integrante-${persona.id}'),
                      avatar: avatarDe(persona, tamano: 24),
                      label: Text(persona.nombre),
                      selected: _integranteId == persona.id,
                      selectedColor: KavalColors.durazno,
                      checkmarkColor: KavalColors.coral,
                      onSelected: (_) => setState(() => _integranteId = persona.id),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              EtiquetaCampo(textos.monto),
              TextFormField(
                key: const ValueKey('aporte-monto'),
                controller: _monto,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                style: estiloCampo,
                decoration: decoracionCampo(context, icono: Icons.attach_money, hint: '0.00'),
                validator: (valor) {
                  final centavos = centavosDesdeTexto(valor ?? '');
                  if (centavos == null || centavos <= 0) return textos.montoInvalido;
                  return null;
                },
              ),
              const SizedBox(height: 12),
              EtiquetaCampo(textos.descripcionAporte),
              TextFormField(
                key: const ValueKey('aporte-descripcion'),
                controller: _descripcion,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _guardar(),
                style: estiloCampo,
                decoration: decoracionCampo(context, hint: textos.descripcionAporteHint),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: BotonBlanco(texto: textos.cancelar, onPressed: () => Navigator.of(context).pop(false))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: BotonCoral(key: const ValueKey('aporte-guardar'), texto: textos.guardarAporte, onPressed: _guardar),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GastoEfectivo extends StatelessWidget {
  const _GastoEfectivo({required this.gasto, required this.idioma});

  final Gasto gasto;
  final String idioma;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TarjetaKaval(
        radio: 18,
        child: Row(
          children: [
            IconoCategoria(
              categoria: gasto.categoria,
              tamano: 28,
              color: KavalColors.coral,
              etiqueta: nombreCategoria(textos, gasto.categoria),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(gasto.concepto, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.marino)),
                  Text(
                    '${textos.personasCount(gasto.participanteIds.length)} · ${fechaConAnio(gasto.fecha, idioma)}',
                    style: KavalTexto.cuerpo(size: 12),
                  ),
                ],
              ),
            ),
            Text(usd(gasto.montoCentavos), style: KavalTexto.titulo(size: 16)),
          ],
        ),
      ),
    );
  }
}
