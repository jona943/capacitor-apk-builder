#!/bin/bash

# ==============================================================================
# Nexu WebView APK - Script de Compilacion Automatizada
# ==============================================================================
# Este script automatiza el proceso de compilacion del APK en Android,
# verificando la existencia del JDK y Android SDK locales o de sistema,
# sin depender de rutas absolutas.
# ==============================================================================

set -e

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ANDROID_DIR="$BASE_DIR/android"
JDK_DIR="$BASE_DIR/.jdk"
SDK_DIR="$BASE_DIR/.android-sdk"

echo "==========================================================="
echo "Iniciando compilacion del APK (WebView)"
echo "==========================================================="
echo "Directorio base: $BASE_DIR"

echo "Configurando variables de entorno (Java y Android SDK)..."

if [ -d "$JDK_DIR" ]; then
  export JAVA_HOME="$JDK_DIR"
elif [ -z "$JAVA_HOME" ]; then
  echo "Error: No se encontro el directorio .jdk/ ni la variable JAVA_HOME en el sistema."
  echo "Por favor, instale Java JDK o coloque el entorno en .jdk/"
  exit 1
fi

if [ -d "$SDK_DIR" ]; then
  export ANDROID_HOME="$SDK_DIR"
elif [ -z "$ANDROID_HOME" ]; then
  echo "Error: No se encontro el directorio .android-sdk/ ni la variable ANDROID_HOME en el sistema."
  echo "Por favor, instale Android SDK o coloque el entorno en .android-sdk/"
  exit 1
fi

export PATH="$JAVA_HOME/bin:$PATH"

echo "Sincronizando entorno de Capacitor..."
npx cap sync android

echo "Compilando el APK con Gradle..."
cd "$ANDROID_DIR"
chmod +x gradlew
./gradlew assembleDebug

APK_PATH="$ANDROID_DIR/app/build/outputs/apk/debug/app-debug.apk"

echo "==========================================================="
if [ -f "$APK_PATH" ]; then
  echo "Compilacion exitosa."
  echo "El archivo APK se encuentra en:"
  echo "$APK_PATH"
else
  echo "Error: No se encontro el archivo APK generado."
  exit 1
fi
echo "==========================================================="
