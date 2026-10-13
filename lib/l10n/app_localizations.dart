import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Kaval'**
  String get appTitle;

  /// No description provided for @marca.
  ///
  /// In es, this message translates to:
  /// **'kaval'**
  String get marca;

  /// No description provided for @saltar.
  ///
  /// In es, this message translates to:
  /// **'Saltar'**
  String get saltar;

  /// No description provided for @comenzar.
  ///
  /// In es, this message translates to:
  /// **'Comenzar'**
  String get comenzar;

  /// No description provided for @yaTienesCuenta.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta? '**
  String get yaTienesCuenta;

  /// No description provided for @iniciaSesion.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión'**
  String get iniciaSesion;

  /// No description provided for @iniciarSesion.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get iniciarSesion;

  /// No description provided for @crearCuenta.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get crearCuenta;

  /// No description provided for @holaDeNuevo.
  ///
  /// In es, this message translates to:
  /// **'¡Hola de nuevo! 👋'**
  String get holaDeNuevo;

  /// No description provided for @bienvenida.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenida a Kaval! 👋'**
  String get bienvenida;

  /// No description provided for @viajesSincronizados.
  ///
  /// In es, this message translates to:
  /// **'Tus viajes y cuentas, sincronizados.'**
  String get viajesSincronizados;

  /// No description provided for @correo.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get correo;

  /// No description provided for @contrasena.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get contrasena;

  /// No description provided for @nombre.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get nombre;

  /// No description provided for @confirmarContrasena.
  ///
  /// In es, this message translates to:
  /// **'Confirmar contraseña'**
  String get confirmarContrasena;

  /// No description provided for @olvidaste.
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get olvidaste;

  /// No description provided for @continuaCon.
  ///
  /// In es, this message translates to:
  /// **'o continúa con'**
  String get continuaCon;

  /// No description provided for @sinInternet.
  ///
  /// In es, this message translates to:
  /// **'¿Sin internet? '**
  String get sinInternet;

  /// No description provided for @perfilLocal.
  ///
  /// In es, this message translates to:
  /// **'Usar perfil local  ›'**
  String get perfilLocal;

  /// No description provided for @google.
  ///
  /// In es, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @apple.
  ///
  /// In es, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @mostrarContrasena.
  ///
  /// In es, this message translates to:
  /// **'Mostrar contraseña'**
  String get mostrarContrasena;

  /// No description provided for @ocultarContrasena.
  ///
  /// In es, this message translates to:
  /// **'Ocultar contraseña'**
  String get ocultarContrasena;

  /// No description provided for @nombreObligatorio.
  ///
  /// In es, this message translates to:
  /// **'El nombre es obligatorio'**
  String get nombreObligatorio;

  /// No description provided for @nombreCorto.
  ///
  /// In es, this message translates to:
  /// **'El nombre debe tener al menos 2 caracteres'**
  String get nombreCorto;

  /// No description provided for @correoObligatorio.
  ///
  /// In es, this message translates to:
  /// **'El correo es obligatorio'**
  String get correoObligatorio;

  /// No description provided for @correoInvalido.
  ///
  /// In es, this message translates to:
  /// **'Escribe un correo válido'**
  String get correoInvalido;

  /// No description provided for @contrasenaObligatoria.
  ///
  /// In es, this message translates to:
  /// **'La contraseña es obligatoria'**
  String get contrasenaObligatoria;

  /// No description provided for @contrasenaCorta.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 8 caracteres'**
  String get contrasenaCorta;

  /// No description provided for @contrasenaNumero.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe incluir al menos un número'**
  String get contrasenaNumero;

  /// No description provided for @confirmaContrasena.
  ///
  /// In es, this message translates to:
  /// **'Confirma tu contraseña'**
  String get confirmaContrasena;

  /// No description provided for @contrasenasNoCoinciden.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get contrasenasNoCoinciden;

  /// No description provided for @cuentaCreada.
  ///
  /// In es, this message translates to:
  /// **'Cuenta creada ✅'**
  String get cuentaCreada;

  /// No description provided for @sesionIniciada.
  ///
  /// In es, this message translates to:
  /// **'Sesión iniciada'**
  String get sesionIniciada;

  /// No description provided for @fase2.
  ///
  /// In es, this message translates to:
  /// **'Disponible cuando conectemos las cuentas'**
  String get fase2;

  /// No description provided for @tituloViajen.
  ///
  /// In es, this message translates to:
  /// **'Viajen juntos,\ncuentas '**
  String get tituloViajen;

  /// No description provided for @claras.
  ///
  /// In es, this message translates to:
  /// **'claras'**
  String get claras;

  /// No description provided for @subtituloBienvenida.
  ///
  /// In es, this message translates to:
  /// **'Dicta tus gastos, mira quién le debe a quién y comparte el resumen en segundos.'**
  String get subtituloBienvenida;

  /// No description provided for @tituloVoz.
  ///
  /// In es, this message translates to:
  /// **'Dilo en voz alta'**
  String get tituloVoz;

  /// No description provided for @subtituloVoz.
  ///
  /// In es, this message translates to:
  /// **'“Pagué 24 de gasolina” y Kaval llena el gasto. Tú solo confirmas con un toque.'**
  String get subtituloVoz;

  /// No description provided for @tituloCuentas.
  ///
  /// In es, this message translates to:
  /// **'Cuentas claras al final'**
  String get tituloCuentas;

  /// No description provided for @subtituloCuentas.
  ///
  /// In es, this message translates to:
  /// **'Menos transferencias, el efectivo del grupo a la vista y un resumen listo para el chat.'**
  String get subtituloCuentas;

  /// No description provided for @pupusas.
  ///
  /// In es, this message translates to:
  /// **'Pupusas'**
  String get pupusas;

  /// No description provided for @efectivoCinco.
  ///
  /// In es, this message translates to:
  /// **'Efectivo · 5 personas'**
  String get efectivoCinco;

  /// No description provided for @burbujaVoz.
  ///
  /// In es, this message translates to:
  /// **'“pagué 24 de gasolina”'**
  String get burbujaVoz;

  /// No description provided for @gasolina.
  ///
  /// In es, this message translates to:
  /// **'Gasolina'**
  String get gasolina;

  /// No description provided for @pagoLaura.
  ///
  /// In es, this message translates to:
  /// **'Pagó Laura · 6 personas'**
  String get pagoLaura;

  /// No description provided for @inicio.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get inicio;

  /// No description provided for @eventos.
  ///
  /// In es, this message translates to:
  /// **'Eventos'**
  String get eventos;

  /// No description provided for @historial.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get historial;

  /// No description provided for @perfil.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get perfil;

  /// No description provided for @holaNombre.
  ///
  /// In es, this message translates to:
  /// **'Hola, {nombre} 👋'**
  String holaNombre(String nombre);

  /// No description provided for @aDonde.
  ///
  /// In es, this message translates to:
  /// **'¿A dónde vamos hoy?'**
  String get aDonde;

  /// No description provided for @balanceGeneral.
  ///
  /// In es, this message translates to:
  /// **'Balance general'**
  String get balanceGeneral;

  /// No description provided for @teDeben.
  ///
  /// In es, this message translates to:
  /// **'Te deben {monto}'**
  String teDeben(String monto);

  /// No description provided for @debes.
  ///
  /// In es, this message translates to:
  /// **'Debes {monto}'**
  String debes(String monto);

  /// No description provided for @todos.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get todos;

  /// No description provided for @playa.
  ///
  /// In es, this message translates to:
  /// **'Playa'**
  String get playa;

  /// No description provided for @volcan.
  ///
  /// In es, this message translates to:
  /// **'Volcán'**
  String get volcan;

  /// No description provided for @comidas.
  ///
  /// In es, this message translates to:
  /// **'Comidas'**
  String get comidas;

  /// No description provided for @roadTrip.
  ///
  /// In es, this message translates to:
  /// **'Road trip'**
  String get roadTrip;

  /// No description provided for @eventosActivos.
  ///
  /// In es, this message translates to:
  /// **'Eventos activos'**
  String get eventosActivos;

  /// No description provided for @verTodos.
  ///
  /// In es, this message translates to:
  /// **'Ver todos'**
  String get verTodos;

  /// No description provided for @sincronizado.
  ///
  /// In es, this message translates to:
  /// **'Sincronizado'**
  String get sincronizado;

  /// No description provided for @total.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @tipVoz.
  ///
  /// In es, this message translates to:
  /// **'Tip: solo di “pagué 24 de gasolina”'**
  String get tipVoz;

  /// No description provided for @nuevoEvento.
  ///
  /// In es, this message translates to:
  /// **'Nuevo evento'**
  String get nuevoEvento;

  /// No description provided for @nombreEvento.
  ///
  /// In es, this message translates to:
  /// **'Nombre del evento'**
  String get nombreEvento;

  /// No description provided for @portada.
  ///
  /// In es, this message translates to:
  /// **'Portada'**
  String get portada;

  /// No description provided for @inicioFecha.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get inicioFecha;

  /// No description provided for @finFecha.
  ///
  /// In es, this message translates to:
  /// **'Fin'**
  String get finFecha;

  /// No description provided for @monedaFija.
  ///
  /// In es, this message translates to:
  /// **'Moneda: USD (\$)'**
  String get monedaFija;

  /// No description provided for @fija.
  ///
  /// In es, this message translates to:
  /// **'Fija'**
  String get fija;

  /// No description provided for @integrantesCount.
  ///
  /// In es, this message translates to:
  /// **'Integrantes ({cantidad})'**
  String integrantesCount(int cantidad);

  /// No description provided for @invitarCodigo.
  ///
  /// In es, this message translates to:
  /// **'Invitar con código'**
  String get invitarCodigo;

  /// No description provided for @tu.
  ///
  /// In es, this message translates to:
  /// **'Tú'**
  String get tu;

  /// No description provided for @agregarPorNombre.
  ///
  /// In es, this message translates to:
  /// **'Agregar por nombre...'**
  String get agregarPorNombre;

  /// No description provided for @crearEvento.
  ///
  /// In es, this message translates to:
  /// **'Crear evento'**
  String get crearEvento;

  /// No description provided for @nombreEventoObligatorio.
  ///
  /// In es, this message translates to:
  /// **'El nombre del evento es obligatorio'**
  String get nombreEventoObligatorio;

  /// No description provided for @faltaIntegrante.
  ///
  /// In es, this message translates to:
  /// **'Agrega al menos un integrante'**
  String get faltaIntegrante;

  /// No description provided for @eventoCreado.
  ///
  /// In es, this message translates to:
  /// **'Evento creado'**
  String get eventoCreado;

  /// No description provided for @tuParte.
  ///
  /// In es, this message translates to:
  /// **'Tu parte'**
  String get tuParte;

  /// No description provided for @saldosPersona.
  ///
  /// In es, this message translates to:
  /// **'Saldos por persona'**
  String get saldosPersona;

  /// No description provided for @liquidar.
  ///
  /// In es, this message translates to:
  /// **'Liquidar'**
  String get liquidar;

  /// No description provided for @gastosCount.
  ///
  /// In es, this message translates to:
  /// **'Gastos ({cantidad})'**
  String gastosCount(int cantidad);

  /// No description provided for @masRecientes.
  ///
  /// In es, this message translates to:
  /// **'Más recientes'**
  String get masRecientes;

  /// No description provided for @pagoPor.
  ///
  /// In es, this message translates to:
  /// **'Pagó {nombre} · {cantidad} personas'**
  String pagoPor(String nombre, int cantidad);

  /// No description provided for @efectivoPersonas.
  ///
  /// In es, this message translates to:
  /// **'Efectivo del grupo · {cantidad} personas'**
  String efectivoPersonas(int cantidad);

  /// No description provided for @dictado.
  ///
  /// In es, this message translates to:
  /// **'Dictado'**
  String get dictado;

  /// No description provided for @efectivo.
  ///
  /// In es, this message translates to:
  /// **'Efectivo'**
  String get efectivo;

  /// No description provided for @gasto.
  ///
  /// In es, this message translates to:
  /// **'Gasto'**
  String get gasto;

  /// No description provided for @metaEvento.
  ///
  /// In es, this message translates to:
  /// **'{fechas} · {cantidad} integrantes · USD'**
  String metaEvento(String fechas, int cantidad);

  /// No description provided for @nuevoGasto.
  ///
  /// In es, this message translates to:
  /// **'Nuevo gasto'**
  String get nuevoGasto;

  /// No description provided for @monto.
  ///
  /// In es, this message translates to:
  /// **'Monto'**
  String get monto;

  /// No description provided for @quienPago.
  ///
  /// In es, this message translates to:
  /// **'¿Quién pagó?'**
  String get quienPago;

  /// No description provided for @entreQuienes.
  ///
  /// In es, this message translates to:
  /// **'¿Entre quiénes?'**
  String get entreQuienes;

  /// No description provided for @todosChip.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get todosChip;

  /// No description provided for @ajustar.
  ///
  /// In es, this message translates to:
  /// **'Ajustar'**
  String get ajustar;

  /// No description provided for @ocultarAjuste.
  ///
  /// In es, this message translates to:
  /// **'Listo'**
  String get ocultarAjuste;

  /// No description provided for @tarjeta.
  ///
  /// In es, this message translates to:
  /// **'Tarjeta'**
  String get tarjeta;

  /// No description provided for @efectivoGrupo.
  ///
  /// In es, this message translates to:
  /// **'Efectivo del grupo'**
  String get efectivoGrupo;

  /// No description provided for @guardarGasto.
  ///
  /// In es, this message translates to:
  /// **'Guardar gasto · {monto}'**
  String guardarGasto(String monto);

  /// No description provided for @montoInvalido.
  ///
  /// In es, this message translates to:
  /// **'Escribe un monto mayor que cero'**
  String get montoInvalido;

  /// No description provided for @conceptoObligatorio.
  ///
  /// In es, this message translates to:
  /// **'El concepto es obligatorio'**
  String get conceptoObligatorio;

  /// No description provided for @eligePagador.
  ///
  /// In es, this message translates to:
  /// **'Elige quién pagó'**
  String get eligePagador;

  /// No description provided for @eligeParticipantes.
  ///
  /// In es, this message translates to:
  /// **'Elige al menos una persona'**
  String get eligeParticipantes;

  /// No description provided for @masCuota.
  ///
  /// In es, this message translates to:
  /// **'+{cantidad} más · {monto} c/u'**
  String masCuota(int cantidad, String monto);

  /// No description provided for @tuEntre.
  ///
  /// In es, this message translates to:
  /// **'{nombre} (tú)'**
  String tuEntre(String nombre);

  /// No description provided for @gastoGuardado.
  ///
  /// In es, this message translates to:
  /// **'Gasto guardado'**
  String get gastoGuardado;

  /// No description provided for @conceptoEjemplo.
  ///
  /// In es, this message translates to:
  /// **'Cena de mariscos 🦐'**
  String get conceptoEjemplo;

  /// No description provided for @escuchando.
  ///
  /// In es, this message translates to:
  /// **'ESCUCHANDO · 0:04'**
  String get escuchando;

  /// No description provided for @transcribiendo.
  ///
  /// In es, this message translates to:
  /// **'Transcribiendo en tu dispositivo…'**
  String get transcribiendo;

  /// No description provided for @cancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelar;

  /// No description provided for @listo.
  ///
  /// In es, this message translates to:
  /// **'Listo'**
  String get listo;

  /// No description provided for @escribir.
  ///
  /// In es, this message translates to:
  /// **'Escribir'**
  String get escribir;

  /// No description provided for @tipDictado.
  ///
  /// In es, this message translates to:
  /// **'Prueba: “Ana pagó 18.50 de pupusas para todos menos Carla”'**
  String get tipDictado;

  /// No description provided for @soloTexto.
  ///
  /// In es, this message translates to:
  /// **'Solo guardamos el texto, nunca el audio'**
  String get soloTexto;

  /// No description provided for @fraseDictado.
  ///
  /// In es, this message translates to:
  /// **'Pagué 24 dólares de gasolina por todos'**
  String get fraseDictado;

  /// No description provided for @ayudaVoz.
  ///
  /// In es, this message translates to:
  /// **'Di el monto, qué fue y entre quiénes. Kaval no guarda el audio.'**
  String get ayudaVoz;

  /// No description provided for @confirmaGasto.
  ///
  /// In es, this message translates to:
  /// **'Confirma tu gasto'**
  String get confirmaGasto;

  /// No description provided for @sinConexion.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión · se sincronizará al volver'**
  String get sinConexion;

  /// No description provided for @detectamos.
  ///
  /// In es, this message translates to:
  /// **'Detectamos esto'**
  String get detectamos;

  /// No description provided for @altaConfianza.
  ///
  /// In es, this message translates to:
  /// **'Alta confianza'**
  String get altaConfianza;

  /// No description provided for @participantes.
  ///
  /// In es, this message translates to:
  /// **'Participantes'**
  String get participantes;

  /// No description provided for @todosCantidad.
  ///
  /// In es, this message translates to:
  /// **'Todos ({cantidad})'**
  String todosCantidad(int cantidad);

  /// No description provided for @metodo.
  ///
  /// In es, this message translates to:
  /// **'Método'**
  String get metodo;

  /// No description provided for @cadaPersona.
  ///
  /// In es, this message translates to:
  /// **'Cada persona paga {monto}'**
  String cadaPersona(String monto);

  /// No description provided for @transcritoNota.
  ///
  /// In es, this message translates to:
  /// **'Transcrito en el dispositivo · ¿Más precisión?'**
  String get transcritoNota;

  /// No description provided for @pro.
  ///
  /// In es, this message translates to:
  /// **'PRO'**
  String get pro;

  /// No description provided for @editar.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get editar;

  /// No description provided for @volverDictar.
  ///
  /// In es, this message translates to:
  /// **'Volver a dictar'**
  String get volverDictar;

  /// No description provided for @confirmar.
  ///
  /// In es, this message translates to:
  /// **'Confirmar gasto'**
  String get confirmar;

  /// No description provided for @haceUnMomento.
  ///
  /// In es, this message translates to:
  /// **'hace un momento'**
  String get haceUnMomento;

  /// No description provided for @gastoConfirmado.
  ///
  /// In es, this message translates to:
  /// **'Gasto confirmado'**
  String get gastoConfirmado;

  /// No description provided for @pagoLabel.
  ///
  /// In es, this message translates to:
  /// **'Pagó'**
  String get pagoLabel;

  /// No description provided for @concepto.
  ///
  /// In es, this message translates to:
  /// **'Concepto'**
  String get concepto;

  /// No description provided for @liquidacion.
  ///
  /// In es, this message translates to:
  /// **'Liquidación'**
  String get liquidacion;

  /// No description provided for @quienPaga.
  ///
  /// In es, this message translates to:
  /// **'¿Quién le paga a quién?'**
  String get quienPaga;

  /// No description provided for @soloTransferencias.
  ///
  /// In es, this message translates to:
  /// **'Solo {cantidad} transferencias'**
  String soloTransferencias(int cantidad);

  /// No description provided for @lePagaA.
  ///
  /// In es, this message translates to:
  /// **'{deudor} le paga a {acreedor}'**
  String lePagaA(String deudor, String acreedor);

  /// No description provided for @tuLePagas.
  ///
  /// In es, this message translates to:
  /// **'Tú le pagas a {acreedor}'**
  String tuLePagas(String acreedor);

  /// No description provided for @pagar.
  ///
  /// In es, this message translates to:
  /// **'Pagar'**
  String get pagar;

  /// No description provided for @efectivoSobrante.
  ///
  /// In es, this message translates to:
  /// **'Efectivo sobrante: {monto}'**
  String efectivoSobrante(String monto);

  /// No description provided for @seDevuelven.
  ///
  /// In es, this message translates to:
  /// **'Se devuelven: {detalle}'**
  String seDevuelven(String detalle);

  /// No description provided for @compartirResumen.
  ///
  /// In es, this message translates to:
  /// **'Compartir resumen'**
  String get compartirResumen;

  /// No description provided for @eventoTotal.
  ///
  /// In es, this message translates to:
  /// **'{evento} · Total {monto}'**
  String eventoTotal(String evento, String monto);

  /// No description provided for @efectivoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Efectivo del grupo'**
  String get efectivoTitulo;

  /// No description provided for @efectivoDisponible.
  ///
  /// In es, this message translates to:
  /// **'Efectivo disponible'**
  String get efectivoDisponible;

  /// No description provided for @deReunidos.
  ///
  /// In es, this message translates to:
  /// **'de {monto} reunidos'**
  String deReunidos(String monto);

  /// No description provided for @quedaPorcentaje.
  ///
  /// In es, this message translates to:
  /// **'Queda {porcentaje}%'**
  String quedaPorcentaje(int porcentaje);

  /// No description provided for @gastadoMonto.
  ///
  /// In es, this message translates to:
  /// **'Gastado {monto}'**
  String gastadoMonto(String monto);

  /// No description provided for @loGuarda.
  ///
  /// In es, this message translates to:
  /// **'Lo guarda {nombre}'**
  String loGuarda(String nombre);

  /// No description provided for @quienAporto.
  ///
  /// In es, this message translates to:
  /// **'¿Quién aportó?'**
  String get quienAporto;

  /// No description provided for @aporte.
  ///
  /// In es, this message translates to:
  /// **'+ Aporte'**
  String get aporte;

  /// No description provided for @pagadoEfectivo.
  ///
  /// In es, this message translates to:
  /// **'Pagado en efectivo'**
  String get pagadoEfectivo;

  /// No description provided for @gastoEnEfectivo.
  ///
  /// In es, this message translates to:
  /// **'Gasto en efectivo'**
  String get gastoEnEfectivo;

  /// No description provided for @delFondo.
  ///
  /// In es, this message translates to:
  /// **'{porcentaje}% del fondo'**
  String delFondo(int porcentaje);

  /// No description provided for @retiroCajero.
  ///
  /// In es, this message translates to:
  /// **'Retiro en cajero'**
  String get retiroCajero;

  /// No description provided for @efectivoBolsa.
  ///
  /// In es, this message translates to:
  /// **'Efectivo de su bolsa'**
  String get efectivoBolsa;

  /// No description provided for @personasCount.
  ///
  /// In es, this message translates to:
  /// **'{cantidad} personas'**
  String personasCount(int cantidad);

  /// No description provided for @hoy1220.
  ///
  /// In es, this message translates to:
  /// **'Hoy · 1:20 p.m.'**
  String get hoy1220;

  /// No description provided for @hoy1505.
  ///
  /// In es, this message translates to:
  /// **'Hoy · 3:05 p.m.'**
  String get hoy1505;

  /// No description provided for @ayudaEfectivo.
  ///
  /// In es, this message translates to:
  /// **'El fondo junta el efectivo del grupo. Lo gastado se acredita en proporción a quien aportó, y lo que sobra se devuelve igual.'**
  String get ayudaEfectivo;

  /// No description provided for @resumenViaje.
  ///
  /// In es, this message translates to:
  /// **'Resumen del viaje'**
  String get resumenViaje;

  /// No description provided for @vistaPrevia.
  ///
  /// In es, this message translates to:
  /// **'Vista previa · imagen 1080 × 1350'**
  String get vistaPrevia;

  /// No description provided for @totalViaje.
  ///
  /// In es, this message translates to:
  /// **'Total del viaje'**
  String get totalViaje;

  /// No description provided for @quienSeccion.
  ///
  /// In es, this message translates to:
  /// **'QUIÉN LE PAGA A QUIÉN'**
  String get quienSeccion;

  /// No description provided for @hechoCon.
  ///
  /// In es, this message translates to:
  /// **'Hecho con Kaval · Efectivo sobrante: {monto}'**
  String hechoCon(String monto);

  /// No description provided for @compartirWhatsapp.
  ///
  /// In es, this message translates to:
  /// **'Compartir por WhatsApp'**
  String get compartirWhatsapp;

  /// No description provided for @imagen.
  ///
  /// In es, this message translates to:
  /// **'Imagen'**
  String get imagen;

  /// No description provided for @texto.
  ///
  /// In es, this message translates to:
  /// **'Texto'**
  String get texto;

  /// No description provided for @pdf.
  ///
  /// In es, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @resumenListo.
  ///
  /// In es, this message translates to:
  /// **'Resumen listo para compartir'**
  String get resumenListo;

  /// No description provided for @invitarEvento.
  ///
  /// In es, this message translates to:
  /// **'Invitar al evento'**
  String get invitarEvento;

  /// No description provided for @sumaGrupo.
  ///
  /// In es, this message translates to:
  /// **'¡Suma a tu grupo a {evento}!'**
  String sumaGrupo(String evento);

  /// No description provided for @conCodigo.
  ///
  /// In es, this message translates to:
  /// **'Con el código se unen y ven los gastos al instante.'**
  String get conCodigo;

  /// No description provided for @codigoEvento.
  ///
  /// In es, this message translates to:
  /// **'CÓDIGO DEL EVENTO'**
  String get codigoEvento;

  /// No description provided for @copiado.
  ///
  /// In es, this message translates to:
  /// **'Código copiado'**
  String get copiado;

  /// No description provided for @expira.
  ///
  /// In es, this message translates to:
  /// **'Expira en 7 días · Escanéalo desde la app o usa el enlace.'**
  String get expira;

  /// No description provided for @whatsapp.
  ///
  /// In es, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @enlace.
  ///
  /// In es, this message translates to:
  /// **'Enlace'**
  String get enlace;

  /// No description provided for @porNombre.
  ///
  /// In es, this message translates to:
  /// **'+ Por nombre'**
  String get porNombre;

  /// No description provided for @tuAdmin.
  ///
  /// In es, this message translates to:
  /// **'Tú · Admin'**
  String get tuAdmin;

  /// No description provided for @seUnieron.
  ///
  /// In es, this message translates to:
  /// **'Se unieron con código'**
  String get seUnieron;

  /// No description provided for @unidos.
  ///
  /// In es, this message translates to:
  /// **'{cantidad} unidos'**
  String unidos(int cantidad);

  /// No description provided for @invitadoNombre.
  ///
  /// In es, this message translates to:
  /// **'Invitado (solo nombre)'**
  String get invitadoNombre;

  /// No description provided for @invitar.
  ///
  /// In es, this message translates to:
  /// **'Invitar'**
  String get invitar;

  /// No description provided for @invitacionEnviada.
  ///
  /// In es, this message translates to:
  /// **'Invitación enviada'**
  String get invitacionEnviada;

  /// No description provided for @pendiente.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get pendiente;

  /// No description provided for @enlaceListo.
  ///
  /// In es, this message translates to:
  /// **'Enlace listo para compartir'**
  String get enlaceListo;

  /// No description provided for @sincronizadoHace.
  ///
  /// In es, this message translates to:
  /// **'Sincronizado hace 1 min'**
  String get sincronizadoHace;

  /// No description provided for @kavalPro.
  ///
  /// In es, this message translates to:
  /// **'Kaval Pro'**
  String get kavalPro;

  /// No description provided for @vozNube.
  ///
  /// In es, this message translates to:
  /// **'Voz en la nube'**
  String get vozNube;

  /// No description provided for @exportar.
  ///
  /// In es, this message translates to:
  /// **'Exportar PDF / Excel'**
  String get exportar;

  /// No description provided for @estadisticas.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get estadisticas;

  /// No description provided for @sinAnuncios.
  ///
  /// In es, this message translates to:
  /// **'Sin anuncios'**
  String get sinAnuncios;

  /// No description provided for @probarGratis.
  ///
  /// In es, this message translates to:
  /// **'Probar 7 días gratis'**
  String get probarGratis;

  /// No description provided for @idioma.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get idioma;

  /// No description provided for @moneda.
  ///
  /// In es, this message translates to:
  /// **'Moneda'**
  String get moneda;

  /// No description provided for @usdFijo.
  ///
  /// In es, this message translates to:
  /// **'USD (\$)'**
  String get usdFijo;

  /// No description provided for @sincronizarNube.
  ///
  /// In es, this message translates to:
  /// **'Sincronizar en la nube'**
  String get sincronizarNube;

  /// No description provided for @privacidad.
  ///
  /// In es, this message translates to:
  /// **'Privacidad y datos'**
  String get privacidad;

  /// No description provided for @cerrarSesion.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get cerrarSesion;

  /// No description provided for @eliminarCuenta.
  ///
  /// In es, this message translates to:
  /// **'Eliminar cuenta'**
  String get eliminarCuenta;

  /// No description provided for @eliminarPregunta.
  ///
  /// In es, this message translates to:
  /// **'Esto elimina tu cuenta de Kaval y no se puede deshacer.'**
  String get eliminarPregunta;

  /// No description provided for @eliminar.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get eliminar;

  /// No description provided for @privacidadCuerpo.
  ///
  /// In es, this message translates to:
  /// **'Kaval guarda el texto de lo que dictas, nunca el audio. Con una cuenta, los viajes viven en la nube y también en el teléfono. El perfil local se queda solo en este aparato.'**
  String get privacidadCuerpo;

  /// No description provided for @proAviso.
  ///
  /// In es, this message translates to:
  /// **'Kaval Pro es la visión de más adelante. Esta fase no lo cobra.'**
  String get proAviso;

  /// No description provided for @cerrar.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get cerrar;

  /// No description provided for @unirme.
  ///
  /// In es, this message translates to:
  /// **'Unirme con código'**
  String get unirme;

  /// No description provided for @codigoHint.
  ///
  /// In es, this message translates to:
  /// **'Código del evento'**
  String get codigoHint;

  /// No description provided for @codigoInvalido.
  ///
  /// In es, this message translates to:
  /// **'Ese código no coincide con un viaje'**
  String get codigoInvalido;

  /// No description provided for @teUniste.
  ///
  /// In es, this message translates to:
  /// **'Listo, entraste al viaje'**
  String get teUniste;

  /// No description provided for @sinEventos.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay eventos en esta categoría'**
  String get sinEventos;

  /// No description provided for @viajesRecientes.
  ///
  /// In es, this message translates to:
  /// **'Viajes recientes'**
  String get viajesRecientes;

  /// No description provided for @lugarFecha.
  ///
  /// In es, this message translates to:
  /// **'{lugar} · {fechas}'**
  String lugarFecha(String lugar, String fechas);

  /// No description provided for @categoriaComida.
  ///
  /// In es, this message translates to:
  /// **'Comida'**
  String get categoriaComida;

  /// No description provided for @categoriaTransporte.
  ///
  /// In es, this message translates to:
  /// **'Transporte'**
  String get categoriaTransporte;

  /// No description provided for @categoriaHospedaje.
  ///
  /// In es, this message translates to:
  /// **'Hospedaje'**
  String get categoriaHospedaje;

  /// No description provided for @categoriaDiversion.
  ///
  /// In es, this message translates to:
  /// **'Diversión'**
  String get categoriaDiversion;

  /// No description provided for @aviso.
  ///
  /// In es, this message translates to:
  /// **'Aviso'**
  String get aviso;

  /// No description provided for @entendido.
  ///
  /// In es, this message translates to:
  /// **'Entendido'**
  String get entendido;

  /// No description provided for @enviando.
  ///
  /// In es, this message translates to:
  /// **'Enviando…'**
  String get enviando;

  /// No description provided for @sinConexionAviso.
  ///
  /// In es, this message translates to:
  /// **'No hay conexión. Puedes entrar con el perfil local.'**
  String get sinConexionAviso;

  /// No description provided for @perfilLocalAccion.
  ///
  /// In es, this message translates to:
  /// **'Perfil local'**
  String get perfilLocalAccion;

  /// No description provided for @reintentar.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get reintentar;

  /// No description provided for @seguirSinConexion.
  ///
  /// In es, this message translates to:
  /// **'Seguir sin conexión'**
  String get seguirSinConexion;

  /// No description provided for @errorSinRedTitulo.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión'**
  String get errorSinRedTitulo;

  /// No description provided for @errorSinRedCuerpo.
  ///
  /// In es, this message translates to:
  /// **'No pudimos hablar con el servidor. Revisa tu red o sigue con lo que ya tienes en el teléfono.'**
  String get errorSinRedCuerpo;

  /// No description provided for @errorEsperaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Esto está tardando'**
  String get errorEsperaTitulo;

  /// No description provided for @errorEsperaCuerpo.
  ///
  /// In es, this message translates to:
  /// **'El servidor no respondió a tiempo. Tus datos siguen aquí. Cuando quieras, lo intentamos otra vez.'**
  String get errorEsperaCuerpo;

  /// No description provided for @errorSesionTitulo.
  ///
  /// In es, this message translates to:
  /// **'Tu sesión venció'**
  String get errorSesionTitulo;

  /// No description provided for @errorSesionCuerpo.
  ///
  /// In es, this message translates to:
  /// **'Hay que volver a entrar para guardar este cambio.'**
  String get errorSesionCuerpo;

  /// No description provided for @datosRechazados.
  ///
  /// In es, this message translates to:
  /// **'El servidor no aceptó este dato. Revísalo e inténtalo de nuevo.'**
  String get datosRechazados;

  /// No description provided for @tiempoAgotadoAviso.
  ///
  /// In es, this message translates to:
  /// **'La espera se agotó. Lo que escribiste sigue en el formulario.'**
  String get tiempoAgotadoAviso;

  /// No description provided for @errorGenerico.
  ///
  /// In es, this message translates to:
  /// **'No se pudo completar. Inténtalo otra vez.'**
  String get errorGenerico;

  /// No description provided for @gastoActualizado.
  ///
  /// In es, this message translates to:
  /// **'Gasto actualizado'**
  String get gastoActualizado;

  /// No description provided for @editarGasto.
  ///
  /// In es, this message translates to:
  /// **'Editar gasto'**
  String get editarGasto;

  /// No description provided for @modoPrueba.
  ///
  /// In es, this message translates to:
  /// **'Modo prueba (solo debug)'**
  String get modoPrueba;

  /// No description provided for @modoPruebaAyuda.
  ///
  /// In es, this message translates to:
  /// **'La próxima operación de red fallará a propósito, para mostrar cada respuesta.'**
  String get modoPruebaAyuda;

  /// No description provided for @forzarTimeout.
  ///
  /// In es, this message translates to:
  /// **'Timeout'**
  String get forzarTimeout;

  /// No description provided for @forzarSinRed.
  ///
  /// In es, this message translates to:
  /// **'Sin red'**
  String get forzarSinRed;

  /// No description provided for @forzar401.
  ///
  /// In es, this message translates to:
  /// **'401'**
  String get forzar401;

  /// No description provided for @forzar422.
  ///
  /// In es, this message translates to:
  /// **'422'**
  String get forzar422;

  /// No description provided for @falloArmado.
  ///
  /// In es, this message translates to:
  /// **'Listo. La próxima operación fallará: {modo}.'**
  String falloArmado(String modo);

  /// No description provided for @credencialesInvalidas.
  ///
  /// In es, this message translates to:
  /// **'El correo o la contraseña no coinciden.'**
  String get credencialesInvalidas;

  /// No description provided for @correoEnUso.
  ///
  /// In es, this message translates to:
  /// **'Ese correo ya tiene una cuenta.'**
  String get correoEnUso;

  /// No description provided for @contrasenaDebil.
  ///
  /// In es, this message translates to:
  /// **'Elige una contraseña más segura.'**
  String get contrasenaDebil;

  /// No description provided for @demasiadosIntentos.
  ///
  /// In es, this message translates to:
  /// **'Demasiados intentos. Espera un momento y vuelve a probar.'**
  String get demasiadosIntentos;

  /// No description provided for @redAuth.
  ///
  /// In es, this message translates to:
  /// **'No hay conexión. Revisa tu red e inténtalo otra vez.'**
  String get redAuth;

  /// No description provided for @firebaseSinConfigurar.
  ///
  /// In es, this message translates to:
  /// **'Falta conectar Firebase en este proyecto. Mientras tanto puedes usar el perfil local.'**
  String get firebaseSinConfigurar;

  /// No description provided for @sesionReciente.
  ///
  /// In es, this message translates to:
  /// **'No pudimos confirmar que eres tú. Vuelve a entrar y luego elimina la cuenta.'**
  String get sesionReciente;

  /// No description provided for @googleInterrumpido.
  ///
  /// In es, this message translates to:
  /// **'Se interrumpió el inicio con Google. Inténtalo otra vez.'**
  String get googleInterrumpido;

  /// No description provided for @googleNoDisponible.
  ///
  /// In es, this message translates to:
  /// **'Google no está disponible en este teléfono ahora.'**
  String get googleNoDisponible;

  /// No description provided for @googleMalConfigurado.
  ///
  /// In es, this message translates to:
  /// **'Google no pudo identificar la app. Revisa que el SHA de debug esté en Firebase.'**
  String get googleMalConfigurado;

  /// No description provided for @reautenticarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Confirma que eres tú'**
  String get reautenticarTitulo;

  /// No description provided for @reautenticarCuerpo.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu contraseña para eliminar la cuenta.'**
  String get reautenticarCuerpo;

  /// No description provided for @cuentaDesactivada.
  ///
  /// In es, this message translates to:
  /// **'Esta cuenta está desactivada.'**
  String get cuentaDesactivada;

  /// No description provided for @operacionNoPermitida.
  ///
  /// In es, this message translates to:
  /// **'Esa forma de entrar no está activada en Firebase.'**
  String get operacionNoPermitida;

  /// No description provided for @errorAuth.
  ///
  /// In es, this message translates to:
  /// **'No se pudo completar el acceso. Inténtalo otra vez.'**
  String get errorAuth;

  /// No description provided for @recuperarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Recuperar contraseña'**
  String get recuperarTitulo;

  /// No description provided for @enviarEnlace.
  ///
  /// In es, this message translates to:
  /// **'Enviar enlace'**
  String get enviarEnlace;

  /// No description provided for @correoEnviado.
  ///
  /// In es, this message translates to:
  /// **'Te enviamos un enlace para elegir una contraseña nueva.'**
  String get correoEnviado;

  /// No description provided for @cargarTunco.
  ///
  /// In es, this message translates to:
  /// **'Cargar ejemplo de Playa El Tunco'**
  String get cargarTunco;

  /// No description provided for @tuncoCargado.
  ///
  /// In es, this message translates to:
  /// **'Playa El Tunco quedó cargado'**
  String get tuncoCargado;

  /// No description provided for @agregarInvitado.
  ///
  /// In es, this message translates to:
  /// **'Agregar por nombre'**
  String get agregarInvitado;

  /// No description provided for @nombreInvitado.
  ///
  /// In es, this message translates to:
  /// **'Nombre de quien no tiene cuenta'**
  String get nombreInvitado;

  /// No description provided for @invitadoAgregado.
  ///
  /// In es, this message translates to:
  /// **'Listo. Esa persona queda solo con su nombre.'**
  String get invitadoAgregado;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
