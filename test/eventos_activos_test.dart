import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaval/core/eventos/actividad_evento.dart';
import 'package:kaval/data/repositorios/repositorio_datos.dart';
import 'package:kaval/models/evento.dart';
import 'package:kaval/models/integrante.dart';
import 'package:kaval/models/usuario.dart';
import 'package:kaval/state/kaval_state.dart';

void main() {
  final hoy = DateTime(2026, 10, 20);

  test('un viaje futuro o en curso está activo y el que ya terminó no', () {
    final futuro = _viaje('futuro', DateTime(2026, 11, 1), DateTime(2026, 11, 3));
    final enCurso = _viaje('curso', DateTime(2026, 10, 18), DateTime(2026, 10, 20));
    final terminado = _viaje('fin', DateTime(2026, 10, 1), DateTime(2026, 10, 19));

    expect(eventoSigueActivo(futuro, hoy), isTrue);
    expect(eventoSigueActivo(enCurso, hoy), isTrue);
    expect(eventoSigueActivo(terminado, hoy), isFalse);
    expect(eventosActivosEn([futuro, enCurso, terminado], hoy).map((e) => e.id), ['futuro', 'curso']);
    expect(eventosHistorialEn([futuro, enCurso, terminado], hoy).map((e) => e.id), ['fin']);
  });

  test('crear un evento lo deja en activos y uno ya cerrado va al historial', () {
    final estado = KavalState();
    addTearDown(estado.dispose);
    estado.entrar(nombre: 'Ana', correo: 'ana@email.com', local: true);
    final ahora = DateTime.now();
    final dia = DateTime(ahora.year, ahora.month, ahora.day);
    estado.crearEvento(_viaje('nuevo', dia.add(const Duration(days: 2)), dia.add(const Duration(days: 4))));
    estado.crearEvento(_viaje('cerrado', dia.subtract(const Duration(days: 5)), dia.subtract(const Duration(days: 1))));

    expect(estado.eventosActivos.map((evento) => evento.id), contains('nuevo'));
    expect(estado.eventosActivos.map((evento) => evento.id), isNot(contains('cerrado')));
    expect(estado.eventosHistorial.map((evento) => evento.id), contains('cerrado'));
    expect(estado.eventosFiltrados.map((evento) => evento.id), contains('nuevo'));
  });

  test('un evento local pendiente no desaparece si la nube todavía no lo trae', () {
    final local = _viaje('pendiente', hoy, hoy);
    final remoto = _viaje('viejo', hoy, hoy);
    expect(fusionarEventos([local], const <Evento>[]).map((evento) => evento.id), ['pendiente']);
    expect(fusionarEventos([local], [remoto]).map((evento) => evento.id), ['pendiente', 'viejo']);
    expect(fusionarEventos([local], [local]).map((evento) => evento.id), ['pendiente']);
  });

  test('el evento lo ven el dueño y un miembro, no alguien de fuera', () async {
    final db = FakeFirebaseFirestore();
    final datos = RepositorioDatos(db);
    const dueno = Usuario(id: 'abcdefghijklmnopqrst', nombre: 'Laura Angel', correo: 'laura@email.com');
    const miembro = Usuario(id: 'miembro-cuenta-xxxxxxxxxx', nombre: 'Ana Lopez', correo: 'ana@email.com');
    await datos.eventos.guardar(
      _viaje(
        'salida',
        hoy,
        hoy.add(const Duration(days: 1)),
        integrantes: [
          Integrante(id: dueno.id, nombre: 'Laura', colorFondo: 0, colorInicial: 0, estado: EstadoUnion.admin),
          Integrante(id: miembro.id, nombre: 'Ana', colorFondo: 0, colorInicial: 0, estado: EstadoUnion.unido),
          const Integrante(id: 'sofi', nombre: 'Sofi', colorFondo: 0, colorInicial: 0, estado: EstadoUnion.soloNombre),
        ],
      ),
      duenoId: dueno.id,
    );

    final delDueno = await datos.eventos.escuchar(dueno.id).first;
    final delMiembro = await datos.eventos.escuchar(miembro.id).first;
    final deFuera = await datos.eventos.escuchar('otro-uid-que-no-esta-aqui').first;
    expect(delDueno.map((evento) => evento.id), contains('salida'));
    expect(delMiembro.map((evento) => evento.id), contains('salida'));
    expect(deFuera, isEmpty);
  });
}

Evento _viaje(
  String id,
  DateTime inicio,
  DateTime fin, {
  List<Integrante> integrantes = const [],
}) {
  return Evento(
    id: id,
    nombre: 'Salida',
    lugar: '',
    inicio: inicio,
    fin: fin,
    portada: PortadaEvento.playa,
    codigo: 'SALIDA-1A',
    custodioId: integrantes.isEmpty ? 'local' : integrantes.first.id,
    integrantes: integrantes,
    gastos: const [],
    aportes: const [],
  );
}
