#!/bin/bash

# --- Variables ---
FOLDER_NAME="npm"
COMPOSE_URL="https://raw.githubusercontent.com/ap4-dev/tools/refs/heads/main/npm-docker-compose.yml"
COMPOSE_FILE="docker-compose.yml"

echo "==================================================="
echo "🚀 Iniciando la instalación de npm con Docker Compose"
echo "==================================================="

# 1. Crear la carpeta y navegar a ella
echo "-> Creando y entrando al directorio '$FOLDER_NAME'..."
mkdir -p "$FOLDER_NAME" # -p asegura que no habrá error si ya existe
cd "$FOLDER_NAME" || { echo "Error: No se pudo entrar al directorio '$FOLDER_NAME'."; exit 1; }

# 2. Descargar el archivo docker-compose.yml
echo "-> Descargando '$COMPOSE_FILE'..."
curl -L "$COMPOSE_URL" -o "$COMPOSE_FILE"

# Verificar si la descarga fue exitosa
if [ $? -ne 0 ]; then
    echo "❌ Error: Falló la descarga de '$COMPOSE_FILE'."
    exit 1
fi

# 3. Iniciar los servicios con Docker Compose
echo "-> Levantando los servicios de Docker Compose..."
# Usa 'docker compose' (con espacio)
docker compose up -d

# Verificar si la ejecución de Docker Compose fue exitosa
if [ $? -ne 0 ]; then
    echo "❌ Error: Falló la ejecución de 'docker compose up -d'."
    exit 1
fi

echo "========================================================"
echo "✅ Configuración de npm lista! Los servicios están corriendo."
echo "========================================================"