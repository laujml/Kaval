# Contexto de Kaval

Actualizado el 12 de octubre de 2026. El detalle del avance está en [ESTADO_KAVAL.md](ESTADO_KAVAL.md).

## Qué es

App Flutter de control de gastos para salidas y viajes. Paquete `kaval`, organización `com.kaval.app`. Carpeta de código: `kaval/`. Curso de Aplicaciones Móviles. No usar la palabra “vaquita”; en la interfaz el fondo común es “Efectivo del grupo”.

## Fase actual

Fase 1 casi cerrada: 13 pantallas del mockup, Provider, go_router, Material 3, liquidación en centavos con tests, textos es/en. No hay Firebase ni micrófono.

Encima de eso ya está la actividad de red: Dio con interceptor, manejo de `DioException`, pantalla Control de errores y modo prueba en Perfil (solo debug).

El estado es en memoria (`KavalState`). El login acepta cualquier correo válido y cualquier contraseña, y antes hace `POST /posts` a `https://jsonplaceholder.typicode.com`. Token de demo: `Bearer kaval-demo`.

## Cómo correrla

Desde `kaval/`:

```text
flutter run -d emulator-5554
```

Emulador: Pixel 7. Si no aparece o se queda gris, arranque en frío:

```text
emulator -avd Pixel_7 -no-snapshot-load
```

Flutter usa Microsoft OpenJDK 21 (`flutter config --jdk-dir` apunta a `C:\Users\OMEN\.jdks\microsoft-jdk-21\jdk-21.0.12.1+1`), no el JDK 25 de Android Studio. En `kaval/android/gradle.properties` el heap de Gradle es `-Xmx2G` y `org.gradle.workers.max=2`.

## Demo de errores

En Perfil, sección “Modo prueba (solo debug)”, elegir un fallo y después hacer la operación (login o Guardar gasto). El fallo se consume una vez. Los logs salen en la consola de `flutter run` con el prefijo `[kaval]`.
