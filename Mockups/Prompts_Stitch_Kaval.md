# Prompts para Google Stitch — Kaval: Control de Gastos para Salidas y Viajes

Proyecto de Desarrollo de Aplicaciones Móviles · Laura Angel · El Salvador
App Flutter (iOS/Android). Mockups de referencia: carpeta `Mockups/` (13 pantallas, 390×844).

**Cómo usarlos:** en Stitch, pega primero el **prompt de estilo general** (o pégalo al inicio de cada prompt de pantalla). Luego pega el prompt de cada pantalla. Cada prompt viene en español y en inglés (Stitch suele dar mejores resultados en inglés). Si Stitch cambia el estilo, agrega al final: *"Mantén exactamente el mismo estilo visual que las pantallas anteriores."*

**Datos de ejemplo (consistentes en todas las pantallas):** evento "Playa El Tunco 🌊" (2–4 oct, La Libertad), integrantes Laura (tú), Ana, Luis, Sofi, Diego, Carla. Gastos: Hospedaje $120.00 (pagó Sofi, 6 personas), Gasolina $24.00 (pagó Laura, 6), Entradas beach club $30.00 (pagó Luis, 6), Pupusas $18.50 (efectivo del grupo, 5), Cocos y agua $9.50 (efectivo del grupo, 5). Total $202.00. Saldos: Laura −$10.60, Ana −$13.60, Luis +$2.40, Sofi +$85.40, Diego −$34.60, Carla −$29.00. Efectivo del grupo: Ana $60 (cajero) + Luis $20 = $80; gastado $28; efectivo sobrante $52.

---

## 0 · Prompt de estilo general

**ES**
```
Diseña una app móvil llamada "Kaval: Control de Gastos para Salidas y Viajes" (gastos compartidos en grupo, USD, en español). Estilo de app de viajes súper amigable: ilustraciones planas y suaves de escenas de viaje de El Salvador (playa con palmeras y la roca de El Tunco, volcán, pupusas, road trip). Fondos pastel (crema #FFF8F0, menta #DFF5EB, durazno #FFE9DE) y UN solo color de acento coral-naranja #FF6B4A para botones y acciones. Texto azul tinta #1F2A3B; verde #1FA971 para saldos a favor y rojo #E5484D para deudas. Tarjetas muy redondeadas (24–30 px), sombras suaves, mucho espacio en blanco. Tipografía grande y amigable: Poppins para títulos y Nunito para texto. Avatares ilustrados redondos. Chips de categorías con emoji. Barra inferior simple: Inicio, Eventos, botón central flotante de micrófono (coral), Historial, Perfil. Teléfono 390×844.
```

**EN**
```
Design a mobile app called "Kaval: Control de Gastos para Salidas y Viajes" (group expense splitting for trips and outings, USD, UI text in Spanish). Super friendly travel-app style: soft flat illustrations of El Salvador travel scenes (beach with palm trees and El Tunco rock, volcano, pupusas, road trip). Pastel backgrounds (cream #FFF8F0, mint #DFF5EB, peach #FFE9DE) with ONE strong coral-orange accent #FF6B4A for buttons and actions. Ink-navy text #1F2A3B; green #1FA971 for money owed to you, red #E5484D for debts. Very rounded cards (24–30px), soft shadows, generous whitespace. Large friendly typography: Poppins for headings, Nunito for body. Round illustrated avatars. Category chips with emoji. Simple bottom nav: Inicio, Eventos, central floating coral microphone button, Historial, Perfil. Phone frame 390×844.
```

---

## 1 · Onboarding / Bienvenida

**ES**
```
Pantalla de bienvenida de Kaval. Arriba: logo (maleta blanca en cuadro coral redondeado) + "kaval" y "Saltar" a la derecha. Ilustración grande en tarjeta redondeada: playa de El Tunco con palmera, volcán al fondo, sol y avión de papel. Sobre la ilustración flotan 3 tarjetitas blancas: "🫓 Pupusas $18.50 · Efectivo · 5 personas", una burbuja con micrófono "“pagué 24 de gasolina”" y "⛽ Gasolina $24.00 · Pagó Laura · 6 personas". Título grande: "Viajen juntos, cuentas claras ✨" (la palabra "claras" en coral). Subtítulo: "Dicta tus gastos, mira quién le debe a quién y comparte el resumen en segundos." Indicador de páginas (3 puntos). Botón coral ancho "Comenzar →" y enlace "¿Ya tienes cuenta? Inicia sesión".
```
**EN**
```
Kaval welcome/onboarding screen. Top: logo (white suitcase in a rounded coral square) + "kaval" wordmark, "Saltar" (skip) on the right. Large illustration in a rounded card: El Tunco beach with a palm tree, volcano in the background, sun and a paper plane. Three small white floating cards over it: "🫓 Pupusas $18.50 · Efectivo · 5 personas", a mic bubble "“pagué 24 de gasolina”", and "⛽ Gasolina $24.00 · Pagó Laura · 6 personas". Big headline: "Viajen juntos, cuentas claras ✨" (word "claras" in coral). Subtitle: "Dicta tus gastos, mira quién le debe a quién y comparte el resumen en segundos." 3-dot page indicator. Full-width coral button "Comenzar →" and link "¿Ya tienes cuenta? Inicia sesión".
```

## 2 · Login / Registro

**ES**
```
Pantalla de inicio de sesión de Kaval. Mitad superior: ilustración de road trip (carro coral con tabla de surf en el techo, colinas verdes, letrero "El Tunco"). Encima, una tarjeta blanca grande y redondeada con logo y "¡Hola de nuevo! 👋 / Tus viajes y cuentas, sincronizados." Selector segmentado "Iniciar sesión | Crear cuenta". Campos: Correo electrónico (laura.angel@email.com, con borde coral de foco) y Contraseña con ícono de ojo. Enlace "¿Olvidaste tu contraseña?". Botón coral "Iniciar sesión". Separador "o continúa con" y dos botones blancos: "Google" y "Apple". Abajo: "¿Sin internet? Usar perfil local >".
```
**EN**
```
Kaval login/sign-up screen. Top half: road-trip illustration (coral car with a surfboard on the roof, green hills, road sign "El Tunco"). Over it, a large rounded white card with the logo and "¡Hola de nuevo! 👋 / Tus viajes y cuentas, sincronizados." Segmented control "Iniciar sesión | Crear cuenta". Fields: email (laura.angel@email.com, coral focus border) and password with an eye icon. Link "¿Olvidaste tu contraseña?". Coral button "Iniciar sesión". Divider "o continúa con" and two white buttons: "Google" and "Apple". Bottom: "¿Sin internet? Usar perfil local >" (offline local profile).
```

## 3 · Inicio

**ES**
```
Pantalla de inicio de Kaval. Encabezado: avatar ilustrado de Laura, "Hola, Laura 👋" y "¿A dónde vamos hoy?", campana con punto coral. Tarjeta grande en degradado coral: "Balance general +$4.65" con pastillas "↓ Te deben $15.25" y "↑ Debes $10.60" e ilustración de monedas. Fila de chips: Todos (activo, oscuro), 🏖️ Playa, 🌋 Volcán, 🍽️ Comidas, 🚗 Road trip. Sección "Eventos activos / Ver todos" con carrusel horizontal de tarjetas: "Playa El Tunco 🌊 · La Libertad · 2–4 oct", ilustración de playa, etiqueta "Sincronizado", 6 avatares, "Total $202.00", etiqueta roja "Debes $10.60"; segunda tarjeta asomando: "Ruta de las Flores 🌸 · $86.00 · Te deben $15.25". Tip en menta: "solo di “pagué 24 de gasolina” 🎙️". Barra inferior con micrófono central flotante.
```
**EN**
```
Kaval home screen. Header: Laura's illustrated avatar, "Hola, Laura 👋" and "¿A dónde vamos hoy?", bell icon with a coral dot. Big coral-gradient card: "Balance general +$4.65" with pills "↓ Te deben $15.25" and "↑ Debes $10.60" plus a coins illustration. Chip row: Todos (active, dark), 🏖️ Playa, 🌋 Volcán, 🍽️ Comidas, 🚗 Road trip. Section "Eventos activos / Ver todos" with a horizontal carousel of event cards: "Playa El Tunco 🌊 · La Libertad · 2–4 oct", beach illustration, "Sincronizado" badge, 6 avatars, "Total $202.00", red tag "Debes $10.60"; a second card peeking: "Ruta de las Flores 🌸 · $86.00 · Te deben $15.25". Mint tip bar: "solo di “pagué 24 de gasolina” 🎙️". Bottom nav with central floating mic button.
```

## 4 · Crear evento + integrantes

**ES**
```
Pantalla "Nuevo evento" de Kaval. Botón atrás y título centrado. Campo "Nombre del evento" con "Playa El Tunco 🌊" (borde coral de foco). "Portada": 4 miniaturas ilustradas redondeadas (Playa seleccionada con anillo coral y check, Volcán, Comida, Road trip). Dos campos de fecha "Inicio 2 oct 2026" y "Fin 4 oct 2026" con ícono de calendario. Franja menta "Moneda: USD ($) · Fija". Sección "Integrantes (6)" con enlace coral "Invitar con código": chips con avatar y nombre (Laura con etiqueta "Tú", Ana, Luis, Sofi, Diego, Carla, cada uno con ×). Campo "Agregar por nombre…" con botón + coral. Botón coral fijo abajo "✓ Crear evento".
```
**EN**
```
Kaval "Nuevo evento" (create event) screen. Back button and centered title. Field "Nombre del evento" filled with "Playa El Tunco 🌊" (coral focus border). "Portada" (cover): 4 rounded illustrated thumbnails (Playa selected with coral ring and check, Volcán, Comida, Road trip). Two date fields "Inicio 2 oct 2026" and "Fin 4 oct 2026" with calendar icons. Mint strip "Moneda: USD ($) · Fija". Section "Integrantes (6)" with coral link "Invitar con código": avatar chips with names (Laura tagged "Tú", Ana, Luis, Sofi, Diego, Carla, each with ×). Input "Agregar por nombre…" (add guest by name) with a coral + button. Sticky bottom coral button "✓ Crear evento".
```

## 5 · Detalle del evento

**ES**
```
Pantalla de detalle del evento "Playa El Tunco 🌊". Arriba ilustración de playa a todo lo ancho con botones flotantes (atrás, compartir, integrantes). Tarjeta blanca superpuesta: título, etiqueta verde "☁ Sincronizado", "2–4 oct · 6 integrantes · USD" y 3 métricas: Total $202.00 | Tu parte $34.60 | Debes $10.60 (rojo). "Saldos por persona / Liquidar →": carrusel de mini tarjetas con avatar: Tú −$10.60 (borde coral), Ana −$13.60, Luis +$2.40, Sofi +$85.40, Diego −$34.60, Carla −$29.00 (verde/rojo). "Gastos (5)": filas con ícono emoji en cuadro pastel: ⛽ Gasolina $24.00 "Pagó Laura · 6 personas" con etiqueta "🎙️ Dictado"; 🫓 Pupusas $18.50 "Efectivo del grupo · 5" etiqueta "💵 Efectivo"; 🥥 Cocos y agua $9.50; 🎟️ Entradas beach club $30.00; 🏠 Hospedaje $120.00. Barra inferior: "Liquidar" (blanco), micrófono coral central, "+ Gasto" (coral).
```
**EN**
```
Event detail screen for "Playa El Tunco 🌊". Full-width beach illustration header with floating buttons (back, share, members). Overlapping white card: title, green badge "☁ Sincronizado" (synced), "2–4 oct · 6 integrantes · USD" and 3 stats: Total $202.00 | Tu parte $34.60 | Debes $10.60 (red). "Saldos por persona / Liquidar →": horizontal mini cards with avatars: Tú −$10.60 (coral outline), Ana −$13.60, Luis +$2.40, Sofi +$85.40, Diego −$34.60, Carla −$29.00 (green/red). "Gastos (5)" list rows with emoji in pastel tiles: ⛽ Gasolina $24.00 "Pagó Laura · 6 personas" tagged "🎙️ Dictado"; 🫓 Pupusas $18.50 "Efectivo del grupo · 5" tagged "💵 Efectivo"; 🥥 Cocos y agua $9.50; 🎟️ Entradas beach club $30.00; 🏠 Hospedaje $120.00. Bottom bar: "Liquidar" (white), central coral mic, "+ Gasto" (coral).
```

## 6 · Agregar gasto manual (≤ 4 toques)

**ES**
```
Pantalla "Nuevo gasto" (Playa El Tunco). Pasos numerados con círculos coral 1–4. (1) Tarjeta durazno con monto grande "$36.00" y campo "Cena de mariscos 🦐". Chips de categoría: 🍽️ Comida (seleccionada), ⛽ Transporte, 🏠 Hospedaje, 🎉 Diversión. (2) "¿Quién pagó?": fila de 6 avatares (Diego seleccionado con anillo coral). (3) "¿Entre quiénes?" con chip coral "✓ Todos": lista Laura (tú) $6.00 ✓, Ana $6.00 ✓ y "+4 más · $6.00 c/u · Ajustar". Selector "💳 Tarjeta | 💵 Efectivo del grupo". (4) Botón coral fijo "Guardar gasto · $36.00". Botón de micrófono arriba a la derecha para dictar.
```
**EN**
```
"Nuevo gasto" (add expense manually) screen for Playa El Tunco, designed for 4 taps max with coral numbered step circles 1–4. (1) Peach card with large amount "$36.00" and concept field "Cena de mariscos 🦐". Category chips: 🍽️ Comida (selected), ⛽ Transporte, 🏠 Hospedaje, 🎉 Diversión. (2) "¿Quién pagó?": row of 6 avatars (Diego selected with coral ring). (3) "¿Entre quiénes?" with coral chip "✓ Todos": list Laura (tú) $6.00 ✓, Ana $6.00 ✓ and "+4 más · $6.00 c/u · Ajustar". Segmented "💳 Tarjeta | 💵 Efectivo del grupo". (4) Sticky coral button "Guardar gasto · $36.00". Mic button top-right to dictate instead.
```

## 7 · Dictar gasto (grabando)

**ES**
```
Pantalla de dictado por voz, fondo degradado durazno a crema. Arriba: cerrar, chip "🌊 Playa El Tunco", ayuda. Indicador rojo "● ESCUCHANDO · 0:04". Transcripción en vivo grande: "“Pagué 24 dólares de gasolina por todos”" con "24 dólares", "gasolina" y "todos" resaltados en coral y cursor parpadeante. Texto pequeño "Transcribiendo en tu dispositivo…". Onda de audio con barras coral. Botón de micrófono enorme coral con 3 anillos de pulso concéntricos. Debajo 3 botones redondos: Cancelar (×), Listo (cuadrado de stop, oscuro), Escribir (teclado). Tip: "💡 Prueba: “Ana pagó 18.50 de pupusas para todos menos Carla”". Pie: "🔒 Solo guardamos el texto, nunca el audio".
```
**EN**
```
Voice dictation screen, peach-to-cream gradient background. Top: close, chip "🌊 Playa El Tunco", help. Red recording indicator "● ESCUCHANDO · 0:04". Large live transcription: "“Pagué 24 dólares de gasolina por todos”" with "24 dólares", "gasolina", "todos" highlighted in coral and a blinking cursor. Small text "Transcribiendo en tu dispositivo…". Audio waveform with coral bars. Huge coral mic button with 3 concentric pulse rings. Below, 3 round buttons: Cancelar (×), Listo (dark stop square), Escribir (keyboard). Tip: "💡 Prueba: “Ana pagó 18.50 de pupusas para todos menos Carla”". Footer: "🔒 Solo guardamos el texto, nunca el audio" (only text is stored, never audio).
```

## 8 · Confirmar gasto dictado

**ES**
```
Pantalla "Confirma tu gasto". Banner amarillo suave arriba: "Sin conexión · se sincronizará al volver" con ícono de nube tachada. Burbuja de chat con micrófono coral: "“Pagué 24 dólares de gasolina por todos” · Laura · hace un momento". Tarjeta blanca "✨ Detectamos esto" con etiqueta verde "Alta confianza" y filas editables (ícono lápiz): Monto $24.00 (grande) · Concepto Gasolina + chip "⛽ Transporte" · Pagó: avatar Laura (tú) · Participantes: 6 avatares "Todos (6)" · Método: 💳 Tarjeta. Franja menta "Cada persona paga $4.00". Nota pequeña "Transcrito en el dispositivo · ¿Más precisión?" con insignia "PRO". Abajo: botones blancos "Editar" y "Volver a dictar", y botón coral grande "✓ Confirmar gasto".
```
**EN**
```
"Confirma tu gasto" (confirm dictated expense) screen. Soft yellow banner on top: "Sin conexión · se sincronizará al volver" with a crossed-out cloud icon (offline). Chat bubble with a coral mic avatar: "“Pagué 24 dólares de gasolina por todos” · Laura · hace un momento". White card "✨ Detectamos esto" with green "Alta confianza" tag and editable rows (pencil icons): Monto $24.00 (large) · Concepto Gasolina + chip "⛽ Transporte" · Pagó: Laura (tú) avatar · Participantes: 6 avatars "Todos (6)" · Método: 💳 Tarjeta. Mint strip "Cada persona paga $4.00". Small note "Transcrito en el dispositivo · ¿Más precisión?" with an orange "PRO" badge. Bottom: white buttons "Editar" and "Volver a dictar", and a big coral button "✓ Confirmar gasto" (one tap).
```

## 9 · Liquidación: ¿quién le paga a quién?

**ES**
```
Pantalla "Liquidación". Tarjeta menta: "¿Quién le paga a quién? 🤝", "Playa El Tunco · Total $202.00", etiqueta "✨ Solo 5 transferencias", ilustración de monedas. Lista de tarjetas con avatar → avatar, texto y monto grande: Diego le paga a Sofi $34.60 · Carla le paga a Sofi $29.00 · Ana le paga a Sofi $11.20 · "Tú le pagas a Sofi $10.60" (resaltada en durazno con borde coral y botón coral "Pagar") · Ana le paga a Luis $2.40. Las demás tienen un check circular para marcar pagado. Nota amarilla: "💵 Efectivo sobrante: $52.00 · Se devuelven: Ana $39.00 · Luis $13.00". Botón coral fijo "Compartir resumen" con ícono de WhatsApp.
```
**EN**
```
"Liquidación" (settle up) screen. Mint card: "¿Quién le paga a quién? 🤝", "Playa El Tunco · Total $202.00", tag "✨ Solo 5 transferencias" (minimum transfers), coins illustration. List of cards with avatar → avatar, sentence and big amount: Diego le paga a Sofi $34.60 · Carla le paga a Sofi $29.00 · Ana le paga a Sofi $11.20 · "Tú le pagas a Sofi $10.60" (highlighted peach with coral outline and coral "Pagar" button) · Ana le paga a Luis $2.40. Other rows have a circular check to mark as paid. Yellow note: "💵 Efectivo sobrante: $52.00 · Se devuelven: Ana $39.00 · Luis $13.00". Sticky coral button "Compartir resumen" with WhatsApp icon.
```

## 10 · Efectivo del grupo

**ES**
```
Pantalla "Efectivo del grupo". Tarjeta menta grande con etiqueta "💵 Efectivo del grupo", "Efectivo disponible $52.00" (muy grande), "de $80.00 reunidos", barra de progreso verde al 65% ("Queda 65%" / "Gastado $28.00"), fila "Lo guarda Ana" con avatar, e ilustración sencilla y amigable de una billetera con billetes y monedas. Sección "¿Quién aportó? / + Aporte": Ana "🏧 Retiro en cajero" $60.00 (75% del fondo); Luis "💵 Efectivo de su bolsa" $20.00 (25%). Sección "Pagado en efectivo · $28.00": 🫓 Pupusas $18.50 (5 personas, Hoy 1:20 p.m.) y 🥥 Cocos y agua $9.50 (5 personas, 3:05 p.m.). Abajo: botón blanco "+ Aporte" y botón coral "Gasto en efectivo".
```
**EN**
```
"Efectivo del grupo" (shared group cash) screen. Large mint card with tag "💵 Efectivo del grupo", "Efectivo disponible $52.00" (very large), "de $80.00 reunidos", green progress bar at 65% ("Queda 65%" / "Gastado $28.00"), row "Lo guarda Ana" with avatar, and a simple friendly illustration of a wallet with banknotes and coins. Section "¿Quién aportó? / + Aporte": Ana "🏧 Retiro en cajero" $60.00 (75% del fondo); Luis "💵 Efectivo de su bolsa" $20.00 (25%). Section "Pagado en efectivo · $28.00": 🫓 Pupusas $18.50 (5 personas, Hoy 1:20 p.m.) and 🥥 Cocos y agua $9.50 (5 personas, 3:05 p.m.). Bottom: white button "+ Aporte" and coral button "Gasto en efectivo".
```

## 11 · Resumen para compartir

**ES**
```
Pantalla "Resumen del viaje" sobre fondo menta. Al centro, vista previa de una imagen tipo tarjeta (ligeramente inclinada, sombra grande) para WhatsApp: ilustración de playa con etiqueta "2–4 oct 2026", título "Playa El Tunco 🌊", 6 avatares, "Total del viaje $202.00" en coral, cuadrícula de categorías pastel (🏠 Hospedaje $120, 🎟️ Diversión $30, 🍽️ Comida $28, ⛽ Transporte $24), sección "QUIÉN LE PAGA A QUIÉN" con 5 líneas (Diego→Sofi $34.60, Carla→Sofi $29.00, Ana→Sofi $11.20, Laura→Sofi $10.60, Ana→Luis $2.40) y pie "Hecho con Kaval · 💵 Efectivo sobrante: $52". Texto "Vista previa · imagen 1080 × 1350". Botón verde WhatsApp "Compartir por WhatsApp" y 3 botones: Imagen, Texto, PDF (con insignia PRO).
```
**EN**
```
"Resumen del viaje" (shareable summary) screen on a mint background. Centered preview of a card-style image for WhatsApp (slightly tilted, big soft shadow): beach illustration with "2–4 oct 2026" label, title "Playa El Tunco 🌊", 6 avatars, "Total del viaje $202.00" in coral, pastel category grid (🏠 Hospedaje $120, 🎟️ Diversión $30, 🍽️ Comida $28, ⛽ Transporte $24), section "QUIÉN LE PAGA A QUIÉN" with 5 lines (Diego→Sofi $34.60, Carla→Sofi $29.00, Ana→Sofi $11.20, Laura→Sofi $10.60, Ana→Luis $2.40) and footer "Hecho con Kaval · 💵 Efectivo sobrante: $52". Caption "Vista previa · imagen 1080 × 1350". Green WhatsApp button "Compartir por WhatsApp" and 3 small buttons: Imagen, Texto, PDF (with PRO badge).
```

## 12 · Invitar al evento (código)

**ES**
```
Pantalla "Invitar al evento". Tarjeta con degradado durazno a blanco: ilustración de sobre con avión de papel coral, "¡Suma a tu grupo a Playa El Tunco!" y "Con el código se unen y ven los gastos al instante." Etiqueta "CÓDIGO DEL EVENTO" y código grande espaciado "TUNCO-7K2" con botón copiar. Código QR (cuadrito coral al centro) junto a "⏳ Expira en 7 días · Escanéalo desde la app o usa el enlace." Botones: verde "WhatsApp" y blanco "Enlace". Sección "Integrantes (6) / + Por nombre": Laura (Tú · Admin), Ana, Luis y Sofi (avatares apilados, "Se unieron con código", etiqueta verde "3 unidos ✓"), Diego ("Invitado (solo nombre)", botón "Invitar"), Carla ("Invitación enviada", "Pendiente").
```
**EN**
```
"Invitar al evento" (invite by code) screen. Card with peach-to-white gradient: envelope illustration with a coral paper plane, "¡Suma a tu grupo a Playa El Tunco!" and "Con el código se unen y ven los gastos al instante." Label "CÓDIGO DEL EVENTO" and big letter-spaced code "TUNCO-7K2" with a copy button. QR code (small coral square in the center) next to "⏳ Expira en 7 días · Escanéalo desde la app o usa el enlace." Buttons: green "WhatsApp" and white "Enlace". Section "Integrantes (6) / + Por nombre": Laura (Tú · Admin), Ana, Luis y Sofi (stacked avatars, "Se unieron con código", green tag "3 unidos ✓"), Diego ("Invitado (solo nombre)" name-only guest, "Invitar" button), Carla ("Invitación enviada", "Pendiente").
```

## 13 · Perfil / Ajustes

**ES**
```
Pantalla "Perfil". Tarjeta con avatar grande de Laura, "Laura Angel", "laura.angel@email.com" y etiqueta verde "☁ Sincronizado hace 1 min". Tarjeta oscura azul tinta "Kaval Pro" con insignia dorada "PRO" y 4 beneficios: 🎙️ Voz en la nube, 📄 Exportar PDF / Excel, 📊 Estadísticas, 🚫 Sin anuncios; botón coral "Probar 7 días gratis". Lista de ajustes en tarjeta blanca con íconos en cuadros pastel: Idioma (selector ES | EN, ES activo), Moneda USD ($), Sincronizar en la nube (switch coral activado), Privacidad y datos, Cerrar sesión, y "Eliminar cuenta" en rojo con ícono de basurero. Barra inferior con Perfil activo y micrófono central.
```
**EN**
```
"Perfil" (profile & settings) screen. Card with Laura's large avatar, "Laura Angel", "laura.angel@email.com" and green tag "☁ Sincronizado hace 1 min". Dark ink-navy "Kaval Pro" card with gold "PRO" badge and 4 perks: 🎙️ Voz en la nube, 📄 Exportar PDF / Excel, 📊 Estadísticas, 🚫 Sin anuncios; coral button "Probar 7 días gratis". Settings list in a white card with icons in pastel squares: Idioma (segmented ES | EN, ES active), Moneda USD ($), Sincronizar en la nube (coral toggle on), Privacidad y datos, Cerrar sesión, and "Eliminar cuenta" in red with a trash icon. Bottom nav with Perfil active and central mic button.
```
