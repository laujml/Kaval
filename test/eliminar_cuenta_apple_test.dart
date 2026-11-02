import 'package:flutter_test/flutter_test.dart';
import 'package:kaval/data/servicio_auth.dart';

import 'fixtures/auth_falsa.dart';

// BUG-002 (AUTH-013): una cuenta de Apple se reautentica con apple.com
// y después se puede eliminar.
void main() {
  test('una cuenta de Apple se reautentica con apple.com y se elimina', () async {
    final cuenta = CuentaFalsa(uid: 'apple-uid', proveedores: ['apple.com']);
    final auth = ServicioAuth(auth: AuthFalsa(cuenta), listo: true);

    expect(auth.pideContrasenaParaBorrar, isFalse);
    expect(await auth.reautenticar(), isTrue);
    expect(cuenta.reautenticadoCon, ['apple.com']);

    await auth.eliminarCuenta();
    expect(cuenta.borrada, isTrue);
  });
}
