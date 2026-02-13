#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Starting deployment ===${NC}"

# Проверка наличия .env файла
if [ ! -f .env ]; then
    echo -e "${RED}Error: .env file not found!${NC}"
    echo "Please create .env file from .env.production.example"
    exit 1
fi

# Проверка Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed!${NC}"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Error: Docker Compose is not installed!${NC}"
    exit 1
fi

echo -e "${YELLOW}1. Pulling latest changes...${NC}"
git pull origin main

echo -e "${YELLOW}2. Building Docker images...${NC}"
docker-compose build

echo -e "${YELLOW}3. Stopping old containers...${NC}"
docker-compose down

echo -e "${YELLOW}4. Starting new containers...${NC}"
docker-compose up -d

echo -e "${YELLOW}5. Running database migrations...${NC}"
docker-compose exec -T backend python manage.py migrate --noinput

echo -e "${YELLOW}6. Collecting static files...${NC}"
docker-compose exec -T backend python manage.py collectstatic --noinput

echo -e "${YELLOW}7. Checking container status...${NC}"
docker-compose ps

echo -e "${YELLOW}8. Recent logs...${NC}"
docker-compose logs --tail=50

echo -e "${GREEN}=== Deployment completed! ===${NC}"
echo -e "Check your app at: ${YELLOW}http://localhost:8000${NC}"