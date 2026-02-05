#!/bin/bash

# Скрипт для деплоя на продакшен сервер
set -e  # Останавливаем скрипт при ошибке

echo "========================================"
echo "🚀 ЗАПУСК ПРОЦЕССА ДЕПЛОЯ"
echo "========================================"

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Функция для вывода с цветом
print_color() {
    echo -e "${2}${1}${NC}"
}

print_color "1. Проверка Docker и Docker Compose..." "$YELLOW"
docker --version
docker-compose --version

print_color "2. Остановка текущих контейнеров..." "$YELLOW"
docker-compose down

print_color "3. Получение последней версии кода..." "$YELLOW"
git pull origin main

print_color "4. Проверка .env файла..." "$YELLOW"
if [ ! -f ".env" ]; then
    print_color "⚠️  Файл .env не найден!" "$RED"
    print_color "   Создайте его из .env.production.example" "$YELLOW"
    exit 1
fi
print_color "5. Сборка и запуск контейнеров..." "$YELLOW"
docker-compose up -d --build

print_color "6. Применение миграций базы данных..." "$YELLOW"
docker-compose exec backend python manage.py migrate --noinput

print_color "7. Сборка статических файлов..." "$YELLOW"
docker-compose exec backend python manage.py collectstatic --noinput

print_color "8. Создание суперпользователя (если нужно)..." "$YELLOW"
read -p "Создать суперпользователя? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker-compose exec backend python manage.py createsuperuser
fi

print_color "9. Проверка статуса сервисов..." "$YELLOW"
docker-compose ps

print_color "10. Просмотр логов..." "$YELLOW"
docker-compose logs --tail=20

echo "========================================"
print_color "✅ ДЕПЛОЙ УСПЕШНО ЗАВЕРШЕН!" "$GREEN"
print_color "🌐 Приложение доступно по адресу:" "$GREEN"
print_color "   http://localhost:8000" "$GREEN"
print_color "   или" "$GREEN"
print_color "   http://ваш-ip-адрес:8000" "$GREEN"
echo "========================================"
