#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Starting server setup ===${NC}"

# Проверка прав root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root${NC}"
    exit 1
fi

echo -e "${YELLOW}1. Updating system...${NC}"
apt update && apt upgrade -y

echo -e "${YELLOW}2. Installing required packages...${NC}"
apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    git \
    ufw \
    fail2ban \
    htop \
    nano

echo -e "${YELLOW}3. Installing Docker...${NC}"
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

echo -e "${YELLOW}4. Installing Docker Compose...${NC}"
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo -e "${YELLOW}5. Creating deployer user...${NC}"
useradd -m -s /bin/bash deployer
usermod -aG sudo deployer
usermod -aG docker deployer
mkdir -p /home/deployer/.ssh

echo -e "${YELLOW}6. Configuring firewall...${NC}"
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

echo -e "${YELLOW}7. Setting up SSH keys for deployer...${NC}"
# Здесь нужно будет добавить ваш публичный ключ
echo "Please add your public SSH key to /home/deployer/.ssh/authorized_keys"

echo -e "${YELLOW}8. Setting up fail2ban...${NC}"
systemctl enable fail2ban
systemctl start fail2ban

echo -e "${YELLOW}9. Creating project directory...${NC}"
mkdir -p /home/deployer/my-education-app
chown -R deployer:deployer /home/deployer/my-education-app

echo -e "${YELLOW}10. Setting up automatic security updates...${NC}"
apt install -y unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades

echo -e "${GREEN}=== Server setup completed! ===${NC}"
echo -e "Next steps:"
echo -e "1. ${YELLOW}Add your SSH public key to /home/deployer/.ssh/authorized_keys${NC}"
echo -e "2. ${YELLOW}Test SSH connection: ssh deployer@your-server-ip${NC}"
echo -e "3. ${YELLOW}Clone your repository:${NC}"
echo -e "   cd /home/deployer"
echo -e "   git clone https://github.com/ZhannaIvanova10/my-education-project"
echo -e "4. ${YELLOW}Create .env file from example${NC}"
echo -e "5. ${YELLOW}Run: ./deploy.sh${NC}"