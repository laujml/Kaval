import 'package:go_router/go_router.dart';

import '../features/auth/registro_page.dart';
import '../features/efectivo/efectivo_page.dart';
import '../features/errores/control_errores_page.dart';
import '../features/eventos/crear_evento_page.dart';
import '../features/eventos/detalle_evento_page.dart';
import '../features/eventos/eventos_page.dart';
import '../features/gastos/agregar_gasto_page.dart';
import '../features/gastos/confirmar_gasto_page.dart';
import '../features/gastos/dictar_gasto_page.dart';
import '../features/historial/historial_page.dart';
import '../features/inicio/inicio_page.dart';
import '../features/invitar/escanear_page.dart';
import '../features/invitar/invitar_page.dart';
import '../features/liquidacion/liquidacion_page.dart';
import '../features/onboarding/bienvenida_page.dart';
import '../features/perfil/perfil_page.dart';
import '../features/resumen/resumen_page.dart';
import '../features/shell/nav_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/bienvenida',
  routes: [
    GoRoute(path: '/bienvenida', builder: (context, state) => const BienvenidaPage()),
    GoRoute(
      path: '/auth',
      builder: (context, state) => RegistroPage(empezarEnLogin: state.uri.queryParameters['modo'] == 'login'),
    ),
    ShellRoute(
      builder: (context, state, child) => NavShell(child: child),
      routes: [
        GoRoute(path: '/inicio', builder: (context, state) => const InicioPage()),
        GoRoute(path: '/eventos', builder: (context, state) => const EventosPage()),
        GoRoute(path: '/historial', builder: (context, state) => const HistorialPage()),
        GoRoute(path: '/perfil', builder: (context, state) => const PerfilPage()),
      ],
    ),
    GoRoute(path: '/nuevo-evento', builder: (context, state) => const CrearEventoPage()),
    GoRoute(
      path: '/evento/:id',
      builder: (context, state) => DetalleEventoPage(eventoId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/evento/:id/gasto',
      builder: (context, state) => AgregarGastoPage(
        eventoId: state.pathParameters['id']!,
        gastoId: state.uri.queryParameters['editar'],
        desdeVoz: state.uri.queryParameters['voz'] == '1',
      ),
    ),
    GoRoute(
      path: '/errores/:tipo',
      builder: (context, state) => ControlErroresPage(
        tipo: tipoDesdeRuta(state.pathParameters['tipo']),
        paso: state.extra is PasoError ? state.extra! as PasoError : null,
      ),
    ),
    GoRoute(
      path: '/evento/:id/dictar',
      builder: (context, state) => DictarGastoPage(eventoId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/evento/:id/confirmar',
      builder: (context, state) => ConfirmarGastoPage(eventoId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/evento/:id/liquidar',
      builder: (context, state) => LiquidacionPage(eventoId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/evento/:id/efectivo',
      builder: (context, state) => EfectivoPage(eventoId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/evento/:id/resumen',
      builder: (context, state) => ResumenPage(eventoId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/evento/:id/invitar',
      builder: (context, state) => InvitarPage(eventoId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/escanear', builder: (context, state) => const EscanearPage()),
  ],
);
