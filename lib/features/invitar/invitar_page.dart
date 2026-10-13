import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/widgets/aviso.dart';
import '../../core/widgets/boton_coral.dart';
import '../../core/widgets/kaval_avatar.dart';
import '../../core/widgets/logo_kaval.dart';
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
                  const _QrFalso(),
                  const SizedBox(height: 8),
                  Text(textos.expira, textAlign: TextAlign.center, style: KavalTexto.cuerpo(size: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () => mostrarAviso(context, textos.enlaceListo),
                          style: FilledButton.styleFrom(backgroundColor: KavalColors.whatsapp),
                          child: Text(textos.whatsapp),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: BotonBlanco(texto: textos.enlace, onPressed: () => mostrarAviso(context, textos.enlaceListo))),
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

class _QrFalso extends StatelessWidget {
  const _QrFalso();

  @override
  Widget build(BuildContext context) {
    const celdas = [
      '1110111',
      '1000101',
      '1011101',
      '1000001',
      '1110111',
      '0001000',
      '1111111',
    ];
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Column(
        children: [
          for (final fila in celdas)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final celda in fila.split(''))
                  Container(
                    width: 10,
                    height: 10,
                    color: celda == '1' ? KavalColors.marino : Colors.white,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
