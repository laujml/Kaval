import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/liquidacion/liquidacion.dart';
import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/utils/dinero.dart';
import '../../core/utils/etiquetas.dart';
import '../../core/widgets/aviso.dart';
import '../../core/widgets/boton_coral.dart';
import '../../core/widgets/kaval_avatar.dart';
import '../../core/widgets/logo_kaval.dart';
import '../../core/widgets/tarjeta_kaval.dart';
import '../../l10n/app_localizations.dart';
import '../../state/kaval_state.dart';

class ConfirmarGastoPage extends StatelessWidget {
  const ConfirmarGastoPage({super.key, required this.eventoId});

  final String eventoId;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = context.watch<KavalState>();
    final evento = estado.buscar(eventoId);
    if (evento == null) return Scaffold(body: Center(child: Text(textos.sinEventos)));
    final borrador = estado.borrador;
    final partes = repartirCentavos(borrador.montoCentavos, borrador.participanteIds);
    final cuota = partes.isEmpty ? 0 : partes.values.first;
    final pagador = borrador.pagadorId == null ? null : evento.integrante(borrador.pagadorId!);

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
                  Expanded(child: Text(textos.confirmaGasto, textAlign: TextAlign.center, style: KavalTexto.titulo(size: 18))),
                  const SizedBox(width: 42),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: KavalColors.aviso, borderRadius: BorderRadius.circular(16)),
                    child: Text(textos.sinConexion, style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 12),
                  TarjetaKaval(
                    radio: 20,
                    child: Row(
                      children: [
                        const CircleAvatar(backgroundColor: KavalColors.coral, child: Icon(Icons.mic, color: Colors.white, size: 18)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '“${estado.fraseOida.trim().isEmpty ? borrador.concepto : estado.fraseOida.trim()}” · ${pagador?.nombre ?? textos.tu} · ${textos.haceUnMomento}',
                            style: KavalTexto.cuerpo(color: KavalColors.marino),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TarjetaKaval(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: KavalColors.coral, size: 18),
                            const SizedBox(width: 6),
                            Text(textos.detectamos, style: KavalTexto.titulo(size: 16)),
                            const Spacer(),
                            Text(textos.altaConfianza, style: KavalTexto.cuerpo(size: 12, weight: FontWeight.w800, color: KavalColors.verde)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(textos.monto, style: KavalTexto.cuerpo(size: 12)),
                        Text(usd(borrador.montoCentavos), style: KavalTexto.titulo(size: 28)),
                        const Divider(),
                        Text('${textos.concepto}: ${borrador.concepto}', style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800)),
                        Row(
                          children: [
                            IconoCategoria(
                              categoria: borrador.categoria,
                              tamano: 16,
                              color: KavalColors.coral,
                              etiqueta: nombreCategoria(textos, borrador.categoria),
                            ),
                            const SizedBox(width: 6),
                            Text(nombreCategoria(textos, borrador.categoria), style: KavalTexto.cuerpo(size: 12)),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Text('${textos.pagoLabel}: ', style: KavalTexto.cuerpo()),
                            if (pagador != null) avatarDe(pagador, tamano: 28),
                            const SizedBox(width: 6),
                            Text(pagador == null ? textos.efectivoGrupo : etiquetaIntegrante(textos, pagador, estado.usuario.id), style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('${textos.participantes}: ${textos.todosCantidad(borrador.participanteIds.length)}', style: KavalTexto.cuerpo(color: KavalColors.marino)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.credit_card, size: 16, color: KavalColors.marino),
                            const SizedBox(width: 6),
                            Text('${textos.metodo}: ${textos.tarjeta}', style: KavalTexto.cuerpo(color: KavalColors.marino)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: KavalColors.menta, borderRadius: BorderRadius.circular(16)),
                    child: Text(textos.cadaPersona(usd(cuota)), style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 8),
                  Text('${textos.transcritoNota}  ${textos.pro}', style: KavalTexto.cuerpo(size: 12)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: BotonBlanco(
                          texto: textos.editar,
                          onPressed: () => context.push('/evento/$eventoId/gasto?voz=1'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: BotonBlanco(texto: textos.volverDictar, onPressed: () => volver(context))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  BotonCoral(
                    texto: textos.confirmar,
                    icono: const Icon(Icons.check, color: Colors.white),
                    onPressed: () {
                      estado.confirmarBorrador(eventoId);
                      mostrarAviso(context, textos.gastoConfirmado);
                      context.go('/evento/$eventoId');
                    },
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
