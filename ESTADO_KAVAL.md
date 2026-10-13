# Estado de Kaval

Fecha: 13 de octubre de 2026. La app está en la raíz del repositorio. El proyecto de Firebase es `kaval-4216d`. Dictado, QR y compartir siguen simulados: son la fase 3 y no se tocaron.

## 1. Hecho y probado

| Qué | Cómo se verificó |
|---|---|
| Correo y contraseña | En el Pixel 7. `pruebakaval1210@gmail.com` entra, muestra «Hola, Laura» y puede cerrar sesión. Un correo mal escrito muestra «El correo o la contraseña no coinciden». |
| Segunda cuenta | Se creó `ana.kaval1310@gmail.com` en el emulador. Al entrar, Inicio decía «Todavía no hay eventos en esta categoría» y el balance era $0.00. No veía Tunco ni la cena de Laura. |
| Unirse con código | Con Ana, en Eventos, «Unirme con código» y `TUNCO-7K2`. Apareció Playa El Tunco, el aviso «Listo, entraste al viaje» y la marca Sincronizado. Antes de unirse, esa cuenta no leía el viaje. |
| Reglas | `firestore.rules` en `kaval-4216d`. Un evento y sus gastos solo se leen y escriben si el uid está en `integranteIds`. Unirse solo puede agregar el uid propio. Los códigos no se pueden listar. |
| Evento a mano | Con Laura se creó «Cena de prueba» (`eventos/evento-1791914331113`). El detalle mostró Sincronizado, $0.00 y 7 integrantes. Falta confirmar el documento en la consola. |
| Gasto sin conexión | Con Ana, modo avión, en Tunco. Dio mostró «Sin conexión»; «Seguir sin conexión» guardó el gasto en el teléfono. El total pasó de $202.00 a $238.00. Al volver la red y abrir la app de nuevo, la tarjeta decía Sincronizado y el total seguía en $238.00. El teclado del emulador metió el texto dentro de la pista y el concepto quedó «Cena de mTaxiavionariscos», $36.00. |
| SHA-1 y SHA-256 de debug | Ya están en la app Android. SHA-1 `B7:36:A3:C9:70:63:22:84:58:2E:E2:88:E0:59:8D:E5:4E:32:FD:BE`. SHA-256 `4A:45:E1:AC:2D:A5:FB:14:A2:D9:06:87:7D:9F:BB:1E:0C:B7:2D:0C:DA:77:7A:EA:52:4F:13:C2:39:66:98:8E`. |
| Apple oculto fuera de iOS | En el login del Pixel 7 solo aparece Google. El botón de Apple usa `defaultTargetPlatform == TargetPlatform.iOS` (sin `dart:io`, para que la web siga analizando). El README lo dice. |
| Análisis y tests | `flutter analyze`: No issues found. `flutter test`: 22 pasaron. |

## 2. Hecho, sin la prueba visual final

- Google: el botón abre la pantalla de Google. Cancelar no muestra aviso. Si se interrumpe, no hay cuenta de Google en el teléfono o el SHA no coincide, hay una frase en español e inglés. Falta elegir una cuenta y volver a Kaval: el emulador no tiene una.
- Recuperar contraseña: el diálogo valida el correo y llama a `sendPasswordResetEmail`. Falta abrir el correo.
- Eliminar cuenta: pide confirmación y, si entraste con correo, la contraseña otra vez (`reauthenticateWithCredential`) antes de borrar el perfil y la cuenta. Revisa `mounted` después de cada espera. No se borró ninguna cuenta. No borrar `pruebakaval1210@gmail.com`.
- La marca Pendiente/Sincronizado del detalle ya no está fija: usa `evento.sincronizado`. Un gasto en la nube queda Pendiente hasta que Firestore lo confirma; el perfil local no. El test `un gasto en la nube queda pendiente hasta que Firestore lo confirma` lo cubre. En el teléfono, el primer gasto sin red se hizo con la pantalla vieja, que siempre decía Sincronizado. Falta ver la palabra Pendiente en el detalle y que pase a Sincronizado al volver la red.
- Persistencia de Firestore: `Settings(persistenceEnabled: true)` al arrancar. Si la lectura de integrantes o gastos falla sin red, se usa la caché para no tumbar la lista.

## 3. Qué falta

- Agregar una cuenta de Google en el Pixel 7 y terminar ese inicio. Los pasos están en el mensaje de esta sesión.
- Apple, en un iPhone, con la capacidad Sign in with Apple en Xcode.
- Abrir el correo de recuperar contraseña.
- Eliminar una cuenta de prueba (Ana u otra nueva), no la de Laura.
- En la consola, abrir `eventos/evento-1791914331113` y el gasto de $36 en `eventos/tunco-p5RifdGW02hRQcIhaMyod0uhQlI2/gastos`.
- Ver en el detalle la marca Pendiente con un gasto nuevo en modo avión, y Sincronizado al quitar el modo avión.
- Fase 3: dictado real, QR y compartir. En Efectivo del grupo, un aporte nuevo sigue abriendo el formulario de gasto.
- `google-services.json` y `GoogleService-Info.plist` no van en git.

## 4. Porcentaje

- Fase 2: **cerca del 90%**. Correo, segunda cuenta, código, reglas, evento a mano y un gasto que sobrevivió al modo avión ya se vieron. Siguen Google completo, el correo de recuperar, borrar una cuenta y la marca Pendiente en pantalla.
- Producto completo: **cerca del 80%**. Faltan dictado, QR y compartir de verdad, y Apple en un iPhone.

## 5. Calidad

- `flutter analyze` (13 de octubre de 2026): **No issues found.**
- `flutter test`: **22 pasaron.** 7 de liquidación, 4 de red, 3 de mensajes de sesión y 8 de repositorios y sincronización.
- JDK de Flutter: Microsoft OpenJDK 21 en `C:\Users\OMEN\.jdks\microsoft-jdk-21\jdk-21.0.12.1+1`.

## 6. Siguientes pasos

1. Agregar una cuenta de Google en el emulador y pulsar Google en el login.
2. En el detalle de Tunco, modo avión, guardar un gasto con concepto claro y comprobar que dice Pendiente. Quitar el modo avión y esperar Sincronizado.
3. En la consola, revisar la cena de prueba y el gasto de $36.
4. Pedir el enlace de recuperar contraseña y abrirlo.
5. Borrar solo una cuenta que se pueda perder.
6. Apple, cuando haya un iPhone.
7. Después: dictado, QR y compartir.
