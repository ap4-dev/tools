#!/bin/bash

# ===============================================
# 1. Validación del Argumento (Nombre del Servicio)
# ===============================================

# Verificar si se proporcionó un argumento
if [ -z "$1" ]; then
    echo "❌ Error: Debes proporcionar el nombre del servicio a instalar (e.g., npm, mariadb, redis)."
    echo "Uso: bash install-service.sh <nombre_del_servicio>"
    exit 1
fi

# El primer argumento ($1) es el nombre del servicio (npm, mariadb, etc.)
SERVICE_NAME="$1"

# ===============================================
# 2. Definición de Variables Dinámicas
# ===============================================

# La carpeta se llamará como el servicio
FOLDER_NAME="$SERVICE_NAME" 
# La URL de descarga se construye con el nombre del servicio
COMPOSE_URL="https://raw.githubusercontent.com/ap4-dev/tools/refs/heads/main/$SERVICE_NAME/docker-compose.yml"
COMPOSE_FILE="docker-compose.yml"

echo "======================================================="
echo "🚀 Iniciando la instalación del servicio: $SERVICE_NAME"
echo "======================================================="

# ===============================================
# 3. Lógica de Instalación
# ===============================================

# a. Crear la carpeta y navegar a ella
echo "-> Creando y entrando al directorio '$FOLDER_NAME'..."
# -p asegura que no habrá error si ya existe
mkdir -p "$FOLDER_NAME" 
cd "$FOLDER_NAME" || { echo "❌ Error: No se pudo entrar al directorio '$FOLDER_NAME'."; exit 1; }

# b. Descargar el archivo docker-compose.yml
echo "-> Descargando el archivo '$COMPOSE_FILE' desde $COMPOSE_URL..."
curl -L "$COMPOSE_URL" -o "$COMPOSE_FILE"

# Verificar si la descarga fue exitosa (código de salida $? es 0 si fue exitosa)
if [ $? -ne 0 ]; then
    echo "❌ Error: Falló la descarga de '$COMPOSE_FILE'."
    echo "Asegúrate de que la URL: $COMPOSE_URL es correcta y el archivo existe."
    # Volvemos al directorio anterior antes de salir
    cd .. 
    exit 1
fi

# c. Iniciar los servicios con Docker Compose
echo "-> Levantando los servicios de Docker Compose..."
docker compose up -d

# Verificar si la ejecución de Docker Compose fue exitosa
if [ $? -ne 0 ]; then
    echo "❌ Error: Falló la ejecución de 'docker compose up -d'."
    exit 1
fi

echo "=========================================================="
echo "✅ Servicio '$SERVICE_NAME' iniciado correctamente."
echo "Carpeta creada: $FOLDER_NAME"
echo "=========================================================="