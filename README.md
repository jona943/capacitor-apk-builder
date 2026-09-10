# Nexu Android APK — Documentación Técnica de Empaquetado

Este repositorio contiene la configuración nativa de Android (Capacitor WebView), el entorno JDK/SDK portable y el historial de binarios `.apk` generados para la aplicación de mensajería **Nexu**.

---

## Estructura del Proyecto

* **`android/`**: Proyecto nativo Android generado con Capacitor.
* **`.jdk/`**: Entorno de ejecución Java portable (JDK 17) para compilación silenciosa.
* **`.android-sdk/`**: SDK de Android configurado para compilación Gradle local.
* **`www/`**: Directorio donde se compilan y almacenan los activos estáticos web de la aplicación (`dist/`).
* **`versiones_apk/`**: Histórico estructurado de las versiones `.apk` compiladas para seguimiento del equipo.

---

## Historial y Registro de Versiones APK

### Versión 1.5 (`Nexu_WebView_v1.5.apk`) — **ACTIVA & RECOMENDADA**
* **Conexión Directa a la API Backend en Render (Cloud):**
  * Se configuró `https://nexu-backend-api.onrender.com/api` como la URL principal del servidor backend.
  * Habilita el inicio de sesión, registro, búsqueda de alias y sincronización de mensajes en vivo desde MongoDB Atlas en la nube para cualquier teléfono Android desde cualquier lugar (Wi-Fi o Datos Móviles).
* **Archivos:** `Nexu_v1.5.apk` / `versiones_apk/Nexu_WebView_v1.5.apk`

---

### Versión 1.4 (`Nexu_WebView_v1.4.apk`)
* **Habilitación de Tráfico de Red (`usesCleartextTraffic="true"`):**
  * Se otorgó el permiso nativo en `AndroidManifest.xml` para realizar peticiones HTTP/HTTPS de red sin restricciones en Android 9+.

---

### Versión 1.3 (`Nexu_WebView_v1.3.apk`)
* **Solución al Encendido en Frío:**
  * Desactivación del modo inmersivo mediante `FLAG_FORCE_NOT_FULLSCREEN`, inyección nativa `requestApplyInsets()` en `MainActivity.java` y fallback de dimensión nativa `status_bar_height` desde el milisegundo 0 del arranque.

---

### Versión 1.2 (`Nexu_WebView_v1.2.apk`)
* **Parche de Detección Inteligente de Entorno:**
  * Se agregó la detección nativa `window.Capacitor.isNativePlatform()` que inyecta la clase `is-webview-apk` al elemento `<html>`.
  * Aplicó un `padding-top: 36px` condicional exclusivamente en el APK para no alterar la visualización en navegadores móviles (Chrome/Safari) ni en computadoras.
  * *Observación de prueba:* Requería una interacción de toque (*touch pass*) para aplicar el ajuste en algunos dispositivos.

---

### Versión 1.1 (`Nexu_WebView_v1.1.apk`)
* Configuración inicial del tema `AppTheme.NoActionBar` y barra de navegación en color `#08090b` (Obsidian Carbon).

---

### Versión 1.0 (`Nexu_v1.0.apk`)
* Primer ejecutable prototipo compilado con Capacitor WebView nativo.

---

## Requisitos Previos

Antes de ejecutar los scripts de compilación, es estrictamente necesario contar con las siguientes dependencias instaladas en el sistema:

1. **Node.js (v18 o superior) y npm**: Requeridos para ejecutar los comandos de Capacitor (`npx cap sync`) y los scripts definidos en `package.json`.
2. **Entorno de Java (JDK 17)**: 
   * Puede instalarse a nivel global en el sistema (configurando la variable de entorno `JAVA_HOME`).
   * Opcionalmente, puede proveerse localmente depositando los binarios portables en el directorio `.jdk/` en la raíz de este proyecto.
3. **Android SDK**:
   * Puede instalarse globalmente (configurando la variable de entorno `ANDROID_HOME`).
   * Opcionalmente, puede proveerse de forma local depositando los binarios del SDK en el directorio `.android-sdk/` en la raíz de este proyecto.

*Nota: Los directorios locales `.jdk/` y `.android-sdk/` están excluidos del control de versiones (`.gitignore`) para evitar subir archivos binarios pesados al repositorio. Por lo tanto, si el repositorio es clonado en un entorno nuevo, se deben utilizar las variables del sistema o colocar manualmente dichas carpetas.*

---

## Personalización de la App (Renombrar e Iconos)

Dado que este repositorio es una herramienta genérica, puedes adaptarlo fácilmente para tu propia aplicación (cambiar nombre, paquete/ID y URL destino).

### 1. Cambiar el Nombre, Paquete (Bundle ID) y URL
Hemos incluido un script interactivo que renombra automáticamente todas las configuraciones y variables de Java:
```bash
./configure.sh
```
El script te pedirá:
1. **Nombre de la app** (ej. *Mi Gran App*)
2. **ID del paquete** (ej. *com.miempresa.miapp*)
3. **URL del servidor web** (ej. *https://mi-web.com/*)

### 2. Cambiar el Icono y Splash Screen
Para cambiar la imagen de inicio y el icono de la aplicación, te recomendamos usar la herramienta oficial de Capacitor:
1. Instala el generador de recursos:
   ```bash
   npm install @capacitor/assets --save-dev
   ```
2. Crea una carpeta `assets/` en la raíz de este proyecto y coloca tus imágenes:
   * `assets/icon.png` (min 1024x1024px)
   * `assets/splash.png` (min 2732x2732px)
3. Ejecuta el generador para sobrescribir los iconos nativos de Android:
   ```bash
   npx capacitor-assets generate --android
   ```

---

## Guía de Compilación Automatizada del APK

Para compilar el APK ya no necesitas configurar las variables ni compilar manualmente. Hemos creado un script estandarizado que resuelve las rutas dinámicamente y empaqueta la app usando los entornos locales (JDK/SDK).

### 1. Generar el APK con un solo comando:
```bash
# Desde la raíz de esta carpeta (apk_version)
npm run build:apk
```

Alternativamente, puedes correr el script de bash directamente:
```bash
./build-apk.sh
```

### 2. Ubicación del APK generado:
Al terminar el proceso de forma exitosa, el archivo compilado listo para instalar o distribuir se encontrará en:
```bash
android/app/build/outputs/apk/debug/app-debug.apk
```

---

## Mejoras Pendientes / Roadmap de Automatización

> [!NOTE]
> Esta sección documenta los cambios planeados para simplificar el uso y la compilación de este repositorio.

* [x] **Automatizar el proceso de Build:** Crear un script de automatización (`build-apk.sh` o comandos en `package.json`) para ejecutar todo el flujo con un solo comando (`npm run build:apk`).
* [x] **Migrar a rutas relativas:** Reemplazar las rutas absolutas locales (`/home/...`) por variables dinámicas o rutas relativas (`./` o `$PWD`) para permitir la compilación en cualquier equipo.
* [x] **Integración con CLI de Capacitor:** Sustituir la copia manual de archivos (`rm -rf` / `cp -r`) por el uso nativo de `npx cap sync`.
* [x] **Limpieza de ejecutables `.apk`:** Mover el historial de binarios antiguos fuera del seguimiento principal de Git (o a GitHub Releases) para reducir el tamaño del repositorio.

---

<p align="center">
  <strong>Nexu Android APK Engine</strong> — Documentación Interna de Empaquetado Nativo.
</p>

