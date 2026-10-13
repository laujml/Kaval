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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
            const SizedBox(height: 16),
            for (final evento in estado.eventos) ...[
              TarjetaEvento(
                evento: evento,
                saldoCentavos: estado.saldoEn(evento),
                idioma: estado.idioma,
                onTap: () => context.push('/evento/${evento.id}'),
              ),
              const SizedBox(height: 12),
            ],
          ],
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
                if (texto.isEmpty) return textos.codigoInvalido;
                final existe = context.read<KavalState>().porCodigo(texto);
                if (existe == null) return textos.codigoInvalido;
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
    final evento = context.read<KavalState>().porCodigo(escrito);
    if (evento == null) return;
    mostrarAviso(context, textos.teUniste);
    context.push('/evento/${evento.id}');
  }
}
