// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kaval';

  @override
  String get marca => 'kaval';

  @override
  String get saltar => 'Skip';

  @override
  String get comenzar => 'Get started';

  @override
  String get yaTienesCuenta => 'Already have an account? ';

  @override
  String get iniciaSesion => 'Sign in';

  @override
  String get iniciarSesion => 'Sign in';

  @override
  String get crearCuenta => 'Create account';

  @override
  String get holaDeNuevo => 'Welcome back! 👋';

  @override
  String get bienvenida => 'Welcome to Kaval! 👋';

  @override
  String get viajesSincronizados => 'Your trips and balances, synced.';

  @override
  String get correo => 'Email';

  @override
  String get contrasena => 'Password';

  @override
  String get nombre => 'Name';

  @override
  String get confirmarContrasena => 'Confirm password';

  @override
  String get olvidaste => 'Forgot your password?';

  @override
  String get continuaCon => 'or continue with';

  @override
  String get sinInternet => 'No internet? ';

  @override
  String get perfilLocal => 'Use local profile  ›';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get mostrarContrasena => 'Show password';

  @override
  String get ocultarContrasena => 'Hide password';

  @override
  String get nombreObligatorio => 'Name is required';

  @override
  String get nombreCorto => 'Name must be at least 2 characters';

  @override
  String get correoObligatorio => 'Email is required';

  @override
  String get correoInvalido => 'Enter a valid email';

  @override
  String get contrasenaObligatoria => 'Password is required';

  @override
  String get contrasenaCorta => 'Password must be at least 8 characters';

  @override
  String get contrasenaNumero => 'Password must include at least one number';

  @override
  String get confirmaContrasena => 'Confirm your password';

  @override
  String get contrasenasNoCoinciden => 'Passwords do not match';

  @override
  String get cuentaCreada => 'Account created ✅';

  @override
  String get sesionIniciada => 'Signed in';

  @override
  String get fase2 => 'Available once accounts are connected';

  @override
  String get tituloViajen => 'Travel together,\nclear ';

  @override
  String get claras => 'balances';

  @override
  String get subtituloBienvenida =>
      'Say your expenses, see who owes whom, and share the summary in seconds.';

  @override
  String get tituloVoz => 'Just say it';

  @override
  String get subtituloVoz =>
      '“I paid 24 for gas” and Kaval fills the expense. You only confirm with one tap.';

  @override
  String get tituloCuentas => 'Clear balances at the end';

  @override
  String get subtituloCuentas =>
      'Fewer transfers, group cash in sight, and a summary ready for the group chat.';

  @override
  String get pupusas => 'Pupusas';

  @override
  String get efectivoCinco => 'Cash · 5 people';

  @override
  String get burbujaVoz => '“I paid 24 for gas”';

  @override
  String get gasolina => 'Gas';

  @override
  String get pagoLaura => 'Laura paid · 6 people';

  @override
  String get inicio => 'Home';

  @override
  String get eventos => 'Events';

  @override
  String get historial => 'History';

  @override
  String get perfil => 'Profile';

  @override
  String holaNombre(String nombre) {
    return 'Hi, $nombre 👋';
  }

  @override
  String get aDonde => 'Where are we going today?';

  @override
  String get balanceGeneral => 'Overall balance';

  @override
  String teDeben(String monto) {
    return 'You\'re owed $monto';
  }

  @override
  String debes(String monto) {
    return 'You owe $monto';
  }

  @override
  String get todos => 'All';

  @override
  String get playa => 'Beach';

  @override
  String get volcan => 'Volcano';

  @override
  String get comidas => 'Food';

  @override
  String get roadTrip => 'Road trip';

  @override
  String get eventosActivos => 'Active events';

  @override
  String get verTodos => 'See all';

  @override
  String get sincronizado => 'Synced';

  @override
  String get total => 'Total';

  @override
  String get tipVoz => 'Tip: just say “I paid 24 for gas”';

  @override
  String get nuevoEvento => 'New event';

  @override
  String get nombreEvento => 'Event name';

  @override
  String get portada => 'Cover';

  @override
  String get inicioFecha => 'Start';

  @override
  String get finFecha => 'End';

  @override
  String get monedaFija => 'Currency: USD (\$)';

  @override
  String get fija => 'Fixed';

  @override
  String integrantesCount(int cantidad) {
    return 'Members ($cantidad)';
  }

  @override
  String get invitarCodigo => 'Invite with a code';

  @override
  String get tu => 'You';

  @override
  String get agregarPorNombre => 'Add by name...';

  @override
  String get crearEvento => 'Create event';

  @override
  String get nombreEventoObligatorio => 'Event name is required';

  @override
  String get faltaIntegrante => 'Add at least one member';

  @override
  String get eventoCreado => 'Event created';

  @override
  String get tuParte => 'Your share';

  @override
  String get saldosPersona => 'Balances';

  @override
  String get liquidar => 'Settle';

  @override
  String gastosCount(int cantidad) {
    return 'Expenses ($cantidad)';
  }

  @override
  String get masRecientes => 'Most recent';

  @override
  String pagoPor(String nombre, int cantidad) {
    return '$nombre paid · $cantidad people';
  }

  @override
  String efectivoPersonas(int cantidad) {
    return 'Group cash · $cantidad people';
  }

  @override
  String get dictado => 'Dictated';

  @override
  String get efectivo => 'Cash';

  @override
  String get gasto => 'Expense';

  @override
  String metaEvento(String fechas, int cantidad) {
    return '$fechas · $cantidad members · USD';
  }

  @override
  String get nuevoGasto => 'New expense';

  @override
  String get monto => 'Amount';

  @override
  String get quienPago => 'Who paid?';

  @override
  String get entreQuienes => 'Split between?';

  @override
  String get todosChip => 'Everyone';

  @override
  String get ajustar => 'Adjust';

  @override
  String get ocultarAjuste => 'Done';

  @override
  String get tarjeta => 'Card';

  @override
  String get efectivoGrupo => 'Group cash';

  @override
  String guardarGasto(String monto) {
    return 'Save expense · $monto';
  }

  @override
  String get montoInvalido => 'Enter an amount greater than zero';

  @override
  String get conceptoObligatorio => 'Description is required';

  @override
  String get eligePagador => 'Choose who paid';

  @override
  String get eligeParticipantes => 'Choose at least one person';

  @override
  String masCuota(int cantidad, String monto) {
    return '+$cantidad more · $monto each';
  }

  @override
  String tuEntre(String nombre) {
    return '$nombre (you)';
  }

  @override
  String get gastoGuardado => 'Expense saved';

  @override
  String get conceptoEjemplo => 'Seafood dinner 🦐';

  @override
  String get escuchando => 'Listening…';

  @override
  String get transcribiendo => 'Transcribing on your device…';

  @override
  String get cancelar => 'Cancel';

  @override
  String get listo => 'Done';

  @override
  String get escribir => 'Type';

  @override
  String get tipDictado =>
      'Try: “Ana paid 18.50 for pupusas, everyone except Carla”';

  @override
  String get soloTexto => 'We only store the text, never the audio';

  @override
  String get fraseDictado => 'I paid 24 dollars for gas for everyone';

  @override
  String get ayudaVoz =>
      'Say the amount, what it was, and who splits it. Kaval does not keep the audio.';

  @override
  String get confirmaGasto => 'Confirm your expense';

  @override
  String get sinConexion => 'Offline · it will sync when you\'re back';

  @override
  String get detectamos => 'We detected this';

  @override
  String get altaConfianza => 'High confidence';

  @override
  String get participantes => 'Participants';

  @override
  String todosCantidad(int cantidad) {
    return 'Everyone ($cantidad)';
  }

  @override
  String get metodo => 'Method';

  @override
  String cadaPersona(String monto) {
    return 'Each person pays $monto';
  }

  @override
  String get transcritoNota => 'Transcribed on device · More accuracy?';

  @override
  String get pro => 'PRO';

  @override
  String get editar => 'Edit';

  @override
  String get volverDictar => 'Dictate again';

  @override
  String get confirmar => 'Confirm expense';

  @override
  String get haceUnMomento => 'just now';

  @override
  String get gastoConfirmado => 'Expense confirmed';

  @override
  String get pagoLabel => 'Paid by';

  @override
  String get concepto => 'Description';

  @override
  String get liquidacion => 'Settle up';

  @override
  String get quienPaga => 'Who pays whom?';

  @override
  String soloTransferencias(int cantidad) {
    return 'Only $cantidad transfers';
  }

  @override
  String lePagaA(String deudor, String acreedor) {
    return '$deudor pays $acreedor';
  }

  @override
  String tuLePagas(String acreedor) {
    return 'You pay $acreedor';
  }

  @override
  String get pagar => 'Pay';

  @override
  String efectivoSobrante(String monto) {
    return 'Cash left: $monto';
  }

  @override
  String seDevuelven(String detalle) {
    return 'Returned: $detalle';
  }

  @override
  String get compartirResumen => 'Share summary';

  @override
  String eventoTotal(String evento, String monto) {
    return '$evento · Total $monto';
  }

  @override
  String get efectivoTitulo => 'Group cash';

  @override
  String get efectivoDisponible => 'Cash available';

  @override
  String deReunidos(String monto) {
    return 'of $monto collected';
  }

  @override
  String quedaPorcentaje(int porcentaje) {
    return '$porcentaje% left';
  }

  @override
  String gastadoMonto(String monto) {
    return 'Spent $monto';
  }

  @override
  String loGuarda(String nombre) {
    return '$nombre is holding it';
  }

  @override
  String get quienAporto => 'Who contributed?';

  @override
  String get aporte => '+ Add';

  @override
  String get pagadoEfectivo => 'Paid in cash';

  @override
  String get gastoEnEfectivo => 'Cash expense';

  @override
  String delFondo(int porcentaje) {
    return '$porcentaje% of the fund';
  }

  @override
  String get retiroCajero => 'ATM withdrawal';

  @override
  String get efectivoBolsa => 'Cash from their wallet';

  @override
  String personasCount(int cantidad) {
    return '$cantidad people';
  }

  @override
  String get hoy1220 => 'Today · 1:20 p.m.';

  @override
  String get hoy1505 => 'Today · 3:05 p.m.';

  @override
  String get ayudaEfectivo =>
      'The fund holds the group\'s cash. What gets spent is credited in proportion to who put money in, and the rest is returned the same way.';

  @override
  String get resumenViaje => 'Trip summary';

  @override
  String get vistaPrevia => 'Preview · image 1080 × 1350';

  @override
  String get totalViaje => 'Trip total';

  @override
  String get quienSeccion => 'WHO PAYS WHOM';

  @override
  String hechoCon(String monto) {
    return 'Made with Kaval · Cash left: $monto';
  }

  @override
  String get compartirWhatsapp => 'Share on WhatsApp';

  @override
  String get imagen => 'Image';

  @override
  String get texto => 'Text';

  @override
  String get pdf => 'PDF';

  @override
  String get resumenListo => 'Summary ready to share';

  @override
  String get invitarEvento => 'Invite to the event';

  @override
  String sumaGrupo(String evento) {
    return 'Add your group to $evento!';
  }

  @override
  String get conCodigo =>
      'With the code they join and see the expenses right away.';

  @override
  String get codigoEvento => 'EVENT CODE';

  @override
  String get copiado => 'Code copied';

  @override
  String get expira => 'Scan it in the app or share the code.';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get enlace => 'Link';

  @override
  String get porNombre => '+ By name';

  @override
  String get tuAdmin => 'You · Admin';

  @override
  String get seUnieron => 'Joined with the code';

  @override
  String unidos(int cantidad) {
    return '$cantidad joined';
  }

  @override
  String get invitadoNombre => 'Guest (name only)';

  @override
  String get invitar => 'Invite';

  @override
  String get invitacionEnviada => 'Invite sent';

  @override
  String get pendiente => 'Pending';

  @override
  String get enlaceListo => 'Link ready to share';

  @override
  String get sincronizadoHace => 'Synced 1 min ago';

  @override
  String get kavalPro => 'Kaval Pro';

  @override
  String get vozNube => 'Cloud voice';

  @override
  String get exportar => 'Export PDF / Excel';

  @override
  String get estadisticas => 'Statistics';

  @override
  String get sinAnuncios => 'No ads';

  @override
  String get probarGratis => 'Try 7 days free';

  @override
  String get idioma => 'Language';

  @override
  String get moneda => 'Currency';

  @override
  String get usdFijo => 'USD (\$)';

  @override
  String get sincronizarNube => 'Sync to the cloud';

  @override
  String get privacidad => 'Privacy and data';

  @override
  String get cerrarSesion => 'Sign out';

  @override
  String get eliminarCuenta => 'Delete account';

  @override
  String get eliminarPregunta =>
      'This deletes your Kaval account and cannot be undone.';

  @override
  String get eliminar => 'Delete';

  @override
  String get privacidadCuerpo =>
      'Kaval stores the text you dictate, never the audio. With an account, trips live in the cloud and on this phone. The local profile stays on this device only.';

  @override
  String get proAviso =>
      'Kaval Pro is the later vision. This phase does not charge for it.';

  @override
  String get cerrar => 'Close';

  @override
  String get unirme => 'Join with a code';

  @override
  String get codigoHint => 'Event code';

  @override
  String get codigoInvalido => 'That code does not match a trip';

  @override
  String get teUniste => 'You\'re in the trip';

  @override
  String get sinEventos => 'No events in this category yet';

  @override
  String get viajesRecientes => 'Recent trips';

  @override
  String get historialVacio => 'When a trip ends, the summary stays here.';

  @override
  String lugarFecha(String lugar, String fechas) {
    return '$lugar · $fechas';
  }

  @override
  String get categoriaComida => 'Food';

  @override
  String get categoriaTransporte => 'Transport';

  @override
  String get categoriaHospedaje => 'Lodging';

  @override
  String get categoriaDiversion => 'Fun';

  @override
  String get aviso => 'Notice';

  @override
  String get entendido => 'Got it';

  @override
  String get enviando => 'Sending…';

  @override
  String get sinConexionAviso =>
      'No connection. You can continue with the local profile.';

  @override
  String get perfilLocalAccion => 'Local profile';

  @override
  String get reintentar => 'Retry';

  @override
  String get seguirSinConexion => 'Continue offline';

  @override
  String get errorSinRedTitulo => 'You\'re offline';

  @override
  String get errorSinRedCuerpo =>
      'We couldn\'t reach the server. Check your network, or keep going with what\'s already on this phone.';

  @override
  String get errorEsperaTitulo => 'This is taking a while';

  @override
  String get errorEsperaCuerpo =>
      'The server didn\'t answer in time. What you typed is still here. Try again whenever you want.';

  @override
  String get errorSesionTitulo => 'Your session expired';

  @override
  String get errorSesionCuerpo => 'Sign in again to save this change.';

  @override
  String get datosRechazados =>
      'The server didn\'t accept this. Check it and try again.';

  @override
  String get tiempoAgotadoAviso =>
      'The wait timed out. What you typed is still in the form.';

  @override
  String get errorGenerico => 'That didn\'t go through. Please try again.';

  @override
  String get gastoActualizado => 'Expense updated';

  @override
  String get editarGasto => 'Edit expense';

  @override
  String get modoPrueba => 'Test mode (debug only)';

  @override
  String get modoPruebaAyuda =>
      'The next network call will fail on purpose, so each response can be shown.';

  @override
  String get forzarTimeout => 'Timeout';

  @override
  String get forzarSinRed => 'Offline';

  @override
  String get forzar401 => '401';

  @override
  String get forzar422 => '422';

  @override
  String falloArmado(String modo) {
    return 'Ready. The next operation will fail: $modo.';
  }

  @override
  String get credencialesInvalidas => 'That email or password doesn\'t match.';

  @override
  String get correoEnUso => 'That email already has an account.';

  @override
  String get contrasenaDebil => 'Choose a stronger password.';

  @override
  String get demasiadosIntentos =>
      'Too many attempts. Wait a moment and try again.';

  @override
  String get redAuth => 'You\'re offline. Check your network and try again.';

  @override
  String get firebaseSinConfigurar =>
      'Firebase isn\'t connected in this project yet. You can still use the local profile.';

  @override
  String get sesionReciente =>
      'We couldn\'t confirm it\'s you. Sign in again and then delete the account.';

  @override
  String get googleInterrumpido =>
      'Google sign-in was interrupted. Please try again.';

  @override
  String get googleNoDisponible =>
      'Google isn\'t available on this phone right now.';

  @override
  String get googleMalConfigurado =>
      'Google couldn\'t identify the app. Check that the debug SHA is in Firebase.';

  @override
  String get reautenticarTitulo => 'Confirm it\'s you';

  @override
  String get reautenticarCuerpo => 'Enter your password to delete the account.';

  @override
  String get cuentaDesactivada => 'This account is disabled.';

  @override
  String get operacionNoPermitida =>
      'That sign-in method isn\'t enabled in Firebase.';

  @override
  String get errorAuth => 'Sign-in didn\'t go through. Please try again.';

  @override
  String get recuperarTitulo => 'Reset password';

  @override
  String get enviarEnlace => 'Send link';

  @override
  String get correoEnviado =>
      'We sent a link so you can choose a new password.';

  @override
  String get cargarTunco => 'Load the Playa El Tunco example';

  @override
  String get tuncoCargado => 'Playa El Tunco is loaded';

  @override
  String get agregarInvitado => 'Add by name';

  @override
  String get nombreInvitado => 'Name of someone without an account';

  @override
  String get invitadoAgregado => 'Done. That person is saved with just a name.';

  @override
  String get vozPermiso =>
      'Kaval needs the microphone to dictate an expense. Turn it on in the phone settings.';

  @override
  String get vozSinRed =>
      'There\'s no connection to recognize speech. You can type the expense.';

  @override
  String get vozNoEntendida =>
      'We didn\'t catch that. Say the amount and what it was, for example: I paid 25 dollars for pupusas.';

  @override
  String get vozNoDisponible =>
      'This phone can\'t dictate right now. Type the expense.';

  @override
  String get vozRevisa => 'Check the amount and the description before saving.';

  @override
  String vozOido(String frase) {
    return 'We heard: “$frase”';
  }

  @override
  String get escanearCodigo => 'Scan code';

  @override
  String get camaraPermiso =>
      'Kaval needs the camera to read a trip QR code. Turn it on in the phone settings.';

  @override
  String get qrInvalido => 'That QR doesn\'t have a trip code.';

  @override
  String get apuntaQr => 'Point at the trip QR code';

  @override
  String qrEtiqueta(String codigo) {
    return 'QR code $codigo';
  }

  @override
  String mensajeInvitacion(String evento, String codigo) {
    return 'Join $evento on Kaval. Code: $codigo';
  }

  @override
  String mensajeResumen(
    String evento,
    String total,
    String pagos,
    String sobrante,
  ) {
    return '$evento\nTotal: $total\n$pagos\nGroup cash left: $sobrante';
  }

  @override
  String get nadieDebe => 'Nobody owes anyone.';

  @override
  String get compartirFallo => 'The share sheet couldn\'t open.';
}
