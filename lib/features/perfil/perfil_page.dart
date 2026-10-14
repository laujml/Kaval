import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/auth/mensajes_auth.dart';
import '../../core/red/cliente_api.dart';
import '../../core/theme/kaval_colors.dart';
import '../../core/theme/kaval_paleta.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/widgets/aviso.dart';
import '../../core/widgets/boton_coral.dart';
import '../../core/widgets/campo_kaval.dart';
import '../../core/widgets/kaval_avatar.dart';
import '../../core/widgets/tarjeta_kaval.dart';
import '../../data/datos_ejemplo.dart';
import '../../data/servicio_auth.dart';
import '../../l10n/app_localizations.dart';
import '../../state/kaval_state.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final estado = context.watch<KavalState>();
    final laura = estado.buscar(idTunco)?.integrante(idLaura);
    final es = estado.idioma == 'es';
    final alDia = estado.eventos.every((evento) => evento.sincronizado);

    return Scaffold(
      backgroundColor: KavalColors.crema,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Row(
              children: [
                Text(textos.perfil, style: KavalTexto.titulo(size: 28)),
                const Spacer(),
                IconButton(
                  onPressed: () => mostrarAviso(context, textos.proAviso),
                  icon: const Icon(Icons.tune_rounded),
                ),
              ],
            ),
            TarjetaKaval(
              child: Row(
                children: [
                  if (laura != null) avatarDe(laura, tamano: 64),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(estado.usuario.nombre, style: KavalTexto.titulo(size: 18)),
                        Text(estado.usuario.correo, style: KavalTexto.cuerpo(size: 13)),
                        const SizedBox(height: 4),
                        Text(
                          alDia ? textos.sincronizado : textos.pendiente,
                          style: KavalTexto.cuerpo(
                            size: 12,
                            weight: FontWeight.w800,
                            color: alDia ? KavalColors.verde : KavalColors.marino,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: KavalColors.gris),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: KavalColors.marino,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${textos.pro}  ${textos.kavalPro}', style: KavalTexto.titulo(size: 18, color: KavalColors.oro)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _Beneficio('🎙️', textos.vozNube),
                      _Beneficio('📄', textos.exportar),
                      _Beneficio('📊', textos.estadisticas),
                      _Beneficio('🚫', textos.sinAnuncios),
                    ],
                  ),
                  const SizedBox(height: 12),
                  BotonCoral(texto: textos.probarGratis, onPressed: () => mostrarAviso(context, textos.proAviso)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TarjetaKaval(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  ListTile(
                    leading: const _IconoPastel(icono: Icons.language, fondo: KavalColors.menta),
                    title: Text(textos.idioma, style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800)),
                    trailing: SegmentedButton<bool>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(value: true, label: Text('ES')),
                        ButtonSegment(value: false, label: Text('EN')),
                      ],
                      selected: {es},
                      onSelectionChanged: (valor) {
                        estado.cambiarIdioma(Locale(valor.first ? 'es' : 'en'));
                      },
                    ),
                  ),
                  ListTile(
                    leading: const _IconoPastel(icono: Icons.attach_money, fondo: KavalColors.durazno),
                    title: Text(textos.moneda, style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800)),
                    trailing: Text(textos.usdFijo, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.marino)),
                  ),
                  SwitchListTile(
                    secondary: const _IconoPastel(icono: Icons.cloud_outlined, fondo: KavalColors.menta),
                    title: Text(textos.sincronizarNube, style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800)),
                    value: estado.sincronizarNube,
                    activeThumbColor: Colors.white,
                    activeTrackColor: KavalColors.coral,
                    onChanged: estado.alternarSincronizacion,
                  ),
                  ListTile(
                    leading: const _IconoPastel(icono: Icons.shield_outlined, fondo: KavalColors.menta),
                    title: Text(textos.privacidad, style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => showDialog<void>(
                      context: context,
                      builder: (dialog) => AlertDialog(
                        scrollable: true,
                        title: Text(textos.privacidad),
                        content: Text(textos.privacidadCuerpo),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(dialog), child: Text(textos.entendido)),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const _IconoPastel(icono: Icons.logout, fondo: KavalColors.campo),
                    title: Text(textos.cerrarSesion, style: KavalTexto.cuerpo(color: KavalColors.marino, weight: FontWeight.w800)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _cerrarSesion(context),
                  ),
                  ListTile(
                    leading: _IconoPastel(icono: Icons.delete_outline, fondo: KavalPaleta.de(context).rosa),
                    title: Text(textos.eliminarCuenta, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: KavalColors.rojo)),
                    trailing: const Icon(Icons.chevron_right, color: KavalColors.rojo),
                    onTap: () => _eliminarCuenta(context, textos),
                  ),
                ],
              ),
            ),
            if (kDebugMode) ...[
              const SizedBox(height: 12),
              _ModoPrueba(fallo: estado.falloForzado),
            ],
          ],
        ),
      ),
    );
  }
}

class _ModoPrueba extends StatelessWidget {
  const _ModoPrueba({required this.fallo});

  final FalloForzado fallo;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final opciones = <FalloForzado, String>{
      FalloForzado.timeout: textos.forzarTimeout,
      FalloForzado.sinRed: textos.forzarSinRed,
      FalloForzado.noAutorizado: textos.forzar401,
      FalloForzado.invalido: textos.forzar422,
    };
    return TarjetaKaval(
      borde: Border.all(color: KavalColors.coral),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(textos.modoPrueba, style: KavalTexto.titulo(size: 18)),
          const SizedBox(height: 6),
          Text(textos.modoPruebaAyuda, style: KavalTexto.cuerpo(size: 13)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final opcion in opciones.entries)
                ChoiceChip(
                  label: Text(opcion.value),
                  selected: fallo == opcion.key,
                  selectedColor: KavalColors.durazno,
                  onSelected: (_) {
                    context.read<KavalState>().prepararFallo(opcion.key);
                    mostrarAviso(context, textos.falloArmado(opcion.value));
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Beneficio extends StatelessWidget {
  const _Beneficio(this.emoji, this.texto);

  final String emoji;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Text('$emoji $texto', style: KavalTexto.cuerpo(size: 13, color: Colors.white)),
    );
  }
}

class _IconoPastel extends StatelessWidget {
  const _IconoPastel({required this.icono, required this.fondo});

  final IconData icono;
  final Color fondo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: fondo, borderRadius: BorderRadius.circular(10)),
      child: Icon(icono, size: 18, color: KavalColors.marino),
    );
  }
}

Future<void> _cerrarSesion(BuildContext context) async {
  final estado = context.read<KavalState>();
  if (estado.enLaNube) {
    await context.read<ServicioAuth>().cerrarSesion();
  }
  if (!context.mounted) return;
  await estado.salir();
  if (!context.mounted) return;
  context.go('/auth?modo=login');
}

Future<void> _eliminarCuenta(BuildContext context, AppLocalizations textos) async {
  final borrar = await showDialog<bool>(
    context: context,
    builder: (dialog) => AlertDialog(
      scrollable: true,
      title: Text(textos.eliminarCuenta),
      content: Text(textos.eliminarPregunta),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialog, false), child: Text(textos.cancelar)),
        TextButton(
          onPressed: () => Navigator.pop(dialog, true),
          style: TextButton.styleFrom(foregroundColor: KavalPaleta.de(dialog).rojo),
          child: Text(textos.eliminar),
        ),
      ],
    ),
  );
  if (borrar != true || !context.mounted) return;
  final estado = context.read<KavalState>();
  final auth = context.read<ServicioAuth>();
  try {
    if (estado.enLaNube) {
      String? clave;
      if (auth.pideContrasenaParaBorrar) {
        clave = await showDialog<String>(
          context: context,
          builder: (dialog) => const _DialogoReautenticar(),
        );
        if (clave == null || !context.mounted) return;
      }
      final confirmo = await auth.reautenticar(contrasena: clave);
      if (!confirmo || !context.mounted) return;
      await estado.borrarCuentaEnLaNube();
      if (!context.mounted) return;
      await auth.eliminarCuenta();
    }
    if (!context.mounted) return;
    await estado.salir();
    if (!context.mounted) return;
    context.go('/bienvenida');
  } catch (error) {
    if (!context.mounted) return;
    mostrarAviso(context, mensajeAuth(error, textos));
  }
}

class _DialogoReautenticar extends StatefulWidget {
  const _DialogoReautenticar();

  @override
  State<_DialogoReautenticar> createState() => _DialogoReautenticarState();
}

class _DialogoReautenticarState extends State<_DialogoReautenticar> {
  final _formKey = GlobalKey<FormState>();
  final _clave = TextEditingController();
  final _foco = FocusNode();
  var _ocultar = true;

  @override
  void dispose() {
    _clave.dispose();
    _foco.dispose();
    super.dispose();
  }

  void _aceptar() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context, _clave.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    return AlertDialog(
      scrollable: true,
      title: Text(textos.reautenticarTitulo),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(textos.reautenticarCuerpo, style: KavalTexto.cuerpo(color: KavalPaleta.de(context).gris)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _clave,
              focusNode: _foco,
              autofocus: true,
              obscureText: _ocultar,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _aceptar(),
              style: KavalTexto.cuerpo(color: KavalPaleta.de(context).marino),
              decoration: decoracionCampo(
                context,
                icono: Icons.lock_outline,
                suffix: IconButton(
                  onPressed: () => setState(() => _ocultar = !_ocultar),
                  icon: Icon(_ocultar ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  tooltip: _ocultar ? textos.mostrarContrasena : textos.ocultarContrasena,
                ),
              ),
              validator: (valor) {
                if (valor == null || valor.isEmpty) return textos.contrasenaObligatoria;
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(textos.cancelar)),
        TextButton(
          onPressed: _aceptar,
          style: TextButton.styleFrom(foregroundColor: KavalPaleta.de(context).rojo),
          child: Text(textos.eliminar),
        ),
      ],
    );
  }
}
