import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/kaval_medidas.dart';
import '../../core/theme/kaval_paleta.dart';
import '../../core/theme/kaval_texto.dart';
import '../../core/utils/dinero.dart';
import '../../core/utils/etiquetas.dart';
import '../../core/widgets/campo_kaval.dart';
import '../../l10n/app_localizations.dart';
import '../../models/gasto.dart';
import '../../models/integrante.dart';

/// Ítem todavía en el formulario. Los controladores los suelta quien lo crea.
class BorradorItem {
  BorradorItem({
    String? id,
    String nombre = '',
    String precio = '',
    String cantidad = '1',
    Set<String>? asignados,
  }) : id = id ?? 'item-${DateTime.now().microsecondsSinceEpoch}',
       nombre = TextEditingController(text: nombre),
       precio = TextEditingController(text: precio),
       cantidad = TextEditingController(text: cantidad),
       nombreFocus = FocusNode(),
       precioFocus = FocusNode(),
       cantidadFocus = FocusNode(),
       asignados = asignados ?? {};

  factory BorradorItem.desde(ItemGasto item) {
    return BorradorItem(
      id: item.id,
      nombre: item.nombre,
      precio: (item.precioCentavos / 100).toStringAsFixed(2),
      cantidad: '${item.cantidad}',
      asignados: item.participanteIds.toSet(),
    );
  }

  final String id;
  final TextEditingController nombre;
  final TextEditingController precio;
  final TextEditingController cantidad;
  final FocusNode nombreFocus;
  final FocusNode precioFocus;
  final FocusNode cantidadFocus;
  final Set<String> asignados;

  void dispose() {
    nombre.dispose();
    precio.dispose();
    cantidad.dispose();
    nombreFocus.dispose();
    precioFocus.dispose();
    cantidadFocus.dispose();
  }
}

class EditorDivision extends StatelessWidget {
  const EditorDivision({
    super.key,
    required this.modo,
    required this.alCambiarModo,
    required this.personas,
    required this.usuarioId,
    required this.participantes,
    required this.alAlternar,
    required this.partesIguales,
    required this.controlMonto,
    required this.alCambiarMonto,
    required this.totalReferencia,
    required this.items,
    required this.alAgregarItem,
    required this.alQuitarItem,
    required this.alAlternarAsignado,
    required this.propina,
    required this.extras,
    required this.propinaFocus,
    required this.extrasFocus,
    required this.totalConsumoCentavos,
  });

  final ModoDivision modo;
  final ValueChanged<ModoDivision> alCambiarModo;
  final List<Integrante> personas;
  final String usuarioId;
  final Set<String> participantes;
  final ValueChanged<String> alAlternar;
  final Map<String, int> partesIguales;
  final TextEditingController Function(String id) controlMonto;
  final VoidCallback alCambiarMonto;
  final int totalReferencia;
  final List<BorradorItem> items;
  final VoidCallback alAgregarItem;
  final ValueChanged<BorradorItem> alQuitarItem;
  final void Function(BorradorItem item, String personaId) alAlternarAsignado;
  final TextEditingController propina;
  final TextEditingController extras;
  final FocusNode propinaFocus;
  final FocusNode extrasFocus;
  final int totalConsumoCentavos;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final paleta = KavalPaleta.de(context);
    final angosto = MediaQuery.sizeOf(context).width < 420;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<ModoDivision>(
          showSelectedIcon: !angosto,
          segments: [
            ButtonSegment(
              value: ModoDivision.iguales,
              label: Text(textos.partesIguales),
              icon: angosto ? null : const Icon(Icons.groups_outlined),
              tooltip: textos.partesIguales,
            ),
            ButtonSegment(
              value: ModoDivision.montos,
              label: Text(textos.montosExactos),
              icon: angosto ? null : const Icon(Icons.pin_outlined),
              tooltip: textos.montosExactos,
            ),
            ButtonSegment(
              value: ModoDivision.consumo,
              label: Text(textos.porConsumo),
              icon: angosto ? null : const Icon(Icons.receipt_long_outlined),
              tooltip: textos.porConsumo,
            ),
          ],
          selected: {modo},
          onSelectionChanged: (seleccion) => alCambiarModo(seleccion.first),
          style: SegmentedButton.styleFrom(
            selectedBackgroundColor: paleta.coral,
            selectedForegroundColor: Colors.white,
            foregroundColor: paleta.marino,
            side: BorderSide(color: paleta.borde),
          ),
        ),
        const SizedBox(height: KavalMedidas.xs),
        Text(_ayuda(textos), style: KavalTexto.cuerpo(size: 12, color: paleta.gris)),
        const SizedBox(height: KavalMedidas.sm),
        if (modo == ModoDivision.iguales)
          _ChipsPersonas(
            personas: personas,
            usuarioId: usuarioId,
            participantes: participantes,
            partes: partesIguales,
            alAlternar: alAlternar,
          ),
        if (modo == ModoDivision.montos)
          _MontosExactos(
            personas: personas,
            usuarioId: usuarioId,
            participantes: participantes,
            alAlternar: alAlternar,
            controlMonto: controlMonto,
            alCambiarMonto: alCambiarMonto,
            totalReferencia: totalReferencia,
          ),
        if (modo == ModoDivision.consumo)
          _Consumo(
            personas: personas,
            usuarioId: usuarioId,
            items: items,
            alAgregarItem: alAgregarItem,
            alQuitarItem: alQuitarItem,
            alAlternarAsignado: alAlternarAsignado,
            propina: propina,
            extras: extras,
            propinaFocus: propinaFocus,
            extrasFocus: extrasFocus,
            totalCentavos: totalConsumoCentavos,
            alCambiar: alCambiarMonto,
          ),
      ],
    );
  }

  String _ayuda(AppLocalizations textos) {
    return switch (modo) {
      ModoDivision.iguales => textos.ayudaIguales,
      ModoDivision.montos => textos.ayudaMontos,
      ModoDivision.consumo => textos.ayudaConsumo,
    };
  }
}

class _ChipsPersonas extends StatelessWidget {
  const _ChipsPersonas({
    required this.personas,
    required this.usuarioId,
    required this.participantes,
    required this.partes,
    required this.alAlternar,
  });

  final List<Integrante> personas;
  final String usuarioId;
  final Set<String> participantes;
  final Map<String, int> partes;
  final ValueChanged<String> alAlternar;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final paleta = KavalPaleta.de(context);
    return Wrap(
      spacing: KavalMedidas.xs,
      runSpacing: KavalMedidas.xs,
      children: [
        for (final persona in personas)
          FilterChip(
            label: Text(
              participantes.contains(persona.id)
                  ? '${etiquetaIntegrante(textos, persona, usuarioId)} ${usd(partes[persona.id] ?? 0)}'
                  : etiquetaIntegrante(textos, persona, usuarioId),
            ),
            selected: participantes.contains(persona.id),
            showCheckmark: true,
            selectedColor: paleta.durazno,
            checkmarkColor: paleta.coral,
            onSelected: (_) => alAlternar(persona.id),
          ),
      ],
    );
  }
}

class _MontosExactos extends StatelessWidget {
  const _MontosExactos({
    required this.personas,
    required this.usuarioId,
    required this.participantes,
    required this.alAlternar,
    required this.controlMonto,
    required this.alCambiarMonto,
    required this.totalReferencia,
  });

  final List<Integrante> personas;
  final String usuarioId;
  final Set<String> participantes;
  final ValueChanged<String> alAlternar;
  final TextEditingController Function(String id) controlMonto;
  final VoidCallback alCambiarMonto;
  final int totalReferencia;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final paleta = KavalPaleta.de(context);
    var suma = 0;
    for (final persona in personas) {
      if (!participantes.contains(persona.id)) continue;
      suma += centavosDesdeTexto(controlMonto(persona.id).text) ?? 0;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: KavalMedidas.xs,
          runSpacing: KavalMedidas.xs,
          children: [
            for (final persona in personas)
              FilterChip(
                label: Text(etiquetaIntegrante(textos, persona, usuarioId)),
                selected: participantes.contains(persona.id),
                showCheckmark: true,
                selectedColor: paleta.durazno,
                checkmarkColor: paleta.coral,
                onSelected: (_) => alAlternar(persona.id),
              ),
          ],
        ),
        const SizedBox(height: KavalMedidas.sm),
        for (final persona in personas)
          if (participantes.contains(persona.id))
            Padding(
              padding: const EdgeInsets.only(bottom: KavalMedidas.xs),
              child: TextFormField(
                controller: controlMonto(persona.id),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                onChanged: (_) => alCambiarMonto(),
                style: KavalTexto.cuerpo(color: paleta.marino, weight: FontWeight.w800),
                decoration: decoracionCampo(
                  context,
                  hint: '0.00',
                  icono: Icons.person_outline,
                ).copyWith(labelText: etiquetaIntegrante(textos, persona, usuarioId)),
                validator: (valor) {
                  final centavos = centavosDesdeTexto(valor ?? '');
                  if (centavos == null || centavos < 0) return textos.montoInvalido;
                  return null;
                },
              ),
            ),
        _AvisoSuma(suma: suma, referencia: totalReferencia),
      ],
    );
  }
}

class _AvisoSuma extends StatelessWidget {
  const _AvisoSuma({required this.suma, required this.referencia});

  final int suma;
  final int referencia;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final paleta = KavalPaleta.de(context);
    if (referencia <= 0 && suma == 0) return const SizedBox.shrink();
    final diferencia = referencia - suma;
    final texto = diferencia == 0
        ? textos.sumaCuadra
        : diferencia > 0
            ? textos.faltan(usd(diferencia))
            : textos.sobran(usd(-diferencia));
    final color = diferencia == 0 ? paleta.verde : paleta.rojo;
    return Padding(
      padding: const EdgeInsets.only(top: KavalMedidas.xxs),
      child: Text(texto, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: color)),
    );
  }
}

class _Consumo extends StatelessWidget {
  const _Consumo({
    required this.personas,
    required this.usuarioId,
    required this.items,
    required this.alAgregarItem,
    required this.alQuitarItem,
    required this.alAlternarAsignado,
    required this.propina,
    required this.extras,
    required this.propinaFocus,
    required this.extrasFocus,
    required this.totalCentavos,
    required this.alCambiar,
  });

  final List<Integrante> personas;
  final String usuarioId;
  final List<BorradorItem> items;
  final VoidCallback alAgregarItem;
  final ValueChanged<BorradorItem> alQuitarItem;
  final void Function(BorradorItem item, String personaId) alAlternarAsignado;
  final TextEditingController propina;
  final TextEditingController extras;
  final FocusNode propinaFocus;
  final FocusNode extrasFocus;
  final int totalCentavos;
  final VoidCallback alCambiar;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final paleta = KavalPaleta.de(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in items)
          _TarjetaItem(
            item: item,
            personas: personas,
            usuarioId: usuarioId,
            alQuitar: () => alQuitarItem(item),
            alAlternar: (id) => alAlternarAsignado(item, id),
            alCambiar: alCambiar,
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: alAgregarItem,
            icon: Icon(Icons.add, color: paleta.coral),
            label: Text(textos.agregarItem, style: KavalTexto.cuerpo(weight: FontWeight.w800, color: paleta.coral)),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: propina,
                focusNode: propinaFocus,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => extrasFocus.requestFocus(),
                onChanged: (_) => alCambiar(),
                decoration: decoracionCampo(context, hint: '0', icono: Icons.percent).copyWith(labelText: textos.propina),
                style: KavalTexto.cuerpo(color: paleta.marino, weight: FontWeight.w800),
                validator: (valor) {
                  final texto = valor?.trim() ?? '';
                  if (texto.isEmpty) return null;
                  final numero = int.tryParse(texto);
                  if (numero == null || numero < 0 || numero > 100) return textos.propinaInvalida;
                  return null;
                },
              ),
            ),
            const SizedBox(width: KavalMedidas.xs),
            Expanded(
              child: TextFormField(
                controller: extras,
                focusNode: extrasFocus,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => alCambiar(),
                decoration: decoracionCampo(context, hint: textos.extras, icono: Icons.add_circle_outline).copyWith(
                  labelText: textos.extras,
                ),
                style: KavalTexto.cuerpo(color: paleta.marino, weight: FontWeight.w800),
                validator: (valor) {
                  final texto = valor?.trim() ?? '';
                  if (texto.isEmpty) return null;
                  final centavos = centavosDesdeTexto(texto);
                  if (centavos == null || centavos < 0) return textos.montoInvalido;
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: KavalMedidas.xs),
        Text(
          textos.totalConsumo(usd(totalCentavos)),
          style: KavalTexto.titulo(size: 18, color: paleta.marino),
        ),
      ],
    );
  }
}

class _TarjetaItem extends StatelessWidget {
  const _TarjetaItem({
    required this.item,
    required this.personas,
    required this.usuarioId,
    required this.alQuitar,
    required this.alAlternar,
    required this.alCambiar,
  });

  final BorradorItem item;
  final List<Integrante> personas;
  final String usuarioId;
  final VoidCallback alQuitar;
  final ValueChanged<String> alAlternar;
  final VoidCallback alCambiar;

  @override
  Widget build(BuildContext context) {
    final textos = AppLocalizations.of(context);
    final paleta = KavalPaleta.de(context);
    return Container(
      margin: const EdgeInsets.only(bottom: KavalMedidas.sm),
      padding: const EdgeInsets.all(KavalMedidas.sm),
      decoration: BoxDecoration(
        color: paleta.superficie,
        borderRadius: BorderRadius.circular(KavalMedidas.radioCampo),
        border: Border.all(color: paleta.borde),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: item.nombre,
                  focusNode: item.nombreFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => item.precioFocus.requestFocus(),
                  onChanged: (_) => alCambiar(),
                  decoration: decoracionCampo(context, hint: textos.nombreItem),
                  style: KavalTexto.cuerpo(color: paleta.marino, weight: FontWeight.w800),
                  validator: (valor) {
                    if ((valor?.trim() ?? '').isEmpty) return textos.itemIncompleto;
                    return null;
                  },
                ),
              ),
              IconButton(
                tooltip: textos.quitarItem,
                onPressed: alQuitar,
                icon: Icon(Icons.close, color: paleta.gris),
              ),
            ],
          ),
          const SizedBox(height: KavalMedidas.xs),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: item.precio,
                  focusNode: item.precioFocus,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => item.cantidadFocus.requestFocus(),
                  onChanged: (_) => alCambiar(),
                  decoration: decoracionCampo(context, hint: textos.precioItem),
                  style: KavalTexto.cuerpo(color: paleta.marino, weight: FontWeight.w800),
                  validator: (valor) {
                    final centavos = centavosDesdeTexto(valor ?? '');
                    if (centavos == null || centavos <= 0) return textos.montoInvalido;
                    return null;
                  },
                ),
              ),
              const SizedBox(width: KavalMedidas.xs),
              SizedBox(
                width: 88,
                child: TextFormField(
                  controller: item.cantidad,
                  focusNode: item.cantidadFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => alCambiar(),
                  decoration: decoracionCampo(context, hint: textos.cantidadItem),
                  style: KavalTexto.cuerpo(color: paleta.marino, weight: FontWeight.w800),
                  validator: (valor) {
                    final cantidad = int.tryParse(valor?.trim() ?? '');
                    if (cantidad == null || cantidad <= 0) return textos.itemIncompleto;
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: KavalMedidas.xs),
          Wrap(
            spacing: KavalMedidas.xs,
            runSpacing: KavalMedidas.xxs,
            children: [
              for (final persona in personas)
                FilterChip(
                  label: Text(etiquetaIntegrante(textos, persona, usuarioId)),
                  selected: item.asignados.contains(persona.id),
                  showCheckmark: true,
                  selectedColor: paleta.durazno,
                  checkmarkColor: paleta.coral,
                  onSelected: (_) => alAlternar(persona.id),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
