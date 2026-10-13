# Kaval

Control de gastos para salidas y viajes. La app reparte lo que cada persona puso, calcula quién le debe a quién y muestra el efectivo del grupo. Los montos se guardan en centavos.

## Cómo correrla

Desde la raíz del repositorio:

```text
flutter pub get
flutter run -d emulator-5554
```

`emulator-5554` es el Pixel 7. Si no aparece en `flutter devices`, ábrelo desde Android Studio o con un arranque en frío:

```text
emulator -avd Pixel_7 -no-snapshot-load
```

## Entrar

Con Firebase configurado: correo y contraseña, y Google. Apple solo aparece en iPhone (`defaultTargetPlatform`); en Android y Windows el botón no está. Desde el login se puede pedir el enlace para recuperar la contraseña. En Perfil, eliminar la cuenta pide la contraseña otra vez y luego borra el perfil y la cuenta.

**Usar perfil local** sigue siendo el acceso de prueba. Entra como Laura, carga Playa El Tunco y Ruta de las Flores en el teléfono y no llama a Firestore. Sirve para ensayar la demo de errores sin una cuenta.

En esta máquina el proyecto `kaval-4216d` ya está conectado. En un clon nuevo, los archivos de cliente no vienen en git: hay que repetir los pasos de abajo o la app avisa que falta conectar Firebase. El perfil local igual entra.

## Firebase (una sola vez)

No descargues la llave privada de la cuenta de servicio. Si la consola te ofrece un JSON de admin, no lo guardes en el repo. El `.gitignore` ya deja fuera `google-services.json`, `GoogleService-Info.plist`, `*-firebase-adminsdk-*.json` y `serviceAccount`.

1. Entra a [Firebase console](https://console.firebase.google.com) y crea un proyecto, por ejemplo `kaval`.
2. Agrega una app Android con el paquete `com.kaval.app.kaval`.
3. Agrega una app iOS con el bundle id `com.kaval.app.kaval`.
4. En Authentication → Sign-in method activa Correo/contraseña, Google y Apple.
5. Crea la base Cloud Firestore.
6. En esta carpeta:

```text
dart pub global activate flutterfire_cli
firebase login
flutterfire configure --platforms=android,ios
```

Ese comando reemplaza `lib/firebase_options.dart` y escribe los archivos de cliente en el disco. Esos archivos de cliente no se suben: ya están ignorados. Vuelve a correr la app después.

7. Para Google en Android, el SHA-1 de debug se agrega en la ficha de la app Android. Desde `android`:

```text
.\gradlew signingReport
```

8. En el iPhone, en Xcode, activa la capacidad Sign in with Apple.
9. Publica las reglas (solo quien está en `integranteIds` lee y escribe el evento):

```text
firebase deploy --only firestore:rules
```

Las reglas están en `firestore.rules` y se explican ahí con comentarios.

## Qué está hecho y qué sigue simulado

Hecho:

- Pantallas del recorrido, liquidación en centavos, español e inglés, formularios.
- Dio con interceptor, Control de errores y modo prueba.
- Cuentas (correo, Google, Apple en iOS), recuperar contraseña, cerrar sesión y eliminar cuenta.
- Firestore: usuarios, eventos, integrantes, gastos y aportes, en centavos. Persistencia sin conexión. La tarjeta dice Sincronizado o Pendiente.
- Códigos de invitación (`TUNCO-7K2`) y unirse con el código. Quien no tiene cuenta solo tiene nombre.
- Opción para cargar el ejemplo de Playa El Tunco.

Sigue simulado:

- El `POST` y el `PUT` de un gasto van a `https://jsonplaceholder.typicode.com` para la demo. Si la llamada responde bien, el mismo gasto se guarda en Firestore cuando hay cuenta.
- Dictar un gasto es una animación. No usa el micrófono.
- Compartir y el QR no hablan con un servidor.

## Demo: interceptor y manejo de errores

Hay una sola instancia de Dio. Cada llamada pasa por un interceptor que agrega `Content-Type: application/json` y `Authorization: Bearer kaval-demo`. En modo debug escribe en la consola de `flutter run`, con el prefijo `[kaval]`:

- `→` la petición (método, URL y headers)
- `←` la respuesta y su código
- `✕` el error, el tipo de `DioException` y el código si lo hay

Esos renglones solo salen en debug. La sesión de `flutter run` ya lo es.

La interfaz no trata todos los fallos igual:

| Fallo | Qué hace la app al guardar o editar un gasto |
|---|---|
| Timeout (`connectionTimeout`, `receiveTimeout` o `sendTimeout`) | Un aviso con **Reintentar**. Lo escrito no se borra. |
| Sin red (`connectionError`) | Pantalla Sin conexión. **Seguir sin conexión** guarda el gasto en el teléfono y, si hay cuenta, lo deja pendiente de subir. |
| 400 o 422 | El mensaje del servidor queda en el formulario, junto al concepto (o al monto, si la respuesta lo nombra). El gasto no se guarda. |
| 401 | Pantalla de sesión vencida. **Iniciar sesión** vuelve al login. |

**Control de errores** es una pantalla aparte, para cuando el fallo no se resuelve en el mismo formulario. Tiene tres variantes:

- **Sin red:** Reintentar y Seguir sin conexión (esta última guarda el gasto en el teléfono).
- **Espera:** Reintentar.
- **Sesión:** Iniciar sesión.

**Modo prueba** está al final de Perfil y ajustes, y solo se ve en debug. Los chips son Timeout, Sin red, 401 y 422. El chip elegido se aplica a la **siguiente** llamada y después vuelve a normal.

### Pasos

1. En la terminal donde corre `flutter run`, pulsa **R** para cargar el último código. Deja esa consola visible: ahí aparecen los logs `[kaval]`.
2. Entra con **Usar perfil local** (o con tu cuenta, si Firebase ya está configurado).
3. Ve a **Perfil**, baja hasta **Modo prueba** y toca un chip.
4. Abre un viaje, **Agregar gasto** y pulsa **Guardar gasto**.
5. Mira la consola y la pantalla: el aviso, el mensaje en el campo o Control de errores, según el chip. Sin un chip, un guardado normal muestra `→ POST` y `← 201`, y el gasto queda guardado.

Cada chip se usa **una sola vez**. Si guardas otra vez sin elegir un chip nuevo, la llamada entra normal y el gasto sí se guarda.

401 y 422 dependen de `https://httpstat.us`. Si el emulador no tiene internet o esa página no responde, esa llamada cae como sin red y no verás el mensaje en el campo ni la pantalla de sesión. Timeout y Sin red no necesitan esa página.
