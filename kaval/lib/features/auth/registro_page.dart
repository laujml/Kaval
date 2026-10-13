import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/red/cliente_api.dart';
import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/widgets/aviso.dart';
import '../../core/widgets/boton_coral.dart';
import '../../core/widgets/campo_kaval.dart';
import '../../core/widgets/ilustraciones.dart';
import '../../core/widgets/logo_kaval.dart';
import '../../l10n/app_localizations.dart';
import '../../state/kaval_state.dart';
import '../errores/control_errores_page.dart';

/// Registro de Kaval, traído de la semana 7.
/// Se conservan el Form, la GlobalKey, los validators y el salto entre campos.
/// Aquí solo se conectan el tema compartido, los textos y la ruta al inicio.
class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key, this.empezarEnLogin = false});

  final bool empezarEnLogin;

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final _formKey = GlobalKey<FormState>();

  /// Hace falta para comparar la confirmación antes de que corra save().
  final _passwordController = TextEditingController();
  final _nombreFocus = FocusNode();
  final _correoFocus = FocusNode();
  final _contrasenaFocus = FocusNode();
  final _confirmacionFocus = FocusNode();

  String _nombre = '';
  String _correo = '';
  String _contrasena = '';
  String _confirmacion = '';

  bool _ocultarContrasena = true;
  bool _ocultarConfirmacion = true;
  bool _enviando = false;
  late bool _crearCuenta;

  static final RegExp _correoRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp _tieneNumero = RegExp(r'[0-9]');

  @override
  void initState() {
    super.initState();
    _crearCuenta = !widget.empezarEnLogin;
  }

  @override
  void dispose() {
    _nombreFocus.dispose();
    _correoFocus.dispose();
    _contrasenaFocus.dispose();
    _confirmacionFocus.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final formulario = _formKey.currentState;
    if (formulario == null || !formulario.validate() || _enviando) return;
    formulario.save();
    final textos = AppLocalizations.of(context);
    final estado = context.read<KavalState>();
    if (_crearCuenta) {
      assert(_contrasena.isNotEmpty && _confirmacion == _contrasena);
      estado.entrar(nombre: _nombre, correo: _correo);
      mostrarAviso(context, textos.cuentaCreada);
      context.go('/inicio');
      return;
    }
    setState(() => _enviando = true);
    final fallo = estado.consumirFallo();
    final cliente = context.read<ClienteApi>();
    try {
      // El login demo sigue aceptando cualquier correo válido. El POST solo prueba la red.
      await cliente.iniciarSesion(correo: _correo, fallo: fallo);
      if (!mounted) return;
      estado.entrar(nombre: 'Laura Angel', correo: _correo);
      mostrarAviso(context, textos.sesionIniciada);
      context.go('/inicio');
    } on DioException catch (error) {
      if (!mounted) return;
      setState(() => _enviando = false);
      _alFallarLogin(error, textos);
    }
  }

  void _alFallarLogin(DioException error, AppLocalizations textos) {
    switch (clasificar(error)) {
      case TipoFallo.sinRed:
        mostrarAviso(
          context,
          textos.sinConexionAviso,
          accion: textos.perfilLocalAccion,
          alAccionar: _perfilLocal,
        );
      case TipoFallo.espera:
        context.push('/errores/espera', extra: PasoError(alReintentar: _enviar));
      case TipoFallo.sesion:
        context.push('/errores/sesion');
      case TipoFallo.rechazo:
        mostrarAviso(context, mensajeRechazo(error, textos.datosRechazados));
      case TipoFallo.otro:
        mostrarAviso(context, textos.errorGenerico);
    }
  }

  void _perfilLocal() {
    final textos = AppLocalizations.of(context);
    context.read<KavalState>().entrar(
          nombre: 'Laura Angel',
          correo: 'laura.angel@email.com',
          local: true,
        );
    mostrarAviso(context, textos.perfilLocal);
    context.go('/inicio');
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: KavalColors.crema,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  const IlustracionCarretera(),
                  Padding(
                    padding: const EdgeInsets.only(top: 156),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _tarjeta(textos),
                        const SizedBox(height: 22),
                        _separador(textos),
                        const SizedBox(height: 16),
                        _botonesSociales(textos),
                        const SizedBox(height: 18),
                        GestureDetector(
                          onTap: _perfilLocal,
                          child: Text.rich(
                            TextSpan(
                              style: KavalTexto.cuerpo(size: 14),
                              children: [
                                TextSpan(text: textos.sinInternet),
                                TextSpan(
                                  text: textos.perfilLocal,
                                  style: KavalTexto.cuerpo(
                                    size: 14,
                                    weight: FontWeight.w800,
                                    color: KavalColors.coral,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tarjeta(AppLocalizations textos) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(color: KavalColors.sombra, blurRadius: 28, offset: Offset(0, 12)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LogoKaval(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _crearCuenta ? textos.bienvenida : textos.holaDeNuevo,
                        style: KavalTexto.titulo(),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        textos.viajesSincronizados,
                        style: KavalTexto.cuerpo(size: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _selector(textos),
            const SizedBox(height: 18),
            if (_crearCuenta) ...[
              EtiquetaCampo(textos.nombre),
              TextFormField(
                autofocus: true,
                focusNode: _nombreFocus,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_correoFocus),
                style: KavalTexto.cuerpo(color: KavalColors.marino),
                decoration: decoracionCampo(icono: Icons.person_outline),
                validator: (valor) {
                  final nombre = valor?.trim() ?? '';
                  if (nombre.isEmpty) return textos.nombreObligatorio;
                  if (nombre.length < 2) return textos.nombreCorto;
                  return null;
                },
                onSaved: (valor) => _nombre = valor?.trim() ?? '',
              ),
              const SizedBox(height: 14),
            ],
            EtiquetaCampo(textos.correo),
            TextFormField(
              autofocus: !_crearCuenta,
              focusNode: _correoFocus,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_contrasenaFocus),
              autocorrect: false,
              style: KavalTexto.cuerpo(color: KavalColors.marino),
              decoration: decoracionCampo(icono: Icons.mail_outline),
              validator: (valor) {
                final correo = valor?.trim() ?? '';
                if (correo.isEmpty) return textos.correoObligatorio;
                if (!_correoRegex.hasMatch(correo)) return textos.correoInvalido;
                return null;
              },
              onSaved: (valor) => _correo = valor?.trim() ?? '',
            ),
            const SizedBox(height: 14),
            EtiquetaCampo(textos.contrasena),
            TextFormField(
              controller: _passwordController,
              focusNode: _contrasenaFocus,
              obscureText: _ocultarContrasena,
              textInputAction: _crearCuenta ? TextInputAction.next : TextInputAction.done,
              onFieldSubmitted: (_) {
                if (_crearCuenta) {
                  FocusScope.of(context).requestFocus(_confirmacionFocus);
                } else {
                  _enviar();
                }
              },
              style: KavalTexto.cuerpo(color: KavalColors.marino),
              decoration: decoracionCampo(
                icono: Icons.lock_outline,
                suffix: _ojo(
                  oculto: _ocultarContrasena,
                  textos: textos,
                  alTocar: () => setState(() => _ocultarContrasena = !_ocultarContrasena),
                ),
              ),
              validator: (valor) {
                final contrasena = valor ?? '';
                if (contrasena.isEmpty) return textos.contrasenaObligatoria;
                if (!_crearCuenta) return null;
                if (contrasena.length < 8) return textos.contrasenaCorta;
                if (!_tieneNumero.hasMatch(contrasena)) return textos.contrasenaNumero;
                return null;
              },
              onSaved: (valor) => _contrasena = valor ?? '',
            ),
            if (_crearCuenta) ...[
              const SizedBox(height: 14),
              EtiquetaCampo(textos.confirmarContrasena),
              TextFormField(
                focusNode: _confirmacionFocus,
                obscureText: _ocultarConfirmacion,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _enviar(),
                style: KavalTexto.cuerpo(color: KavalColors.marino),
                decoration: decoracionCampo(
                  icono: Icons.lock_outline,
                  suffix: _ojo(
                    oculto: _ocultarConfirmacion,
                    textos: textos,
                    alTocar: () => setState(() => _ocultarConfirmacion = !_ocultarConfirmacion),
                  ),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) return textos.confirmaContrasena;
                  if (valor != _passwordController.text) return textos.contrasenasNoCoinciden;
                  return null;
                },
                onSaved: (valor) => _confirmacion = valor ?? '',
              ),
            ] else ...[
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => mostrarAviso(context, textos.fase2),
                  child: Text(
                    textos.olvidaste,
                    style: KavalTexto.cuerpo(
                      weight: FontWeight.w800,
                      color: KavalColors.coral,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            BotonCoral(
              texto: _enviando
                  ? textos.enviando
                  : (_crearCuenta ? textos.crearCuenta : textos.iniciarSesion),
              onPressed: _enviando ? null : () => _enviar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ojo({
    required bool oculto,
    required AppLocalizations textos,
    required VoidCallback alTocar,
  }) {
    return IconButton(
      tooltip: oculto ? textos.mostrarContrasena : textos.ocultarContrasena,
      onPressed: alTocar,
      icon: Icon(
        oculto ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: KavalColors.gris,
      ),
    );
  }

  Widget _selector(AppLocalizations textos) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: KavalColors.campo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Segmento(
              texto: textos.iniciarSesion,
              activo: !_crearCuenta,
              onTap: () => setState(() => _crearCuenta = false),
            ),
          ),
          Expanded(
            child: _Segmento(
              texto: textos.crearCuenta,
              activo: _crearCuenta,
              onTap: () => setState(() => _crearCuenta = true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _separador(AppLocalizations textos) {
    return Row(
      children: [
        const Expanded(child: Divider(color: KavalColors.borde)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(textos.continuaCon, style: KavalTexto.cuerpo(size: 13)),
        ),
        const Expanded(child: Divider(color: KavalColors.borde)),
      ],
    );
  }

  Widget _botonesSociales(AppLocalizations textos) {
    return Row(
      children: [
        Expanded(child: _social(textos.google, const _LogoGoogle())),
        const SizedBox(width: 12),
        Expanded(
          child: _social(textos.apple, const Icon(Icons.apple, color: KavalColors.marino, size: 22)),
        ),
      ],
    );
  }

  Widget _social(String texto, Widget icono) {
    return OutlinedButton(
      onPressed: () => mostrarAviso(context, AppLocalizations.of(context).fase2),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: KavalColors.marino,
        side: const BorderSide(color: KavalColors.borde),
        minimumSize: const Size.fromHeight(52),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icono,
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              texto,
              overflow: TextOverflow.ellipsis,
              style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.marino),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segmento extends StatelessWidget {
  const _Segmento({required this.texto, required this.activo, required this.onTap});

  final String texto;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: activo ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: activo
              ? const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))]
              : null,
        ),
        child: Text(
          texto,
          style: KavalTexto.cuerpo(
            weight: activo ? FontWeight.w800 : FontWeight.w700,
            color: activo ? KavalColors.marino : KavalColors.gris,
          ),
        ),
      ),
    );
  }
}

class _LogoGoogle extends StatelessWidget {
  const _LogoGoogle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'G',
      style: KavalTexto.cuerpo(size: 20, weight: FontWeight.w800, color: const Color(0xFF4285F4), height: 1),
    );
  }
}
