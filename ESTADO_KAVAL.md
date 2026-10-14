# Estado de Kaval

Fecha: 13 de octubre de 2026. La app está en la raíz del repositorio. El proyecto de Firebase es `kaval-4216d`.

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
| Apple oculto fuera de iOS | En el login del Pixel 7 solo aparece Google. El botón de Apple usa `defaultTargetPlatform == TargetPlatform.iOS`. |
| Parser de voz y QR | `flutter test`: «pagué 25 dólares de pupusas» queda en $25.00 y Pupusas. También gasolina, decimales, inglés, es-SV y un código dentro de un texto. No usa el micrófono. |
| Análisis y tests | `flutter analyze`: No issues found. `flutter test`: 30 pasaron. |

## 2. Hecho, sin probar en el Pixel 7

- Dictado: `speech_to_text` pide el micrófono, escucha en es-SV (o es) y en inglés, y abre Nuevo gasto con monto y concepto. No guarda solo. Permiso denegado, sin red y frase sin monto tienen aviso. Hay que decirlo en voz alta y pulsar Guardar.
- QR: la invitación muestra el código del viaje. Escanear usa `mobile_scanner` y la misma unión que el código escrito. Un QR sin código, uno inválido o la cámara denegada tienen aviso.
- Compartir: WhatsApp y Enlace mandan el código por la hoja del sistema. Liquidar y el resumen mandan el texto de la liquidación, con «Efectivo del grupo». El PDF sigue siendo el aviso de Pro. No se genera una imagen.
- Permisos: `RECORD_AUDIO` y `CAMERA` en el AndroidManifest. En iOS, micrófono, reconocimiento de voz y cámara en `Info.plist`.
- Google: el botón abre la pantalla de Google. Falta elegir una cuenta en el emulador.
- Recuperar contraseña y eliminar cuenta (con la contraseña otra vez). No borrar `pruebakaval1210@gmail.com`.
- Ver la marca Pendiente en el detalle con un gasto nuevo en modo avión, y Sincronizado al volver la red.

## 3. Qué falta

- Probar en el Pixel 7 el dictado, el QR y compartir. El emulador tiene que aceptar el micrófono y la cámara.
- Agregar una cuenta de Google en el emulador y terminar ese inicio.
- Apple, en un iPhone, con Sign in with Apple en Xcode.
- Abrir el correo de recuperar contraseña y borrar solo una cuenta de prueba.
- En la consola, abrir `eventos/evento-1791914331113` y el gasto de $36.
- En Efectivo del grupo, un aporte nuevo sigue abriendo el formulario de gasto.
- `google-services.json` y `GoogleService-Info.plist` no van en git.

## 4. Porcentaje

- Fase 2: **cerca del 90%**. Siguen Google completo, el correo de recuperar, borrar una cuenta y la marca Pendiente en pantalla.
- Fase 3: **el código está**. Falta verlo en el teléfono: micrófono, cámara y la hoja de compartir.
- Producto completo: **cerca del 90%**. Además de esas pruebas, faltan la imagen o el PDF del resumen y Apple en un iPhone.

## 5. Calidad

- `flutter analyze` (13 de octubre de 2026, después de la revisión visual): **No issues found.**
- `flutter test`: **30 pasaron.** 7 de liquidación, 4 de red, 3 de mensajes de sesión, 8 de repositorios y 8 de voz, idioma y QR.

## 7. Revisión visual

El tema claro y el oscuro salen de `temaKaval`. El teléfono usa el modo del sistema. Colores, tipo, espacios, radios, botones, chips, tarjetas, campos, AppBar, diálogos y el estado vacío viven en `KavalPaleta`, `KavalMedidas` y los widgets `EstadoVacio` y `MarcoKaval`.

Las 13 pantallas de Stitch (bienvenida, login, inicio, crear evento, detalle, nuevo gasto, dictar, confirmar, liquidar, Efectivo del grupo, resumen, invitar y perfil) se dejaron como el mockup. En oscuro siguen en crema, porque el mockup fija ese fondo y el texto marino.

| Pantalla | Antes | Después |
|---|---|---|
| Control de errores | Fondo crema, círculo rosa suelto (`#FFE0E0`) y botones sin el mismo margen | Círculo pastel del tema, botón de cierre de 48, ancho máximo en tablet y los tres estados (red, espera, sesión) |
| Historial | Lista armada a mano, sin vacío | `ListView.builder`, título del tema y estado vacío si no hay viajes |
| Eventos | Botones y huecos sueltos; si no había viajes, la lista quedaba en blanco | Mismos botones con el espaciado del tema y un estado vacío |
| Escanear | Pantalla entera marino, distinta al resto | Fondo del tema, cámara en tarjeta redondeada y marco coral |
| Recuperar contraseña | `AlertDialog` genérico | Diálogo del tema, con scroll y acciones de 48 |
| Unirme con código | Igual que el anterior | Igual que recuperar |
| Privacidad, eliminar cuenta y volver a pedir la contraseña | Diálogos planos; eliminar no se leía como acción peligrosa | Mismo diálogo; eliminar va en rojo del tema |
| Perfil (íconos) | Nube en azul suelto y borrar en rosa suelto | Menta y rosa de la paleta. La pantalla sigue el mockup 13 |
- JDK de Flutter: Microsoft OpenJDK 21 en `C:\Users\OMEN\.jdks\microsoft-jdk-21\jdk-21.0.12.1+1`.

## 6. Siguientes pasos

1. En el Pixel 7, dictar «pagué 25 dólares de pupusas», revisar Nuevo gasto y guardar.
2. En Invitar, mirar el QR. Con otra cuenta, Escanear código y entrar a Tunco.
3. Compartir el código y, en Liquidar, compartir el resumen.
4. Negar el micrófono y la cámara una vez, para leer los avisos.
5. Lo que seguía de la fase 2: cuenta de Google en el emulador, correo de recuperar, y Pendiente en modo avión.
6. En el Pixel 7, mirar Historial, Eventos vacío, Escanear, Control de errores y los diálogos, en claro y en oscuro, a 360 px y en una ventana ancha.
