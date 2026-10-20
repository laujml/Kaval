import '../../l10n/app_localizations.dart';
import '../../models/evento.dart';
import '../liquidacion/liquidacion.dart';
import '../utils/dinero.dart';

/// Texto plano del resumen para la hoja de compartir.
String textoResumen(AppLocalizations textos, Evento evento, ResultadoLiquidacion resultado) {
  final pagos = saldosEnCero(resultado.saldos)
      ? textos.nadieDebe
      : resultado.transferencias.isEmpty
          ? textos.saldosPendientes
          : resultado.transferencias
          .map((pago) {
            final de = evento.integrante(pago.deudorId)?.nombre ?? '';
            final a = evento.integrante(pago.acreedorId)?.nombre ?? '';
            return '$de → $a ${usd(pago.montoCentavos)}';
          })
          .join('\n');
  return textos.mensajeResumen(evento.nombre, usd(resultado.totalGastos), pagos, usd(resultado.sobrante));
}
