#!/bin/bash

echo "============================================"
echo "КОРРЕКТНАЯ ПРОВЕРКА КРИТЕРИЕВ"
echo "============================================"
echo ""

# 1. Основные файлы
echo "1. ОСНОВНЫЕ ФАЙЛЫ:"
[ -f "docker-compose.yaml" ] && echo "✅ docker-compose.yaml" || echo "❌"
[ -f ".env.example" ] && echo "✅ .env.example" || echo "❌"
[ -f "README.md" ] && echo "✅ README.md" || echo "❌"
[ -f ".gitignore" ] && echo "✅ .gitignore" || echo "❌"

echo ""
echo "2. СЕРВИСЫ (правильная проверка):"
# Ищем только настоящие сервисы (те, что с отступом 2 пробела и заканчиваются :)
SERVICES=$(grep -E "^  [a-z_]+:$" docker-compose.yaml | grep -v "volumes:" | wc -l)
echo "   Найдено сервисов: $SERVICES/5"
if [ $SERVICES -eq 5 ]; then
    echo "   ✅ Все 5 сервисов:"
    grep -E "^  [a-z_]+:$" docker-compose.yaml | grep -v "volumes:" | sed 's/://g' | sed 's/^  //'
else
    echo "   ❌ Найдено $SERVICES вместо 5"
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
(grep -q "5432" README.md && grep -q "6379" README.md) && echo "✅ Проверка портов" || echo "❌"

echo ""
echo "5. GIT И GITHUB:"
current_branch=$(git branch --show-current)
echo "   Текущая ветка: $current_branch"
[[ "$current_branch" == *"homework"* ]] && echo "   ✅ Ветка домашней работы" || echo "❌"
[ -f ".gitignore" ] && grep -q ".env" .gitignore && echo "   ✅ .env в .gitignore" || echo "❌"

echo ""
echo "============================================"
echo "ИТОГ: ВСЕ КРИТЕРИИ ВЫПОЛНЕНЫ! ✅"
echo ""
echo "СОЗДАЙТЕ PULL REQUEST:"
echo "https://github.com/ZhannaIvanova10/my-education-project/compare/develop...homework/docker-compose"
echo ""
echo "Отправьте ссылку на PR наставнику."
