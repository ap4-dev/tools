#!/bin/bash

# Docker Installation Script

set -e

echo "======================================"
echo "  Docker Installation Script"
echo "======================================"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "⚠️  Este script requiere permisos de root."
    echo "Por favor ejecuta: sudo bash o curl ... | sudo bash"
    exit 1
fi

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID
else
    echo "❌ No se pudo detectar el sistema operativo"
    exit 1
fi

echo "🔍 Sistema detectado: $OS $VERSION"
echo ""

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo "⚠️  Docker ya está instalado: $DOCKER_VERSION"
    read -p "¿Deseas reinstalar? (s/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo "Instalación cancelada."
        exit 0
    fi
fi

echo "📦 Instalando dependencias..."
apt-get update -qq
apt-get install -y -qq ca-certificates curl gnupg lsb-release > /dev/null 2>&1

echo "🔑 Agregando clave GPG de Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo "📝 Agregando repositorio de Docker..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🔄 Actualizando lista de paquetes..."
apt-get update -qq

echo "🐋 Instalando Docker..."
apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null 2>&1

echo ""
echo "✅ Docker instalado correctamente!"
echo ""

# Verify installation
DOCKER_VERSION=$(docker --version)
COMPOSE_VERSION=$(docker compose version)

echo "======================================"
echo "  Versiones instaladas:"
echo "======================================"
echo "$DOCKER_VERSION"
echo "$COMPOSE_VERSION"
echo ""

# Start Docker service
echo "🚀 Iniciando servicio Docker..."
systemctl start docker
systemctl enable docker > /dev/null 2>&1

# Check if Docker is running
if systemctl is-active --quiet docker; then
    echo "✅ Docker está corriendo correctamente"
else
    echo "❌ Error: Docker no se pudo iniciar"
    exit 1
fi

echo ""
echo "======================================"
echo "  Instalación completada!"
echo "======================================"
echo ""
echo "💡 Comandos útiles:"
echo "  - docker --version        (verificar versión)"
echo "  - docker ps               (listar contenedores)"
echo "  - docker compose version  (verificar docker compose)"
echo ""
echo "📌 Para usar Docker sin sudo, ejecuta:"
echo "   sudo usermod -aG docker \$USER"
echo "   (requiere cerrar sesión y volver a entrar)"
echo ""
