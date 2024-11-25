#!/bin/bash
######################################################################################################################
# Script instalacion automatizada de docker y creacion de contenedor portainer
# Para Debian
# Miguel Garcia Leon
# Noviembre 2024
#######################################################################################################################

Estilo de las letras
LR='\033[0;91m'
LG='\033[0;92m'
LY='\033[0;93m'
NC='\033[0m'

# Comprobar que el paquete sudo está instalado
if ! dpkg -l | grep -q sudo; then
    echo -e "${LR}El paquete 'sudo' no está instalado. Instálalo antes de continuar.${NC}"
    exit 1
fi

# Comprobar que el usuario está en el grupo sudo
if ! id -nG "$USER" | grep -qw "sudo"; then
    echo -e "${LR}El usuario '${USER}' no está en el grupo sudo.${NC}"
    echo -e "Ejecuta: ${LY}sudo usermod -aG sudo ${USER}${NC}"
    exit 1
fi

# Comprobar que el usuario tiene permisos sudo
if ! sudo -l &>/dev/null; then
    echo -e "${LR}El usuario '${USER}' no tiene permisos sudo.${NC}"
    exit 1
fi

# Mensaje de bienvenida
echo -e "${LG}Instalación automática de Docker y contenedor Portainer para Debian 12."
echo -e "              Powered by zXMiguelXz"
echo -e "              https://github.com/zXMiguelXz"
echo -e "              Powered by Miguel García León${NC}"

echo
echo
echo -e "${LY}Actualizando los paquetes...${NC}"

sudo apt update >> /dev/null && sudo apt upgrade -y >> /dev/null


echo -e "${LG}Instalando los paquetes necesarios.${NC}"

sudo apt install -y ca-certificates curl gnupg lsb-release >> /dev/null

echo -e "${LG}Agregando la clave GPG de Docker.${NC}"

sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo -e "${LY}Se ha creado la carpeta /etc/apt/keyrings donde se guardar la clave gpg de docker.${NC}"
sleep 2

echo -e "${LG}Agregando repositorio de docker en /etc/apt/sources.list.d/docker.list${NC}"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sleep 2

echo -e "${LY}Actualizando e instalando la paqueteria docker.${NC}"
sudo apt update >> /dev/null
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >> /dev/null

echo -e "${LY}Habilitando e iniciando docker.${NC}"
sudo systemctl enable docker
sudo systemctl start docker

echo -e "${LY}Creando contenedor portainer...${NC}"
docker run -d \
  --name portainer \
  -p 9000:9000 \
  portainer/portainer-ce:latest

echo -e "${LG}Contenedor portainer creado, ve a tu navegador web y pon http://127.0.0.1:9000${NC}"
echo -e "              ${LG}Powered by zXMiguelXz"
echo -e "              https://github.com/zXMiguelXz${NC}"


