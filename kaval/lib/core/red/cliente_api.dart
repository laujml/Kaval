import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Fallo que el modo prueba deja armado para la próxima llamada.
enum FalloForzado { ninguno, timeout, sinRed, noAutorizado, invalido }

/// Cómo debe reaccionar la pantalla. No es el tipo crudo de Dio.
enum TipoFallo { sinRed, espera, sesion, rechazo, otro }

/// Token fijo de la sesión de demostración. No hay servidor de auth en esta fase.
const tokenSesionDemo = 'kaval-demo';

/// Una sola instancia de Dio para login y gastos.
class ClienteApi {
  ClienteApi({Dio? dio}) : dio = dio ?? _crear();

  final Dio dio;

  static const baseUrl = 'https://jsonplaceholder.typicode.com';

  static Dio _crear() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    dio.interceptors.add(_interceptor());
    return dio;
  }

  /// El interceptor agrega los headers en cada llamada y solo escribe en debug.
  static Interceptor _interceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Content-Type'] = 'application/json';
        final token = options.extra['token'] as String? ?? tokenSesionDemo;
        options.headers['Authorization'] = 'Bearer $token';
        if (options.extra['fallo'] == FalloForzado.timeout.name) {
          // 1 ms: la llamada real falla antes de llegar, sin tocar el formulario.
          options.connectTimeout = const Duration(milliseconds: 1);
          options.receiveTimeout = const Duration(milliseconds: 1);
        }
        if (kDebugMode) {
          debugPrint('[kaval] → ${options.method} ${options.uri} ${options.headers}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          debugPrint('[kaval] ← ${response.statusCode} ${response.requestOptions.uri}');
        }
        handler.next(response);
      },
      onError: (error, handler) {
        if (kDebugMode) {
          debugPrint(
            '[kaval] ✕ ${error.type} ${error.response?.statusCode ?? '-'} ${error.requestOptions.uri}',
          );
        }
        handler.next(error);
      },
    );
  }

  /// POST /posts simula el login. JSONPlaceholder responde 201.
  Future<Response<dynamic>> iniciarSesion({
    required String correo,
    FalloForzado fallo = FalloForzado.ninguno,
  }) {
    return _enviar(
      metodo: 'POST',
      ruta: '/posts',
      datos: {'title': correo, 'body': 'login', 'userId': 1},
      fallo: fallo,
      codigoEsperado: 201,
    );
  }

  /// Alta con POST (201) o edición con PUT (200).
  Future<Response<dynamic>> guardarGasto({
    required Map<String, dynamic> datos,
    required bool edicion,
    FalloForzado fallo = FalloForzado.ninguno,
  }) {
    return _enviar(
      metodo: edicion ? 'PUT' : 'POST',
      ruta: edicion ? '/posts/1' : '/posts',
      datos: datos,
      fallo: fallo,
      codigoEsperado: edicion ? 200 : 201,
    );
  }

  Future<Response<dynamic>> _enviar({
    required String metodo,
    required String ruta,
    required Map<String, dynamic> datos,
    required FalloForzado fallo,
    required int codigoEsperado,
  }) async {
    final respuesta = await dio.request<dynamic>(
      _destino(ruta, fallo),
      data: datos,
      options: Options(
        method: metodo,
        extra: {'token': tokenSesionDemo, 'fallo': fallo.name},
      ),
    );
    if (respuesta.statusCode != codigoEsperado) {
      throw DioException(
        requestOptions: respuesta.requestOptions,
        response: respuesta,
        type: DioExceptionType.badResponse,
        message: 'Se esperaba $codigoEsperado y llegó ${respuesta.statusCode}',
      );
    }
    return respuesta;
  }

  /// Sin red y los códigos 401/422 salen de otra URL; el resto usa la API de prueba.
  String _destino(String ruta, FalloForzado fallo) {
    return switch (fallo) {
      FalloForzado.sinRed => 'https://no-existe.kaval.invalid/posts',
      FalloForzado.noAutorizado => 'https://httpstat.us/401',
      FalloForzado.invalido => 'https://httpstat.us/422',
      FalloForzado.ninguno || FalloForzado.timeout => ruta,
    };
  }
}

TipoFallo clasificar(DioException error) {
  final codigo = error.response?.statusCode;
  if (codigo == 401) return TipoFallo.sesion;
  if (codigo == 400 || codigo == 422) return TipoFallo.rechazo;
  return switch (error.type) {
    DioExceptionType.connectionError => TipoFallo.sinRed,
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.sendTimeout =>
      TipoFallo.espera,
    _ => TipoFallo.otro,
  };
}

/// 422 junto al monto solo si el cuerpo lo nombra. Si no, cae en el concepto.
String campoRechazado(DioException error) {
  final data = error.response?.data;
  if (data is Map && data.containsKey('monto') && !data.containsKey('concepto')) {
    return 'monto';
  }
  return 'concepto';
}

String mensajeRechazo(DioException error, String respaldo) {
  final data = error.response?.data;
  if (data is Map) {
    for (final clave in ['concepto', 'monto', 'message', 'error', 'mensaje']) {
      final valor = data[clave];
      if (valor is String && valor.trim().isNotEmpty) return valor.trim();
      if (valor is List && valor.isNotEmpty) return valor.first.toString();
    }
  }
  if (data is String) {
    final texto = data.trim();
    if (texto.isNotEmpty && texto.length < 180) return texto;
  }
  return respaldo;
}
