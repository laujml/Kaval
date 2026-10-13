# Kaval

Control de gastos para salidas y viajes. La app reparte lo que cada persona puso, calcula quién le debe a quién y muestra el efectivo del grupo. Los montos se guardan en centavos.

## Cómo correrla

Desde esta carpeta (`kaval`):

```text
flutter pub get
flutter run -d emulator-5554
```

`emulator-5554` es el Pixel 7. Si no aparece en `flutter devices`, ábrelo desde Android Studio o con un arranque en frío:

```text
emulator -avd Pixel_7 -no-snapshot-load
```

## Login demo

Cualquier correo válido y cualquier contraseña. No se comprueba la contraseña contra un servidor. Antes de entrar, la app hace un `POST /posts` de prueba para ver si hay red.

Google, Apple y “usar perfil local” no crean una cuenta real. El perfil local entra sin llamar a la red.

## Fase 1: qué está hecho y qué es simulado

Hecho en esta fase:

- Las pantallas del recorrido (bienvenida, login, inicio, eventos, gasto, liquidación, efectivo, resumen, invitar y perfil).
- Liquidación en centavos, con tests.
- Textos en español e inglés (selector ES/EN en Perfil).
- Formularios con validación.
- Dio con interceptor, manejo de errores y modo prueba para la demo.

Simulado, solo en memoria:

- El login no autentica. Al cerrar la app se pierden los gastos y eventos creados en la sesión.
- Los viajes de ejemplo (Playa El Tunco y Ruta de las Flores) vienen cargados.
- El `POST` y el `PUT` van a `https://jsonplaceholder.typicode.com`. Un 201 o un 200 solo confirman la llamada; el gasto de verdad queda en la app.
- Dictar un gasto es una animación con una frase fija. No usa el micrófono.
- Compartir, el QR de invitación, sincronizar y eliminar cuenta no hablan con un servidor.
- No hay Firebase.

## Demo: interceptor y manejo de errores

Hay una sola instancia de Dio. Cada llamada pasa por un interceptor que agrega `Content-Type: application/json` y `Authorization: Bearer kaval-demo`. En modo debug escribe en la consola de `flutter run`, con el prefijo `[kaval]`:

- `→` la petición (método, URL y headers)
- `←` la respuesta y su código
- `✕` el error, el tipo de `DioException` y el código si lo hay

Esos renglones solo salen en debug. La sesión de `flutter run` ya lo es.

La interfaz no trata todos los fallos igual:

| Fallo | Qué hace la app |
|---|---|
| Timeout (`connectionTimeout`, `receiveTimeout` o `sendTimeout`) | En **Agregar gasto**, un aviso con **Reintentar**. Lo escrito no se borra. En el **login**, abre la pantalla de espera. |
| Sin red (`connectionError`) | En el **login**, un aviso que ofrece el perfil local. En **Agregar gasto**, la pantalla Sin conexión. |
| 400 o 422 | El mensaje del servidor queda en el formulario, junto al concepto (o al monto, si la respuesta lo nombra). El gasto no se guarda. |
| 401 | Pantalla de sesión vencida. **Iniciar sesión** vuelve al login. |

**Control de errores** es una pantalla aparte, para cuando el fallo no se resuelve en el mismo formulario. Tiene tres variantes:

- **Sin red:** Reintentar y Seguir sin conexión (esta última guarda el gasto en el teléfono).
- **Espera:** Reintentar.
- **Sesión:** Iniciar sesión.

**Modo prueba** está al final de Perfil y ajustes, y solo se ve en debug. Los chips son Timeout, Sin red, 401 y 422. El chip elegido se aplica a la **siguiente** llamada y después vuelve a normal.

### Pasos

1. En la terminal donde corre `flutter run`, pulsa **R** para cargar el último código. Deja esa consola visible: ahí aparecen los logs `[kaval]`.
2. Entra con el login demo (correo válido y cualquier contraseña). Debes ver `→ POST` y `← 201`.
3. Ve a **Perfil**, baja hasta **Modo prueba** y toca un chip.
4. Abre un viaje, **Agregar gasto** y pulsa **Guardar gasto**.
5. Mira la consola y la pantalla: el aviso, el mensaje en el campo o Control de errores, según el chip.

Cada chip se usa **una sola vez**. Si guardas otra vez sin elegir un chip nuevo, la llamada entra normal y el gasto sí se guarda.

401 y 422 dependen de `https://httpstat.us`. Si el emulador no tiene internet o esa página no responde, esa llamada cae como sin red y no verás el mensaje en el campo ni la pantalla de sesión. Timeout y Sin red no necesitan esa página.
