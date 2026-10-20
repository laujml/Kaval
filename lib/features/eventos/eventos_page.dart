import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_medidas.dart';
import '../../core/theme/kaval_paleta.dart';
import '../../core/widgets/aviso.dart';
import '../../core/widgets/boton_coral.dart';
import '../../core/widgets/campo_kaval.dart';
import '../../core/widgets/estado_vacio.dart';
import '../../l10n/app_localizations.dart';
import '../../state/kaval_state.dart';
import 'tarjeta_evento.dart';

class EventosPage extends StatelessWidget {
  const EventosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = context.watch<KavalState>();
    final paleta = KavalPaleta.de(context);
    final activos = estado.eventosActivos;
    final vacio = activos.isEmpty;
    return Scaffold(
      body: SafeArea(
        child: MarcoKaval(
        child: ListView.builder(
          padding: KavalMedidas.pagina,
          itemCount: vacio ? 1 : activos.length + 1,
          itemBuilder: (context, indice) {
            if (indice == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(textos.eventos, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: paleta.marino)),
                  const SizedBox(height: KavalMedidas.sm),
                  BotonCoral(
                    texto: textos.nuevoEvento,
                    icono: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => context.push('/nuevo-evento'),
                  ),
                  const SizedBox(height: KavalMedidas.sm),
                  BotonBlanco(texto: textos.unirme, onPressed: () => _unirme(context)),
                  const SizedBox(height: KavalMedidas.sm),
                  BotonBlanco(
                    texto: textos.escanearCodigo,
                    icono: const Icon(Icons.qr_code_scanner, color: KavalColors.marino),
                    onPressed: () => context.push('/escanear'),
                  ),
                  const SizedBox(height: KavalMedidas.md),
                  if (vacio)
                    EstadoVacio(
                      icono: Icons.luggage_outlined,
                      titulo: estado.eventos.isEmpty ? textos.sinEventos : textos.sinEventosActivos,
                      cuerpo: estado.eventos.isEmpty ? textos.sinEventosCuerpo : textos.sinEventosActivosCuerpo,
                      accion: BotonCoral(
                        texto: estado.eventos.isEmpty ? textos.nuevoEvento : textos.verHistorial,
                        icono: Icon(estado.eventos.isEmpty ? Icons.add : Icons.history, color: Colors.white),
                        onPressed: () => estado.eventos.isEmpty ? context.push('/nuevo-evento') : context.go('/historial'),
                      ),
                    ),
                ],
              );
            }
            final evento = activos[indice - 1];
            return Padding(
              padding: const EdgeInsets.only(bottom: KavalMedidas.sm),
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
          scrollable: true,
          title: Text(textos.unirme),
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
              decoration: decoracionCampo(dialogContext, hint: textos.codigoHint),
              validator: (valor) {
                final texto = valor?.trim() ?? '';
                if (texto.length < 4) return textos.codigoInvalido;
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(textos.cancelar),
            ),
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
}
