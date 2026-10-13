import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/usuario.dart';
import '../datos_ejemplo.dart';
import 'repositorio_aportes.dart';
import 'repositorio_eventos.dart';
import 'repositorio_gastos.dart';
import 'repositorio_integrantes.dart';
import 'repositorio_usuarios.dart';

/// Junta los repositorios que usa el estado de la app.
class RepositorioDatos {
  RepositorioDatos(this.db)
      : usuarios = RepositorioUsuarios(db),
        eventos = RepositorioEventos(db),
        integrantes = RepositorioIntegrantes(db),
        gastos = RepositorioGastos(db),
        aportes = RepositorioAportes(db);

  final FirebaseFirestore db;
  final RepositorioUsuarios usuarios;
  final RepositorioEventos eventos;
  final RepositorioIntegrantes integrantes;
  final RepositorioGastos gastos;
  final RepositorioAportes aportes;

  /// Copia Playa El Tunco a la cuenta actual. El id de Laura pasa a ser el uid.
  Future<void> cargarTunco(Usuario usuario) async {
    final evento = tuncoParaCuenta(usuario);
    final guardado = await eventos.guardar(evento, duenoId: usuario.id);
    for (var i = 0; i < guardado.gastos.length; i++) {
      await gastos.guardar(guardado.id, guardado.gastos[i], orden: i);
    }
    for (var i = 0; i < guardado.aportes.length; i++) {
      await aportes.guardar(guardado.id, guardado.aportes[i], orden: i);
    }
  }
}
