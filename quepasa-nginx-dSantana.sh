#!/bin/bash
# Instalador do nginx e api quepasa
# Autor: dSantana
# Versao: 0.1

# Executa a atualização e instalação de pacotes necessários
sudo apt update && sudo apt upgrade -y && \
  curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - && \
  sudo apt-get install -y nodejs && \
  sudo apt-get install -y git-all


TZ='America/Sao_Paulo'; export TZ && \
sudo apt install docker.io -y && \
sudo wget -O /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-x86_64 && \
sudo chmod +x /usr/local/bin/docker-compose && \
sudo apt install docker-compose -y


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

# Cria a pasta nginx-dSantana
mkdir nginx-dSantana

# Cria o arquivo docker-compose.yml com o conteúdo desejado
cat > nginx-dSantana/docker-compose.yml << EOF
version: '3.8'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
EOF

# Executa o comando docker-compose up -d
cd nginx-dSantana
docker-compose up -d

clear

# Definir as cores usando sequências de escape ANSI
vermelho='\033[0;31m'
verde='\033[0;32m'
amarelo='\033[0;33m'
reset='\033[0m'  # Resetar para a cor padrão

# Exibe a mensagem de instalação bem-sucedida com o endereço IP
printf "${verde}Quepasa instalada com sucesso!${reset}\n"
printf "${verde}Nginx instalado com sucesso!${reset}\n"
printf "\n"
printf "\n"
printf "${amarelo}Acesse o nginx${reset}\n"
printf "${amarelo}URL: http://$ip:81${reset}\n"
printf "${amarelo}Email:    admin@example.com${reset}\n"
printf "${amarelo}Password: changeme${reset}\n"
printf "\n"
printf "\n"
printf "${amarelo}Acesse a quepasa${reset}\n"
printf "${amarelo}URL: http://$ip:31000/setup${reset}\n"
printf "\n"
printf "\n"
printf "${vermelho}Configure o nginx com o $ip e porta 31000 e ative o SSL como no vídeo${reset}\n"
printf "${vermelho}Visite o canal https://www.youtube.com/@dSantana${reset}\n"