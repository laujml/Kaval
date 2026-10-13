# Contexto de Kaval

Actualizado el 13 de octubre de 2026. El detalle del avance está en [ESTADO_KAVAL.md](ESTADO_KAVAL.md).

## Qué es

App Flutter de control de gastos para salidas y viajes. Paquete `kaval`, organización `com.kaval.app`, application id `com.kaval.app.kaval`. El código está en la raíz del repositorio, no en una carpeta `kaval` interna. Curso de Aplicaciones Móviles. No usar la palabra “vaquita”; en la interfaz el fondo común es “Efectivo del grupo”.

Coral de la marca: `#FF6B4A`. Los montos son `int` en centavos. La liquidación de `lib/core/liquidacion/liquidacion.dart` no se modifica para “mejorar” el orden de las transferencias: los tests de Playa El Tunco son la referencia.

## Fase actual

Fase 1 cerrada y ya en GitHub: pantallas, Provider, go_router, liquidación, es/en, Dio y Control de errores.

Fase 2 probada, sin commit: Firebase Auth, Firestore, repositorios, invitaciones y `firestore.rules` publicadas en `kaval-4216d`. El correo de prueba cargó Playa El Tunco y la consola muestra `codigos/TUNCO-7K2`. El perfil local sigue sirviendo para la demo sin escribir en Firestore.

## Datos

- Perfil local (`usuario.local`, id `laura`): eventos de ejemplo en memoria, incluido Ruta de las Flores. No escribe en Firestore. El POST de Dio al guardar un gasto sí corre, para la demo de errores.
- Cuenta real: el uid reemplaza a Laura en el ejemplo de Tunco, así “tu parte” sigue siendo la de ella. El resto del grupo de ese ejemplo queda solo con nombre.
- Al abrir la app, la lista de viajes empieza vacía. “Cargar ejemplo de Playa El Tunco” la llena (en memoria, o en Firestore si hay sesión).
- Colecciones: `usuarios/{uid}`, `eventos/{id}` con `integranteIds`, subcolecciones `integrantes`, `gastos` y `aportes`, y `codigos/{CODIGO}` → `eventoId`.
- Persistencia de Firestore encendida al arrancar. La tarjeta usa `hasPendingWrites`: Sincronizado o Pendiente.
- El interruptor “Sincronizar con la nube” llama a `enableNetwork` / `disableNetwork`.

## Auth

Correo y contraseña, Google, y Sign in with Apple solo si la plataforma es iOS. Recuperar contraseña, cerrar sesión y eliminar cuenta desde Perfil. Los códigos de `FirebaseAuthException` se traducen en `lib/core/auth/mensajes_auth.dart`.

## Cómo correrla

Desde la raíz del repositorio:

```text
flutter pub get
flutter run -d emulator-5554
```

Emulador: Pixel 7. Si no aparece, arranque en frío: `emulator -avd Pixel_7 -no-snapshot-load`.

Flutter usa Microsoft OpenJDK 21 (`C:\Users\OMEN\.jdks\microsoft-jdk-21\jdk-21.0.12.1+1`), no el JDK 25 de Android Studio. Gradle: `-Xmx2G` y `org.gradle.workers.max=2`.

## Demo de errores

En Perfil, “Modo prueba (solo debug)”, elegir un fallo y después **Guardar gasto**. El fallo se consume una vez. Los logs salen con el prefijo `[kaval]`. El login ya no hace el POST de prueba: esa llamada quedó en el alta y la edición del gasto.

## Git

No hacer commit ni push desde el agente. Laura los hace a mano para que el autor sea solo ella. Mensaje sugerido al cerrar la fase 2: “Kaval fase 2: cuentas Firebase, Firestore sin conexión e invitaciones”.
