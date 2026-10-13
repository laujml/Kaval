import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/widgets/aviso.dart';
import '../../core/widgets/boton_coral.dart';
import '../../core/widgets/campo_kaval.dart';
import '../../l10n/app_localizations.dart';
import '../../state/kaval_state.dart';
import 'tarjeta_evento.dart';

class EventosPage extends StatelessWidget {
  const EventosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = context.watch<KavalState>();
    return Scaffold(
      backgroundColor: KavalColors.crema,
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          itemCount: estado.eventos.length + 1,
          itemBuilder: (context, indice) {
            if (indice == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(textos.eventos, style: KavalTexto.titulo(size: 28)),
                  const SizedBox(height: 12),
                  BotonCoral(
                    texto: textos.nuevoEvento,
                    icono: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => context.push('/nuevo-evento'),
                  ),
                  const SizedBox(height: 10),
                  BotonBlanco(texto: textos.unirme, onPressed: () => _unirme(context)),
                  const SizedBox(height: 10),
                  BotonBlanco(texto: textos.escanearCodigo, onPressed: () => context.push('/escanear')),
                  const SizedBox(height: 10),
                  BotonBlanco(texto: textos.cargarTunco, onPressed: () => _cargarTunco(context)),
                  const SizedBox(height: 16),
                ],
              );
            }
            final evento = estado.eventos[indice - 1];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TarjetaEvento(
                evento: evento,
                saldoCentavos: estado.saldoEn(evento),
                idioma: estado.idioma,
                onTap: () => context.push('/evento/${evento.id}'),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _unirme(BuildContext context) async {
    final textos = AppLocalizations.of(context);
    final codigo = TextEditingController();
    final foco = FocusNode();
    final formKey = GlobalKey<FormState>();
    final unio = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: KavalColors.crema,
          title: Text(textos.unirme, style: KavalTexto.titulo(size: 18)),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: codigo,
              focusNode: foco,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                if (formKey.currentState!.validate()) {
                  Navigator.of(dialogContext).pop(true);
                }
              },
              decoration: decoracionCampo(hint: textos.codigoHint),
              validator: (valor) {
                final texto = valor?.trim() ?? '';
                if (texto.length < 4) return textos.codigoInvalido;
                return null;
              },
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(textos.cancelar)),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) Navigator.pop(dialogContext, true);
              },
              child: Text(textos.listo),
            ),
          ],
        );
      },
    );
    final escrito = codigo.text;
    codigo.dispose();
    foco.dispose();
    if (!context.mounted || unio != true) return;
    final evento = await context.read<KavalState>().unirse(escrito);
    if (!context.mounted) return;
    if (evento == null) {
      mostrarAviso(context, textos.codigoInvalido);
      return;
    }
    mostrarAviso(context, textos.teUniste);
    context.push('/evento/${evento.id}');
  }

  Future<void> _cargarTunco(BuildContext context) async {
    final textos = AppLocalizations.of(context);
    try {
      await context.read<KavalState>().cargarEjemploTunco();
      if (!context.mounted) return;
      mostrarAviso(context, textos.tuncoCargado);
    } catch (error) {
      debugPrint('[kaval] no se pudo cargar Tunco: $error');
      if (!context.mounted) return;
      mostrarAviso(context, textos.errorGenerico);
    }
  }
}
