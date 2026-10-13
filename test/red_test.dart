import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaval/core/red/cliente_api.dart';

void main() {
  DioException error(DioExceptionType tipo, {int? codigo}) {
    return DioException(
      requestOptions: RequestOptions(path: '/posts'),
      type: tipo,
      response: codigo == null
          ? null
          : Response(
              requestOptions: RequestOptions(path: '/posts'),
              statusCode: codigo,
            ),
    );
  }

  test('sin red es connectionError', () {
    expect(clasificar(error(DioExceptionType.connectionError)), TipoFallo.sinRed);
  });

  test('timeout de conexión o de respuesta es espera', () {
    expect(clasificar(error(DioExceptionType.connectionTimeout)), TipoFallo.espera);
    expect(clasificar(error(DioExceptionType.receiveTimeout)), TipoFallo.espera);
  });

  test('401 es sesión y 422 es rechazo del formulario', () {
    expect(
      clasificar(error(DioExceptionType.badResponse, codigo: 401)),
      TipoFallo.sesion,
    );
    expect(
      clasificar(error(DioExceptionType.badResponse, codigo: 422)),
      TipoFallo.rechazo,
    );
  });

  test('el mensaje 422 sale del cuerpo y cae en el concepto', () {
    final fallo = DioException(
      requestOptions: RequestOptions(path: '/posts'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: '/posts'),
        statusCode: 422,
        data: '422 Unprocessable Entity',
      ),
    );
    expect(campoRechazado(fallo), 'concepto');
    expect(mensajeRechazo(fallo, 'respaldo'), '422 Unprocessable Entity');
  });
}
