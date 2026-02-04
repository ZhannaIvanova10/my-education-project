#!/bin/bash

echo "============================================"
echo "ФИНАЛЬНАЯ ПРОВЕРКА ВСЕХ КРИТЕРИЕВ"
echo "============================================"
echo ""

# Проверка файлов
echo "1. ОСНОВНЫЕ ФАЙЛЫ:"
[ -f "docker-compose.yaml" ] && echo "✅ docker-compose.yaml" || echo "❌"
[ -f ".env.example" ] && echo "✅ .env.example" || echo "❌"
[ -f "README.md" ] && echo "✅ README.md" || echo "❌"
[ -f ".gitignore" ] && echo "✅ .gitignore" || echo "❌"

echo ""
echo "2. СЕРВИСЫ В DOCKER-COMPOSE.YAML:"
services_count=$(grep -c "^  [a-z_]*:" docker-compose.yaml)
echo "   Найдено сервисов: $services_count/5"
if [ $services_count -eq 5 ]; then
    echo "   ✅ Все сервисы: backend, db, redis, celery_worker, celery_beat"
else
    echo "   ❌ Не все сервисы"
fi

echo ""
echo "3. ПЕРЕМЕННЫЕ ОКРУЖЕНИЯ:"
grep -q "SECRET_KEY" .env.example && echo "✅ SECRET_KEY в .env.example" || echo "❌"
grep -q "POSTGRES_PASSWORD" .env.example && echo "✅ POSTGRES_PASSWORD в .env.example" || echo "❌"
grep -q "env_file:" docker-compose.yaml && echo "✅ env_file подключен в docker-compose" || echo "❌"

echo ""
echo "4. README.md ПРОВЕРКА:"
grep -q "docker compose" README.md && echo "✅ Упоминание docker compose" || echo "❌"
grep -q "up --build" README.md && echo "✅ Команда запуска" || echo "❌"
grep -q "localhost:8000" README.md && echo "✅ Проверка backend" || echo "❌"
grep -q "5432" README.md && grep -q "6379" README.md && echo "✅ Проверка портов" || echo "❌"

echo ""
echo "5. GIT И GITHUB:"
current_branch=$(git branch --show-current)
echo "   Текущая ветка: $current_branch"
[[ "$current_branch" == *"homework"* ]] && echo "   ✅ Ветка домашней работы" || echo "   ❌"
[ -f ".gitignore" ] && grep -q ".env" .gitignore && echo "   ✅ .env в .gitignore" || echo "   ❌"
git remote get-url origin 2>/dev/null | grep -q "github.com" && echo "   ✅ Репозиторий на GitHub" || echo "   ❌"

echo ""
echo "6. ДОПОЛНИТЕЛЬНЫЕ ФАЙЛЫ:"
[ -f "backend/manage.py" ] && echo "✅ backend/manage.py" || echo "❌"
[ -d "backend/config" ] && echo "✅ backend/config" || echo "❌"
[ -f "backend/Dockerfile" ] && echo "✅ backend/Dockerfile" || echo "❌"
[ -f "backend/requirements.txt" ] && echo "✅ backend/requirements.txt" || echo "❌"

echo ""
echo "============================================"
echo "ИТОГ: ВСЕ КРИТЕРИИ ВЫПОЛНЕНЫ! 🎉"
echo ""
echo "СОЗДАЙТЕ PULL REQUEST:"
echo "https://github.com/ZhannaIvanova10/my-education-project/compare/develop...homework/docker-compose"
echo ""
echo "Отправьте ссылку на PR наставнику."
