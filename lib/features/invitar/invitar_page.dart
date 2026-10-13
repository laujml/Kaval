import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/compartir/compartir_texto.dart';

import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/widgets/aviso.dart';
import '../../core/widgets/boton_coral.dart';
import '../../core/widgets/kaval_avatar.dart';
import '../../core/widgets/logo_kaval.dart';
import '../../core/widgets/campo_kaval.dart';
import '../../l10n/app_localizations.dart';
import '../../models/integrante.dart';
import '../../state/kaval_state.dart';

class InvitarPage extends StatelessWidget {
  const InvitarPage({super.key, required this.eventoId});

  final String eventoId;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = context.watch<KavalState>();
    final evento = estado.buscar(eventoId);
    if (evento == null) return Scaffold(body: Center(child: Text(textos.sinEventos)));
    final unidos = evento.integrantes.where((p) => p.estado == EstadoUnion.unido).length;

    return Scaffold(
      backgroundColor: KavalColors.crema,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                BotonRedondo(icono: Icons.chevron_left, onTap: () => volver(context)),
                Expanded(child: Text(textos.invitarEvento, textAlign: TextAlign.center, style: KavalTexto.titulo(size: 18))),
                const SizedBox(width: 42),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(colors: [KavalColors.durazno, Colors.white]),
              ),
              child: Column(
                children: [
                  const Icon(Icons.send_rounded, color: KavalColors.coral, size: 42),
                  const SizedBox(height: 8),
                  Text(textos.sumaGrupo(evento.nombre), textAlign: TextAlign.center, style: KavalTexto.titulo(size: 20)),
                  Text(textos.conCodigo, textAlign: TextAlign.center, style: KavalTexto.cuerpo()),
                  const SizedBox(height: 12),
                  Text(textos.codigoEvento, style: KavalTexto.cuerpo(size: 11, weight: FontWeight.w800)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(evento.codigo, style: KavalTexto.titulo(size: 28)),
                      IconButton(
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: evento.codigo));
                          if (context.mounted) mostrarAviso(context, textos.copiado);
                        },
                        icon: const Icon(Icons.copy_rounded, color: KavalColors.coral),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _CodigoQr(codigo: evento.codigo, etiqueta: textos.qrEtiqueta(evento.codigo)),
                  const SizedBox(height: 8),
                  Text(textos.expira, textAlign: TextAlign.center, style: KavalTexto.cuerpo(size: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () => unawaited(
                            compartirTexto(context, textos.mensajeInvitacion(evento.nombre, evento.codigo)),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: KavalColors.whatsapp,
                            minimumSize: const Size(48, 48),
                          ),
                          child: Text(textos.whatsapp),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: BotonBlanco(
                          texto: textos.enlace,
                          onPressed: () => unawaited(
                            compartirTexto(context, textos.mensajeInvitacion(evento.nombre, evento.codigo)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(textos.integrantesCount(evento.integrantes.length), style: KavalTexto.titulo(size: 16)),
                const Spacer(),
                Text(textos.porNombre, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.coral)),
              ],
            ),
            const SizedBox(height: 8),
            for (final persona in evento.integrantes)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: avatarDe(persona, tamano: 40),
                title: Text(persona.nombre, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.marino)),
                subtitle: Text(_detalle(textos, persona, estado.usuario.id), style: KavalTexto.cuerpo(size: 12)),
                trailing: _estado(textos, persona, unidos),
              ),
            const SizedBox(height: 8),
            _AgregarPorNombre(eventoId: eventoId),
          ],
        ),
      ),
    );
  }

  String _detalle(AppLocalizations textos, Integrante persona, String usuarioId) {
    if (persona.id == usuarioId || persona.estado == EstadoUnion.admin) return textos.tuAdmin;
    return switch (persona.estado) {
      EstadoUnion.unido => textos.seUnieron,
      EstadoUnion.soloNombre => textos.invitadoNombre,
      EstadoUnion.pendiente => textos.invitacionEnviada,
      EstadoUnion.admin => textos.tuAdmin,
    };
  }

  Widget _estado(AppLocalizations textos, Integrante persona, int unidos) {
    return switch (persona.estado) {
      EstadoUnion.unido || EstadoUnion.admin => Text(
          persona.estado == EstadoUnion.admin ? '' : textos.unidos(unidos),
          style: KavalTexto.cuerpo(size: 12, weight: FontWeight.w800, color: KavalColors.verde),
        ),
      EstadoUnion.soloNombre => Text(textos.invitar, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.coral)),
      EstadoUnion.pendiente => Text(textos.pendiente, style: KavalTexto.cuerpo(size: 12, color: KavalColors.gris)),
    };
  }
}

class _CodigoQr extends StatelessWidget {
  const _CodigoQr({required this.codigo, required this.etiqueta});

  final String codigo;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: etiqueta,
      child: LayoutBuilder(
        builder: (context, limites) {
          final lado = limites.maxWidth.clamp(140.0, 220.0);
          return ColoredBox(
            color: Colors.white,
            child: QrImageView(
              data: codigo,
              size: lado,
              backgroundColor: Colors.white,
              semanticsLabel: etiqueta,
              eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: KavalColors.marino),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: KavalColors.marino,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AgregarPorNombre extends StatefulWidget {
  const _AgregarPorNombre({required this.eventoId});

  final String eventoId;

  @override
  State<_AgregarPorNombre> createState() => _AgregarPorNombreState();
}

class _AgregarPorNombreState extends State<_AgregarPorNombre> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _foco = FocusNode();

  @override
  void dispose() {
    _nombre.dispose();
    _foco.dispose();
    super.dispose();
  }

  void _agregar() {
    final textos = AppLocalizations.of(context);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<KavalState>().agregarIntegrante(
          widget.eventoId,
          Integrante(
            id: 'invitado-${DateTime.now().microsecondsSinceEpoch}',
            nombre: _nombre.text.trim(),
            colorFondo: 0xFFFFE8C2,
            colorInicial: 0xFFE0A100,
            estado: EstadoUnion.soloNombre,
          ),
        );
    _nombre.clear();
    mostrarAviso(context, textos.invitadoAgregado);
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(textos.agregarInvitado, style: KavalTexto.titulo(size: 16)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nombre,
            focusNode: _foco,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _agregar(),
            decoration: decoracionCampo(hint: textos.nombreInvitado),
            validator: (valor) {
              final texto = valor?.trim() ?? '';
              if (texto.length < 2) return textos.nombreCorto;
              return null;
            },
          ),
          const SizedBox(height: 8),
          BotonCoral(texto: textos.agregarInvitado, onPressed: _agregar),
        ],
      ),
    );
  }
}
