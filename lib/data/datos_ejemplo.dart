import '../models/aporte_efectivo.dart';
import '../models/evento.dart';
import '../models/gasto.dart';
import '../models/integrante.dart';
import '../models/usuario.dart';

/// Ids en minúscula: el alfabeto de estos ids es el desempate de la liquidación.
const idLaura = 'laura';
const idAna = 'ana';
const idLuis = 'luis';
const idSofi = 'sofi';
const idDiego = 'diego';
const idCarla = 'carla';

const idTunco = 'tunco';
const idFlores = 'flores';

Usuario usuarioDemo() {
  return const Usuario(
    id: idLaura,
    nombre: 'Laura Angel',
    correo: 'laura.angel@email.com',
  );
}

/// Playa El Tunco, con los montos del mockup.
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
    emoji: '🌊',
    custodioId: idAna,
    integrantes: integrantes,
    aportes: [
      AporteEfectivo(
        id: 'aporte-ana',
        integranteId: idAna,
        montoCentavos: 6000,
        descripcion: 'retiro',
        emoji: '🏧',
        fecha: DateTime(2026, 10, 2, 9),
      ),
      AporteEfectivo(
        id: 'aporte-luis',
        integranteId: idLuis,
        montoCentavos: 2000,
        descripcion: 'bolsa',
        emoji: '💵',
        fecha: DateTime(2026, 10, 2, 9, 30),
      ),
    ],
    // El orden es el del mockup: gasolina, pupusas, cocos, entradas, hospedaje.
    gastos: [
      Gasto(
        id: 'gasolina',
        concepto: 'Gasolina',
        montoCentavos: 2400,
        pagadorId: idLaura,
        participanteIds: todos,
        categoria: CategoriaGasto.transporte,
        metodo: MetodoPago.tarjeta,
        emoji: '⛽',
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
        emoji: '🫓',
        fecha: DateTime(2026, 10, 3, 13, 20),
      ),
      Gasto(
        id: 'cocos',
        concepto: 'Cocos y agua',
        montoCentavos: 950,
        participanteIds: sinCarla,
        categoria: CategoriaGasto.comida,
        metodo: MetodoPago.efectivoGrupo,
        emoji: '🥥',
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
        emoji: '🎟️',
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
        emoji: '🏠',
        fecha: DateTime(2026, 10, 2, 16),
      ),
    ],
  );
}

/// Segundo viaje para que el inicio cuadre: te deben $15.25 y debes $10.60.
/// Laura pagó $32.45 y Ana $53.55, entre 5. El neto de Laura es +$15.25.
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
    emoji: '🌸',
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
        emoji: '🍽️',
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
        emoji: '🎟️',
        fecha: DateTime(2026, 9, 12, 15),
      ),
    ],
  );
}

List<Evento> eventosIniciales() => [eventoPlayaTunco(), eventoRutaFlores()];

/// Borrador que muestra la confirmación del dictado de gasolina.
Gasto borradorGasolina() {
  return Gasto(
    id: 'borrador-gasolina',
    concepto: 'Gasolina',
    montoCentavos: 2400,
    pagadorId: idLaura,
    participanteIds: [idLaura, idAna, idLuis, idSofi, idDiego, idCarla],
    categoria: CategoriaGasto.transporte,
    metodo: MetodoPago.tarjeta,
    emoji: '⛽',
    dictado: true,
    fecha: DateTime(2026, 10, 3, 18),
  );
}
