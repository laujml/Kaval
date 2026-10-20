// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Kaval';

  @override
  String get marca => 'kaval';

  @override
  String get saltar => 'Saltar';

  @override
  String get comenzar => 'Comenzar';

  @override
  String get yaTienesCuenta => '¿Ya tienes cuenta? ';

  @override
  String get iniciaSesion => 'Inicia sesión';

  @override
  String get iniciarSesion => 'Iniciar sesión';

  @override
  String get crearCuenta => 'Crear cuenta';

  @override
  String get holaDeNuevo => '¡Hola de nuevo!';

  @override
  String get bienvenida => '¡Bienvenida a Kaval!';

  @override
  String get viajesSincronizados => 'Tus viajes y cuentas, sincronizados.';

  @override
  String get correo => 'Correo electrónico';

  @override
  String get contrasena => 'Contraseña';

  @override
  String get nombre => 'Nombre';

  @override
  String get confirmarContrasena => 'Confirmar contraseña';

  @override
  String get olvidaste => '¿Olvidaste tu contraseña?';

  @override
  String get continuaCon => 'o continúa con';

  @override
  String get sinInternet => '¿Sin internet? ';

  @override
  String get perfilLocal => 'Usar perfil local  ›';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get mostrarContrasena => 'Mostrar contraseña';

  @override
  String get ocultarContrasena => 'Ocultar contraseña';

  @override
  String get nombreObligatorio => 'El nombre es obligatorio';

  @override
  String get nombreCorto => 'El nombre debe tener al menos 2 caracteres';

  @override
  String get correoObligatorio => 'El correo es obligatorio';

  @override
  String get correoInvalido => 'Escribe un correo válido';

  @override
  String get contrasenaObligatoria => 'La contraseña es obligatoria';

  @override
  String get contrasenaCorta =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get contrasenaNumero =>
      'La contraseña debe incluir al menos un número';

  @override
  String get confirmaContrasena => 'Confirma tu contraseña';

  @override
  String get contrasenasNoCoinciden => 'Las contraseñas no coinciden';

  @override
  String get cuentaCreada => 'Cuenta creada';

  @override
  String get sesionIniciada => 'Sesión iniciada';

  @override
  String get fase2 => 'Disponible cuando conectemos las cuentas';

  @override
  String get tituloViajen => 'Viajen juntos,\ncuentas ';

  @override
  String get claras => 'claras';

  @override
  String get subtituloBienvenida =>
      'Dicta tus gastos, mira quién le debe a quién y comparte el resumen en segundos.';

  @override
  String get tituloVoz => 'Dilo en voz alta';

  @override
  String get subtituloVoz =>
      '“Pagué 24 de gasolina” y Kaval llena el gasto. Tú solo confirmas con un toque.';

  @override
  String get tituloCuentas => 'Cuentas claras al final';

  @override
  String get subtituloCuentas =>
      'Menos transferencias, el efectivo del grupo a la vista y un resumen listo para el chat.';

  @override
  String get pupusas => 'Pupusas';

  @override
  String get efectivoCinco => 'Efectivo del grupo';

  @override
  String get burbujaVoz => '“pagué 24 de gasolina”';

  @override
  String get gasolina => 'Gasolina';

  @override
  String get pagoLaura => 'Entre el grupo';

  @override
  String get inicio => 'Inicio';

  @override
  String get eventos => 'Eventos';

  @override
  String get historial => 'Historial';

  @override
  String get perfil => 'Perfil';

  @override
  String holaNombre(String nombre) {
    return 'Hola, $nombre';
  }

  @override
  String get aDonde => '¿A dónde vamos hoy?';

  @override
  String get balanceGeneral => 'Balance general';

  @override
  String teDeben(String monto) {
    return 'Te deben $monto';
  }

  @override
  String debes(String monto) {
    return 'Debes $monto';
  }

  @override
  String get todos => 'Todos';

  @override
  String get playa => 'Playa';

  @override
  String get volcan => 'Volcán';

  @override
  String get comidas => 'Comidas';

  @override
  String get roadTrip => 'Road trip';

  @override
  String get eventosActivos => 'Eventos activos';

  @override
  String get verTodos => 'Ver todos';

  @override
  String get sincronizado => 'Sincronizado';

  @override
  String get total => 'Total';

  @override
  String get tipVoz =>
      'Di el monto y el concepto. Por ejemplo: pagué 24 de gasolina.';

  @override
  String get nuevoEvento => 'Nuevo evento';

  @override
  String get nombreEvento => 'Nombre del evento';

  @override
  String get portada => 'Portada';

  @override
  String get inicioFecha => 'Inicio';

  @override
  String get finFecha => 'Fin';

  @override
  String get monedaFija => 'Moneda: USD (\$)';

  @override
  String get fija => 'Fija';

  @override
  String integrantesCount(int cantidad) {
    return 'Integrantes ($cantidad)';
  }

  @override
  String get invitarCodigo => 'Invitar con código';

  @override
  String get tu => 'Tú';

  @override
  String get agregarPorNombre => 'Agregar por nombre...';

  @override
  String get crearEvento => 'Crear evento';

  @override
  String get nombreEventoObligatorio => 'El nombre del evento es obligatorio';

  @override
  String get faltaIntegrante => 'Agrega al menos un integrante';

  @override
  String get eventoCreado => 'Evento creado';

  @override
  String get tuParte => 'Tu parte';

  @override
  String get saldosPersona => 'Saldos por persona';

  @override
  String get liquidar => 'Liquidar';

  @override
  String gastosCount(int cantidad) {
    return 'Gastos ($cantidad)';
  }

  @override
  String get masRecientes => 'Más recientes';

  @override
  String pagoPor(String nombre, int cantidad) {
    return 'Pagó $nombre · $cantidad personas';
  }

  @override
  String efectivoPersonas(int cantidad) {
    return 'Efectivo del grupo · $cantidad personas';
  }

  @override
  String get dictado => 'Dictado';

  @override
  String get efectivo => 'Efectivo';

  @override
  String get gasto => 'Gasto';

  @override
  String metaEvento(String fechas, int cantidad) {
    return '$fechas · $cantidad integrantes · USD';
  }

  @override
  String get nuevoGasto => 'Nuevo gasto';

  @override
  String get monto => 'Monto';

  @override
  String get quienPago => '¿Quién pagó?';

  @override
  String get entreQuienes => '¿Entre quiénes?';

  @override
  String get todosChip => 'Todos';

  @override
  String get ajustar => 'Ajustar';

  @override
  String get ocultarAjuste => 'Listo';

  @override
  String get tarjeta => 'Tarjeta';

  @override
  String get efectivoGrupo => 'Efectivo del grupo';

  @override
  String guardarGasto(String monto) {
    return 'Guardar gasto · $monto';
  }

  @override
  String get montoInvalido => 'Escribe un monto mayor que cero';

  @override
  String get conceptoObligatorio => 'El concepto es obligatorio';

  @override
  String get eligePagador => 'Elige quién pagó';

  @override
  String get eligeParticipantes => 'Elige al menos una persona';

  @override
  String masCuota(int cantidad, String monto) {
    return '+$cantidad más · $monto c/u';
  }

  @override
  String tuEntre(String nombre) {
    return '$nombre (tú)';
  }

  @override
  String get gastoGuardado => 'Gasto guardado';

  @override
  String get conceptoEjemplo => 'Cena';

  @override
  String get escuchando => 'Escuchando…';

  @override
  String get transcribiendo => 'Transcribiendo en tu dispositivo…';

  @override
  String get cancelar => 'Cancelar';

  @override
  String get listo => 'Listo';

  @override
  String get escribir => 'Escribir';

  @override
  String get tipDictado => 'Prueba: “pagué 18.50 de comida para el grupo”';

  @override
  String get soloTexto => 'Solo guardamos el texto, nunca el audio';

  @override
  String get fraseDictado => 'Pagué 24 dólares de gasolina por todos';

  @override
  String get ayudaVoz =>
      'Di el monto, qué fue y entre quiénes. Kaval no guarda el audio.';

  @override
  String get confirmaGasto => 'Confirma tu gasto';

  @override
  String get sinConexion => 'Sin conexión · se sincronizará al volver';

  @override
  String get detectamos => 'Detectamos esto';

  @override
  String get altaConfianza => 'Alta confianza';

  @override
  String get participantes => 'Participantes';

  @override
  String todosCantidad(int cantidad) {
    return 'Todos ($cantidad)';
  }

  @override
  String get metodo => 'Método';

  @override
  String cadaPersona(String monto) {
    return 'Cada persona paga $monto';
  }

  @override
  String get transcritoNota => 'Transcrito en el dispositivo · ¿Más precisión?';

  @override
  String get pro => 'PRO';

  @override
  String get editar => 'Editar';

  @override
  String get volverDictar => 'Volver a dictar';

  @override
  String get confirmar => 'Confirmar gasto';

  @override
  String get haceUnMomento => 'hace un momento';

  @override
  String get gastoConfirmado => 'Gasto confirmado';

  @override
  String get pagoLabel => 'Pagó';

  @override
  String get concepto => 'Concepto';

  @override
  String get liquidacion => 'Liquidación';

  @override
  String get quienPaga => '¿Quién le paga a quién?';

  @override
  String soloTransferencias(int cantidad) {
    return 'Solo $cantidad transferencias';
  }

  @override
  String lePagaA(String deudor, String acreedor) {
    return '$deudor le paga a $acreedor';
  }

  @override
  String tuLePagas(String acreedor) {
    return 'Tú le pagas a $acreedor';
  }

  @override
  String get pagar => 'Pagar';

  @override
  String efectivoSobrante(String monto) {
    return 'Efectivo sobrante: $monto';
  }

  @override
  String seDevuelven(String detalle) {
    return 'Se devuelven: $detalle';
  }

  @override
  String get compartirResumen => 'Compartir resumen';

  @override
  String eventoTotal(String evento, String monto) {
    return '$evento · Total $monto';
  }

  @override
  String get efectivoTitulo => 'Efectivo del grupo';

  @override
  String get efectivoDisponible => 'Efectivo disponible';

  @override
  String deReunidos(String monto) {
    return 'de $monto reunidos';
  }

  @override
  String quedaPorcentaje(int porcentaje) {
    return 'Queda $porcentaje%';
  }

  @override
  String gastadoMonto(String monto) {
    return 'Gastado $monto';
  }

  @override
  String loGuarda(String nombre) {
    return 'Lo guarda $nombre';
  }

  @override
  String get quienAporto => '¿Quién aportó?';

  @override
  String get aporte => '+ Aporte';

  @override
  String get pagadoEfectivo => 'Pagado en efectivo';

  @override
  String get gastoEnEfectivo => 'Gasto en efectivo';

  @override
  String delFondo(int porcentaje) {
    return '$porcentaje% del fondo';
  }

  @override
  String get retiroCajero => 'Retiro en cajero';

  @override
  String get efectivoBolsa => 'Efectivo de su bolsa';

  @override
  String personasCount(int cantidad) {
    return '$cantidad personas';
  }

  @override
  String get hoy1220 => 'Hoy · 1:20 p.m.';

  @override
  String get hoy1505 => 'Hoy · 3:05 p.m.';

  @override
  String get ayudaEfectivo =>
      'El fondo junta el efectivo del grupo. Lo gastado se acredita en proporción a quien aportó, y lo que sobra se devuelve igual.';

  @override
  String get resumenViaje => 'Resumen del viaje';

  @override
  String get vistaPrevia => 'Vista previa · imagen 1080 × 1350';

  @override
  String get totalViaje => 'Total del viaje';

  @override
  String get quienSeccion => 'QUIÉN LE PAGA A QUIÉN';

  @override
  String hechoCon(String monto) {
    return 'Hecho con Kaval · Efectivo sobrante: $monto';
  }

  @override
  String get compartirWhatsapp => 'Compartir por WhatsApp';

  @override
  String get imagen => 'Imagen';

  @override
  String get texto => 'Texto';

  @override
  String get pdf => 'PDF';

  @override
  String get resumenListo => 'Resumen listo para compartir';

  @override
  String get invitarEvento => 'Invitar al evento';

  @override
  String sumaGrupo(String evento) {
    return '¡Suma a tu grupo a $evento!';
  }

  @override
  String get conCodigo => 'Con el código se unen y ven los gastos al instante.';

  @override
  String get codigoEvento => 'CÓDIGO DEL EVENTO';

  @override
  String get copiado => 'Código copiado';

  @override
  String get expira => 'Escanéalo desde la app o comparte el código.';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get enlace => 'Enlace';

  @override
  String get porNombre => '+ Por nombre';

  @override
  String get tuAdmin => 'Tú · Admin';

  @override
  String get seUnieron => 'Se unieron con código';

  @override
  String unidos(int cantidad) {
    return '$cantidad unidos';
  }

  @override
  String get invitadoNombre => 'Invitado (solo nombre)';

  @override
  String get invitar => 'Invitar';

  @override
  String get invitacionEnviada => 'Invitación enviada';

  @override
  String get pendiente => 'Pendiente';

  @override
  String get enlaceListo => 'Enlace listo para compartir';

  @override
  String get sincronizadoHace => 'Sincronizado hace 1 min';

  @override
  String get kavalPro => 'Kaval Pro';

  @override
  String get vozNube => 'Voz en la nube';

  @override
  String get exportar => 'Exportar PDF / Excel';

  @override
  String get estadisticas => 'Estadísticas';

  @override
  String get sinAnuncios => 'Sin anuncios';

  @override
  String get probarGratis => 'Probar 7 días gratis';

  @override
  String get idioma => 'Idioma';

  @override
  String get moneda => 'Moneda';

  @override
  String get usdFijo => 'USD (\$)';

  @override
  String get sincronizarNube => 'Sincronizar en la nube';

  @override
  String get privacidad => 'Privacidad y datos';

  @override
  String get cerrarSesion => 'Cerrar sesión';

  @override
  String get eliminarCuenta => 'Eliminar cuenta';

  @override
  String get eliminarPregunta =>
      'Esto elimina tu cuenta de Kaval y no se puede deshacer.';

  @override
  String get eliminar => 'Eliminar';

  @override
  String get privacidadCuerpo =>
      'Kaval guarda el texto de lo que dictas, nunca el audio. Con una cuenta, los viajes viven en la nube y también en el teléfono. El perfil local se queda solo en este aparato.';

  @override
  String get proAviso =>
      'Kaval Pro es la visión de más adelante. Esta fase no lo cobra.';

  @override
  String get cerrar => 'Cerrar';

  @override
  String get unirme => 'Unirme con código';

  @override
  String get codigoHint => 'Código del evento';

  @override
  String get codigoInvalido => 'Ese código no coincide con un viaje';

  @override
  String get teUniste => 'Listo, entraste al viaje';

  @override
  String get sinEventos => 'Todavía no hay eventos';

  @override
  String get viajesRecientes => 'Viajes recientes';

  @override
  String get historialVacio =>
      'Cuando cierres un viaje, el resumen queda aquí.';

  @override
  String lugarFecha(String lugar, String fechas) {
    return '$lugar · $fechas';
  }

  @override
  String get categoriaComida => 'Comida';

  @override
  String get categoriaTransporte => 'Transporte';

  @override
  String get categoriaHospedaje => 'Hospedaje';

  @override
  String get categoriaDiversion => 'Diversión';

  @override
  String get aviso => 'Aviso';

  @override
  String get entendido => 'Entendido';

  @override
  String get enviando => 'Enviando…';

  @override
  String get sinConexionAviso =>
      'No hay conexión. Puedes entrar con el perfil local.';

  @override
  String get perfilLocalAccion => 'Perfil local';

  @override
  String get reintentar => 'Reintentar';

  @override
  String get seguirSinConexion => 'Seguir sin conexión';

  @override
  String get errorSinRedTitulo => 'Sin conexión';

  @override
  String get errorSinRedCuerpo =>
      'No pudimos hablar con el servidor. Revisa tu red o sigue con lo que ya tienes en el teléfono.';

  @override
  String get errorEsperaTitulo => 'Esto está tardando';

  @override
  String get errorEsperaCuerpo =>
      'El servidor no respondió a tiempo. Tus datos siguen aquí. Cuando quieras, lo intentamos otra vez.';

  @override
  String get errorSesionTitulo => 'Tu sesión venció';

  @override
  String get errorSesionCuerpo =>
      'Hay que volver a entrar para guardar este cambio.';

  @override
  String get datosRechazados =>
      'El servidor no aceptó este dato. Revísalo e inténtalo de nuevo.';

  @override
  String get tiempoAgotadoAviso =>
      'La espera se agotó. Lo que escribiste sigue en el formulario.';

  @override
  String get errorGenerico => 'No se pudo completar. Inténtalo otra vez.';

  @override
  String get gastoActualizado => 'Gasto actualizado';

  @override
  String get editarGasto => 'Editar gasto';

  @override
  String get modoPrueba => 'Modo prueba (solo debug)';

  @override
  String get modoPruebaAyuda =>
      'La próxima operación de red fallará a propósito, para mostrar cada respuesta.';

  @override
  String get forzarTimeout => 'Timeout';

  @override
  String get forzarSinRed => 'Sin red';

  @override
  String get forzar401 => '401';

  @override
  String get forzar422 => '422';

  @override
  String falloArmado(String modo) {
    return 'Listo. La próxima operación fallará: $modo.';
  }

  @override
  String get credencialesInvalidas => 'El correo o la contraseña no coinciden.';

  @override
  String get correoEnUso => 'Ese correo ya tiene una cuenta.';

  @override
  String get contrasenaDebil => 'Elige una contraseña más segura.';

  @override
  String get demasiadosIntentos =>
      'Demasiados intentos. Espera un momento y vuelve a probar.';

  @override
  String get redAuth => 'No hay conexión. Revisa tu red e inténtalo otra vez.';

  @override
  String get firebaseSinConfigurar =>
      'Falta conectar Firebase en este proyecto. Mientras tanto puedes usar el perfil local.';

  @override
  String get sesionReciente =>
      'No pudimos confirmar que eres tú. Vuelve a entrar y luego elimina la cuenta.';

  @override
  String get googleInterrumpido =>
      'Se interrumpió el inicio con Google. Inténtalo otra vez.';

  @override
  String get googleNoDisponible =>
      'Google no está disponible en este teléfono ahora.';

  @override
  String get googleMalConfigurado =>
      'Google no pudo identificar la app. Revisa que el SHA de debug esté en Firebase.';

  @override
  String get reautenticarTitulo => 'Confirma que eres tú';

  @override
  String get reautenticarCuerpo =>
      'Escribe tu contraseña para eliminar la cuenta.';

  @override
  String get cuentaDesactivada => 'Esta cuenta está desactivada.';

  @override
  String get operacionNoPermitida =>
      'Esa forma de entrar no está activada en Firebase.';

  @override
  String get errorAuth => 'No se pudo completar el acceso. Inténtalo otra vez.';

  @override
  String get recuperarTitulo => 'Recuperar contraseña';

  @override
  String get enviarEnlace => 'Enviar enlace';

  @override
  String get correoEnviado =>
      'Te enviamos un enlace para elegir una contraseña nueva.';

  @override
  String get agregarInvitado => 'Agregar por nombre';

  @override
  String get nombreInvitado => 'Nombre de quien no tiene cuenta';

  @override
  String get invitadoAgregado => 'Listo. Esa persona queda solo con su nombre.';

  @override
  String get vozPermiso =>
      'Kaval necesita el micrófono para dictar el gasto. Actívalo en los ajustes del teléfono.';

  @override
  String get vozSinRed =>
      'No hay conexión para reconocer la voz. Puedes escribir el gasto.';

  @override
  String get vozNoEntendida =>
      'No entendimos la frase. Di el monto y el concepto, por ejemplo: pagué 25 dólares de pupusas.';

  @override
  String get vozNoDisponible =>
      'Este teléfono no puede dictar ahora. Escribe el gasto.';

  @override
  String get vozRevisa => 'Revisa el monto y el concepto antes de guardar.';

  @override
  String vozOido(String frase) {
    return 'Oímos: “$frase”';
  }

  @override
  String get escanearCodigo => 'Escanear código';

  @override
  String get camaraPermiso =>
      'Kaval necesita la cámara para leer el código QR. Actívala en los ajustes del teléfono.';

  @override
  String get qrInvalido => 'Ese QR no tiene un código de viaje.';

  @override
  String get apuntaQr => 'Apunta al código QR del viaje';

  @override
  String qrEtiqueta(String codigo) {
    return 'Código QR $codigo';
  }

  @override
  String mensajeInvitacion(String evento, String codigo) {
    return 'Únete a $evento en Kaval. Código: $codigo';
  }

  @override
  String mensajeResumen(
    String evento,
    String total,
    String pagos,
    String sobrante,
  ) {
    return '$evento\nTotal: $total\n$pagos\nEfectivo del grupo sobrante: $sobrante';
  }

  @override
  String get nadieDebe => 'Nadie le debe a nadie.';

  @override
  String get compartirFallo => 'No se pudo abrir el menú para compartir.';

  @override
  String get sinEventosCuerpo =>
      'Crea un viaje para empezar a anotar los gastos.';

  @override
  String get sinEventosFiltro => 'Todavía no hay eventos en esta categoría';

  @override
  String get sinGastos => 'Todavía no hay gastos';

  @override
  String get sinGastosCuerpo => 'Agrega el primero a mano o dictándolo.';

  @override
  String get sinIntegrantes => 'Todavía no hay integrantes';

  @override
  String get sinIntegrantesCuerpo =>
      'Agrega a alguien por nombre o con el código de invitación.';

  @override
  String get elegirFecha => 'Elegir fecha';

  @override
  String get fechasObligatorias => 'Elige la fecha de inicio y la de fin';

  @override
  String get fechaFinAnterior => 'El fin no puede ser anterior al inicio';

  @override
  String get copiar => 'Copiar';

  @override
  String get compartir => 'Compartir';

  @override
  String get ayudaCodigo =>
      'Agrega personas por nombre. Cuando el evento exista, también puedes invitar con el código.';

  @override
  String get nombreLocal => 'Invitado';

  @override
  String get partesIguales => 'Iguales';

  @override
  String get montosExactos => 'Montos';

  @override
  String get porConsumo => 'Ítems';

  @override
  String get ayudaPagador =>
      'Elige quién pagó. Si salió del fondo, usa Efectivo del grupo.';

  @override
  String get ayudaIguales => 'Todos entran. Quita a quien no participó.';

  @override
  String get ayudaMontos =>
      'Escribe lo de cada persona. La suma tiene que ser el total.';

  @override
  String get ayudaConsumo =>
      'Agrega ítems y asígnalos. Si son varias personas, se divide igual.';

  @override
  String get agregarItem => 'Agregar ítem';

  @override
  String get nombreItem => 'Qué fue';

  @override
  String get precioItem => 'Precio';

  @override
  String get cantidadItem => 'Cantidad';

  @override
  String get propina => 'Propina %';

  @override
  String get extras => 'Extras';

  @override
  String get quitarItem => 'Quitar ítem';

  @override
  String faltan(String monto) {
    return 'Faltan $monto';
  }

  @override
  String sobran(String monto) {
    return 'Sobran $monto';
  }

  @override
  String get sumaCuadra => 'La suma coincide con el total';

  @override
  String get sumaNoCuadra => 'La suma no coincide con el total';

  @override
  String get sinItems => 'Agrega al menos un ítem con precio';

  @override
  String get itemSinPersona => 'Asigna cada ítem a alguien';

  @override
  String get itemIncompleto => 'Completa el nombre, el precio y la cantidad';

  @override
  String resumenPagasteIgual(String total, String nombres, String cuota) {
    return 'Pagaste $total. $nombres te deben $cuota c/u';
  }

  @override
  String resumenOtroIgual(
    String nombre,
    String total,
    String nombres,
    String cuota,
  ) {
    return '$nombre pagó $total. $nombres le deben $cuota c/u';
  }

  @override
  String resumenEfectivoIgual(String cuota) {
    return 'Sale del efectivo del grupo: $cuota c/u';
  }

  @override
  String resumenPagasteVarios(String total, String detalle) {
    return 'Pagaste $total. $detalle';
  }

  @override
  String resumenOtroVarios(String nombre, String total, String detalle) {
    return '$nombre pagó $total. $detalle';
  }

  @override
  String resumenEfectivoVarios(String detalle) {
    return 'Sale del efectivo del grupo: $detalle';
  }

  @override
  String resumenSoloTu(String total) {
    return 'Pagaste $total.';
  }

  @override
  String resumenOtroSolo(String nombre, String total) {
    return '$nombre pagó $total.';
  }

  @override
  String get conjuncion => 'y';

  @override
  String get sinEventosActivos => 'No hay eventos activos';

  @override
  String get sinEventosActivosCuerpo =>
      'Un viaje futuro o en curso aparece aquí. Los que ya terminaron están en el historial.';

  @override
  String get verHistorial => 'Ver historial';

  @override
  String totalConsumo(String monto) {
    return 'Total $monto';
  }

  @override
  String get propinaInvalida => 'La propina va de 0 a 100';

  @override
  String fondoSinCubrir(String monto) {
    return 'Efectivo del grupo: $monto. No se cobra entre personas.';
  }

  @override
  String get saldosPendientes => 'Hay saldos pendientes.';
}
