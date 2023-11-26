#!/bin/bash
# Instalador do nginx e api quepasa
# Autor: dSantana
# Versao: 0.1

# Executa a atualização e instalação de pacotes necessários
sudo apt update && sudo apt upgrade -y && \
  curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - && \
  sudo apt-get install -y nodejs && \
  sudo apt-get install -y git-all


TZ='America/Sao_Paulo'; export TZ


# Clona o repositório e executa a instalação
git clone https://github.com/nocodeleaks/quepasa /opt/quepasa-source && \
  sudo bash /opt/quepasa-source/helpers/install.sh

# Define as variáveis de ambiente para o Quepasa
echo -e "WEBSOCKETSSL=true\nWEBAPIPORT=31000\nAPP_ENV=production\nMIGRATIONS=/opt/quepasa/migrations\nDEBUGJSONMESSAGES=false\nHTTPLOGS=false" | sudo tee /opt/quepasa-source/src/.env

# Reinicia o serviço Quepasa
sudo systemctl restart quepasa

# Recupera o endereço IP público
ip=$(curl -s http://ipinfo.io/ip)

# Remove o apache
sudo systemctl stop apache2
sudo systemctl disable apache2

clear

# Definir as cores usando sequências de escape ANSI
vermelho='\033[0;31m'
verde='\033[0;32m'
amarelo='\033[0;33m'
reset='\033[0m'  # Resetar para a cor padrão

# Exibe a mensagem de instalação bem-sucedida com o endereço IP
printf "${verde}Quepasa instalada com sucesso!${reset}\n"
printf "\n"
printf "\n"
printf "${amarelo}Acesse a quepasa${reset}\n"
printf "${amarelo}URL: http://$ip:31000/setup${reset}\n"
printf "\n"
printf "\n"
printf "${vermelho}Visite o canal https://www.youtube.com/@dSantana${reset}\n"