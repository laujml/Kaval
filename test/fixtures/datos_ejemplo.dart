import 'package:kaval/data/repositorios/repositorio_datos.dart';
import 'package:kaval/models/aporte_efectivo.dart';
import 'package:kaval/models/evento.dart';
import 'package:kaval/models/gasto.dart';
import 'package:kaval/models/integrante.dart';
import 'package:kaval/models/usuario.dart';

/// Ids en minúscula: el alfabeto de estos ids es el desempate de la liquidación.
const idLaura = 'laura';
const idAna = 'ana';
const idLuis = 'luis';
const idSofi = 'sofi';
const idDiego = 'diego';
const idCarla = 'carla';

const idTunco = 'tunco';
const idFlores = 'flores';

/// Viaje de prueba para la liquidación. No se carga en la app.
Evento eventoPlayaTunco() {
  const integrantes = [
    Integrante(
      id: idLaura,
      nombre: 'Laura',
      colorFondo: 0xFFFFD9E0,
      colorInicial: 0xFFE56B8A,
      estado: EstadoUnion.admin,
    ),
    Integrante(
      id: idAna,
      nombre: 'Ana',
      colorFondo: 0xFFD5F5E8,
      colorInicial: 0xFF1FA971,
      estado: EstadoUnion.unido,
    ),
    Integrante(
      id: idLuis,
      nombre: 'Luis',
      colorFondo: 0xFFD9ECFF,
      colorInicial: 0xFF3A7BD5,
      estado: EstadoUnion.unido,
    ),
    Integrante(
      id: idSofi,
      nombre: 'Sofi',
      colorFondo: 0xFFE8D9FF,
      colorInicial: 0xFF8B5CF6,
      estado: EstadoUnion.unido,
    ),
    Integrante(
      id: idDiego,
      nombre: 'Diego',
      colorFondo: 0xFFFFE8C2,
      colorInicial: 0xFFE0A100,
      estado: EstadoUnion.soloNombre,
    ),
    Integrante(
      id: idCarla,
      nombre: 'Carla',
      colorFondo: 0xFFFFE0D6,
      colorInicial: 0xFFE07A5F,
      estado: EstadoUnion.pendiente,
    ),
  ];

  const todos = [idLaura, idAna, idLuis, idSofi, idDiego, idCarla];
  const sinCarla = [idLaura, idAna, idLuis, idSofi, idDiego];

  return Evento(
    id: idTunco,
    nombre: 'Playa El Tunco',
    lugar: 'La Libertad',
    inicio: DateTime(2026, 10, 2),
    fin: DateTime(2026, 10, 4),
    portada: PortadaEvento.playa,
    codigo: 'TUNCO-7K2',
    custodioId: idAna,
    integrantes: integrantes,
    aportes: [
      AporteEfectivo(
        id: 'aporte-ana',
        integranteId: idAna,
        montoCentavos: 6000,
        descripcion: 'retiro',
        fecha: DateTime(2026, 10, 2, 9),
      ),
      AporteEfectivo(
        id: 'aporte-luis',
        integranteId: idLuis,
        montoCentavos: 2000,
        descripcion: 'bolsa',
        fecha: DateTime(2026, 10, 2, 9, 30),
      ),
    ],
    gastos: [
      Gasto(
        id: 'gasolina',
        concepto: 'Gasolina',
        montoCentavos: 2400,
        pagadorId: idLaura,
        participanteIds: todos,
        categoria: CategoriaGasto.transporte,
        metodo: MetodoPago.tarjeta,
        dictado: true,
        fecha: DateTime(2026, 10, 3, 18),
      ),
      Gasto(
        id: 'pupusas',
        concepto: 'Pupusas',
        montoCentavos: 1850,
        participanteIds: sinCarla,
        categoria: CategoriaGasto.comida,
        metodo: MetodoPago.efectivoGrupo,
        fecha: DateTime(2026, 10, 3, 13, 20),
      ),
      Gasto(
        id: 'cocos',
        concepto: 'Cocos y agua',
        montoCentavos: 950,
        participanteIds: sinCarla,
        categoria: CategoriaGasto.comida,
        metodo: MetodoPago.efectivoGrupo,
        fecha: DateTime(2026, 10, 3, 15, 5),
      ),
      Gasto(
        id: 'entradas',
        concepto: 'Entradas beach club',
        montoCentavos: 3000,
        pagadorId: idLuis,
        participanteIds: todos,
        categoria: CategoriaGasto.diversion,
        metodo: MetodoPago.tarjeta,
        fecha: DateTime(2026, 10, 3, 11),
      ),
      Gasto(
        id: 'hospedaje',
        concepto: 'Hospedaje',
        montoCentavos: 12000,
        pagadorId: idSofi,
        participanteIds: todos,
        categoria: CategoriaGasto.hospedaje,
        metodo: MetodoPago.tarjeta,
        fecha: DateTime(2026, 10, 2, 16),
      ),
    ],
  );
}

Evento eventoRutaFlores() {
  const integrantes = [
    Integrante(
      id: idLaura,
      nombre: 'Laura',
      colorFondo: 0xFFFFD9E0,
      colorInicial: 0xFFE56B8A,
      estado: EstadoUnion.admin,
    ),
    Integrante(
      id: idAna,
      nombre: 'Ana',
      colorFondo: 0xFFD5F5E8,
      colorInicial: 0xFF1FA971,
    ),
    Integrante(
      id: idLuis,
      nombre: 'Luis',
      colorFondo: 0xFFD9ECFF,
      colorInicial: 0xFF3A7BD5,
    ),
    Integrante(
      id: idSofi,
      nombre: 'Sofi',
      colorFondo: 0xFFE8D9FF,
      colorInicial: 0xFF8B5CF6,
    ),
    Integrante(
      id: idDiego,
      nombre: 'Diego',
      colorFondo: 0xFFFFE8C2,
      colorInicial: 0xFFE0A100,
    ),
  ];
  const todos = [idLaura, idAna, idLuis, idSofi, idDiego];

  return Evento(
    id: idFlores,
    nombre: 'Ruta de las Flores',
    lugar: 'Ahuachapán',
    inicio: DateTime(2026, 9, 12),
    fin: DateTime(2026, 9, 13),
    portada: PortadaEvento.carretera,
    codigo: 'FLORES-3M',
    custodioId: idAna,
    integrantes: integrantes,
    aportes: const [],
    gastos: [
      Gasto(
        id: 'cafe-flores',
        concepto: 'Café',
        montoCentavos: 3245,
        pagadorId: idLaura,
        participanteIds: todos,
        categoria: CategoriaGasto.comida,
        metodo: MetodoPago.tarjeta,
        fecha: DateTime(2026, 9, 12, 10),
      ),
      Gasto(
        id: 'feria-flores',
        concepto: 'Feria de flores',
        montoCentavos: 5355,
        pagadorId: idAna,
        participanteIds: todos,
        categoria: CategoriaGasto.diversion,
        metodo: MetodoPago.tarjeta,
        fecha: DateTime(2026, 9, 12, 15),
      ),
    ],
  );
}

/// El mismo viaje de prueba, con la parte de Laura a nombre de la cuenta.
Evento tuncoParaCuenta(Usuario usuario) {
  if (usuario.local || usuario.id == idLaura) return eventoPlayaTunco();
  String idDe(String id) => id == idLaura ? usuario.id : id;
  final base = eventoPlayaTunco();
  return Evento(
    id: 'tunco-${usuario.id}',
    nombre: base.nombre,
    lugar: base.lugar,
    inicio: base.inicio,
    fin: base.fin,
    portada: base.portada,
    codigo: base.codigo,
    custodioId: idDe(base.custodioId),
    integrantes: [
      for (final persona in base.integrantes)
        Integrante(
          id: idDe(persona.id),
          nombre: persona.id == idLaura ? usuario.primerNombre : persona.nombre,
          colorFondo: persona.colorFondo,
          colorInicial: persona.colorInicial,
          estado: persona.id == idLaura ? EstadoUnion.admin : EstadoUnion.soloNombre,
        ),
    ],
    aportes: [
      for (final aporte in base.aportes)
        AporteEfectivo(
          id: aporte.id,
          integranteId: idDe(aporte.integranteId),
          montoCentavos: aporte.montoCentavos,
          descripcion: aporte.descripcion,
          fecha: aporte.fecha,
        ),
    ],
    gastos: [
      for (final gasto in base.gastos)
        Gasto(
          id: gasto.id,
          concepto: gasto.concepto,
          montoCentavos: gasto.montoCentavos,
          pagadorId: gasto.pagadorId == null ? null : idDe(gasto.pagadorId!),
          participanteIds: [for (final id in gasto.participanteIds) idDe(id)],
          categoria: gasto.categoria,
          metodo: gasto.metodo,
          dictado: gasto.dictado,
          fecha: gasto.fecha,
        ),
    ],
  );
}

Future<void> guardarTunco(RepositorioDatos datos, Usuario usuario) async {
  final evento = tuncoParaCuenta(usuario);
  final guardado = await datos.eventos.guardar(evento, duenoId: usuario.id);
  for (var i = 0; i < guardado.gastos.length; i++) {
    await datos.gastos.guardar(guardado.id, guardado.gastos[i], orden: i);
  }
  for (var i = 0; i < guardado.aportes.length; i++) {
    await datos.aportes.guardar(guardado.id, guardado.aportes[i], orden: i);
  }
}
