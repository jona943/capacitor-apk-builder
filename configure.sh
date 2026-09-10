#!/bin/bash
# ==============================================================================
# Script de Configuración del Proyecto Android (App Name, Bundle ID, URL)
# ==============================================================================

set -e

echo "==========================================================="
echo "Configuracion de Nueva Aplicacion Android (Capacitor)"
echo "==========================================================="

read -p "Ingresa el nombre de la app (ej. Mi Gran App): " NEW_APP_NAME
read -p "Ingresa el ID del paquete (ej. com.empresa.miapp): " NEW_PACKAGE_ID
read -p "Ingresa la URL del servidor web (ej. https://mi-web.com/): " NEW_URL

if [ -z "$NEW_APP_NAME" ] || [ -z "$NEW_PACKAGE_ID" ] || [ -z "$NEW_URL" ]; then
    echo "Error: Todos los campos son obligatorios."
    exit 1
fi

echo "Aplicando configuracion..."

# 1. Modificar capacitor.config.json
# Usaremos sed para reemplazar los valores de forma segura
sed -i "s/\"appId\": \".*\"/\"appId\": \"$NEW_PACKAGE_ID\"/" capacitor.config.json
sed -i "s/\"appName\": \".*\"/\"appName\": \"$NEW_APP_NAME\"/" capacitor.config.json
sed -i "s|\"url\": \".*\"|\"url\": \"$NEW_URL\"|" capacitor.config.json

# 2. Modificar strings.xml (Nombre de la App)
STRINGS_FILE="android/app/src/main/res/values/strings.xml"
sed -i "s|<string name=\"app_name\">.*</string>|<string name=\"app_name\">$NEW_APP_NAME</string>|" $STRINGS_FILE
sed -i "s|<string name=\"title_activity_main\">.*</string>|<string name=\"title_activity_main\">$NEW_APP_NAME</string>|" $STRINGS_FILE
sed -i "s|<string name=\"package_name\">.*</string>|<string name=\"package_name\">$NEW_PACKAGE_ID</string>|" $STRINGS_FILE
sed -i "s|<string name=\"custom_url_scheme\">.*</string>|<string name=\"custom_url_scheme\">$NEW_PACKAGE_ID</string>|" $STRINGS_FILE

# 3. Modificar build.gradle (namespace y applicationId)
GRADLE_FILE="android/app/build.gradle"
sed -i "s/namespace \".*\"/namespace \"$NEW_PACKAGE_ID\"/" $GRADLE_FILE
sed -i "s/applicationId \".*\"/applicationId \"$NEW_PACKAGE_ID\"/" $GRADLE_FILE

# 4. Modificar y mover MainActivity.java al nuevo package
# Encontrar el archivo MainActivity.java actual
MAIN_ACTIVITY_PATH=$(find android/app/src/main/java -name "MainActivity.java" | head -n 1)
CURRENT_PACKAGE_PATH=$(dirname "$MAIN_ACTIVITY_PATH")

NEW_PACKAGE_PATH="android/app/src/main/java/$(echo $NEW_PACKAGE_ID | tr '.' '/')"
mkdir -p "$NEW_PACKAGE_PATH"
mv "$MAIN_ACTIVITY_PATH" "$NEW_PACKAGE_PATH/"

# Actualizar la declaración del package en MainActivity.java
sed -i "s/package .*;/package $NEW_PACKAGE_ID;/" "$NEW_PACKAGE_PATH/MainActivity.java"

# Eliminar directorios antiguos vacios
find android/app/src/main/java -type d -empty -delete

echo "==========================================================="
echo "Configuracion completada exitosamente."
echo "Se ha actualizado el nombre, ID y URL de la aplicacion."
echo ""
echo "Para cambiar el ICONO y el SPLASH SCREEN:"
echo "1. Instala el paquete de assets de Capacitor:"
echo "   npm install @capacitor/assets --save-dev"
echo "2. Coloca tu nuevo logo e icono en una carpeta 'assets/' en la raiz (ej. assets/icon.png y assets/splash.png)"
echo "3. Ejecuta:"
echo "   npx capacitor-assets generate --android"
echo "==========================================================="
