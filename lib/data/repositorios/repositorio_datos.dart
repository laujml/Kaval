import 'package:cloud_firestore/cloud_firestore.dart';

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
}
