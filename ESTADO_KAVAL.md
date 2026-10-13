# Estado de Kaval

Fecha: 12 de octubre de 2026. Revisión de solo lectura del código en `kaval/`. No se cambió la app para escribir este reporte.

## 1. Resumen general

Estamos al cierre de la **fase 1** (pantallas, liquidación en memoria, español e inglés) y con la **actividad de Dio y errores** ya cableada para la presentación.

- Respecto al MVP de esta fase (las 13 pantallas, la liquidación, los idiomas y la demo de red): **cerca del 85%**.
- Respecto al producto completo (cuentas reales, Firestore sin conexión y dictado de voz): **cerca del 40%**.

Todo vive en memoria. Al cerrar la app se pierden los gastos y eventos creados en la sesión. Los viajes de Playa El Tunco y Ruta de las Flores son datos de ejemplo.

## 2. Pantallas del mockup

| Pantalla | Estado | Qué le falta |
|---|---|---|
| Onboarding | Completa | Nada de esta fase. Tres páginas, saltar e ir a login. |
| Login / Registro | Parcial | El formulario valida de verdad, pero el login es demo: cualquier correo válido y cualquier contraseña. Google y Apple solo avisan que es fase 2. |
| Inicio | Parcial | Los saldos se calculan de verdad, sobre eventos de ejemplo. No hay datos propios guardados. |
| Crear evento | Parcial | El formulario crea el evento en memoria. No se guarda al cerrar la app ni se sube a una nube. |
| Detalle del evento | Parcial | Muestra gastos y lleva a liquidar, dictar, invitar y agregar. Depende de los datos de la sesión. |
| Agregar gasto | Parcial | El formulario, el POST (201) y el PUT al editar (200) funcionan contra una API de prueba. El gasto queda solo en memoria. |
| Dictar gasto | Parcial | Hay animación y una frase fija. No usa el micrófono. |
| Confirmar gasto dictado | Parcial | Confirma un borrador de ejemplo (la gasolina), no algo que se haya dictado. |
| Liquidación | Completa | El cálculo en centavos y las transferencias mínimas están probados. Los viajes de arranque siguen siendo de ejemplo. |
| Efectivo del grupo | Parcial | Muestra el fondo, lo gastado y lo que sobra del ejemplo. No hay un alta propia de aportes; el botón abre el formulario de gasto. |
| Resumen y compartir | Parcial | Los números salen de la liquidación. WhatsApp, imagen, texto y PDF solo muestran un aviso. |
| Invitar al evento | Parcial | Muestra el código, lo copia y dibuja un QR falso. Unirse solo encuentra eventos que ya están en memoria. |
| Perfil y ajustes | Parcial | El idioma es/en sí cambia la app. Sincronizar y eliminar cuenta no tocan un servidor. El modo prueba solo aparece en debug. |

Hay una pantalla extra, **Control de errores** (`/errores/red`, `/errores/espera`, `/errores/sesion`), que no está en las 13 del mockup. También hay pestaña de Historial, fuera de esa lista.

## 3. Funcionalidades

| Función | Estado |
|---|---|
| Dio con interceptor | Hecho. Una instancia, `https://jsonplaceholder.typicode.com`, 10 s, headers `Content-Type` y `Authorization: Bearer kaval-demo`, logs `[kaval]` solo en debug. |
| Manejo de DioException | Hecho en login y en guardar/editar gasto. Timeout: aviso con Reintentar sin borrar el formulario. 400/422: mensaje junto al campo. Sin red y 401: pantalla de errores. |
| Pantalla Control de errores | Hecha, con tres variantes: sin red, espera y sesión. |
| Modo prueba de errores | Hecho, solo en debug, al final de Perfil. Timeout, sin red, 401 y 422. Se gasta en la siguiente llamada. |
| Firebase Auth (correo, Google, Apple) | Falta. No hay dependencia de Firebase. Google y Apple muestran un aviso. |
| Firestore con modo sin conexión | Falta. El interruptor de sincronizar solo cambia un valor en memoria. |
| Códigos de invitación | Parcial. El código se muestra, se copia y sirve para abrir un evento que ya está cargado. No invita a otra persona. |
| Dictado por voz | Falta. La pantalla es una maqueta. |
| Liquidación en centavos | Hecho y cubierto por tests (saldos de El Tunco, transferencias, efectivo sobrante, Ruta de las Flores). |
| Efectivo del grupo | Parcial. La regla de reparto está en la liquidación y se ve en pantalla. No se pueden registrar aportes nuevos fuera de los datos de ejemplo. |
| Idiomas es/en | Hecho. Arb en `lib/l10n` y selector ES/EN en Perfil. |
| Eliminación de cuenta | Parcial. Pide confirmación y vuelve a la bienvenida. No borra datos ni una cuenta real. |

## 4. Calidad

- `flutter analyze`: sin problemas (12,6 s, 12 de octubre de 2026).
- Tests: **11 pasaron** (7 de liquidación y 4 de clasificación de errores de red).
- Emulador: la sesión `flutter run -d emulator-5554` seguía abierta en el Pixel 7 al escribir este reporte. JDK de Flutter: Microsoft OpenJDK 21 en `C:\Users\OMEN\.jdks\microsoft-jdk-21\jdk-21.0.12.1+1` (no el JDK 25 de Android Studio).

## 5. Pendientes y riesgos

- El login no comprueba la contraseña contra nadie. El `POST /posts` solo prueba que hay red y que el interceptor corre.
- JSONPlaceholder no guarda nada. Un 201 o un 200 solo confirman la llamada; el gasto real está en `KavalState`.
- 401 y 422 del modo prueba dependen de `https://httpstat.us`. Si el emulador no tiene internet, esa llamada cae como “sin red” y no se ve el 422 en el campo ni la pantalla de sesión.
- El chip del modo prueba se usa una sola vez. Guardar sin haberlo tocado, o guardar por segunda vez, entra normal (eso fue el `← 201` de esta sesión).
- En la sesión que está corriendo, Perfil llegó a mostrar el aviso de debug “ListTile background color or ink splashes may be invisible”. El arreglo ya está en `tarjeta_kaval.dart`, pero esta sesión no se reinició. Hay que pulsar **R** en la terminal de `flutter run` antes de la demo.
- El emulador a veces se queda gris, pierde la conexión o no arranca desde el snapshot. Si pasa, arranque en frío: `emulator -avd Pixel_7 -no-snapshot-load`.
- `flutter doctor` sigue marcando licencias de Android como desconocidas. No bloqueó esta compilación. Falta el workload de C++ de Visual Studio; no hace falta para Android.
- No usar la palabra “vaquita” en la app. En la interfaz el fondo se llama “Efectivo del grupo”.

Para presentar mañana la actividad de interceptor y errores, el código ya está. Falta ensayar el orden (Perfil → chip → Guardar) con la consola de `flutter run` a la vista y con internet en el emulador.

## 6. Siguientes pasos

1. Pulsar **R** en la sesión del emulador y ensayar la demo: login (log `→` / `← 201`), timeout en el formulario, 422 en el campo, y las pantallas sin red, sesión y espera.
2. Si `httpstat.us` falla en el salón, tener a mano el caso de sin red y el de timeout, que no dependen de esa página.
3. No abrir Firebase ni el micrófono hasta después de la presentación: no están y no hacen falta para esta actividad.
4. Después: persistencia local, luego Firebase Auth y Firestore con modo sin conexión, y al final el dictado real.
