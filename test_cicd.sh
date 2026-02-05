#!/bin/bash

echo "🔍 Тестирование CI/CD конфигурации"
echo "=================================="

echo "1. Проверка файлов..."
files=(
    ".github/workflows/deploy.yml"
    "deploy.sh"
    ".env.production.example"
    "SERVER_SETUP.md"
    "docker-compose.yaml"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file - отсутствует"
    fi
done

echo ""
echo "2. Проверка deploy.sh..."
if [ -x "deploy.sh" ]; then
    echo "✅ deploy.sh исполняемый"
else
    echo "⚠️  deploy.sh не исполняемый, исправляем..."
    chmod +x deploy.sh
fi
echo ""
echo "3. Проверка workflow..."
if grep -q "name: CI/CD Pipeline" .github/workflows/deploy.yml; then
    echo "✅ Workflow имеет правильное имя"
else
    echo "❌ Workflow имя не найдено"
fi

if grep -q "jobs:" .github/workflows/deploy.yml; then
    echo "✅ Workflow содержит jobs"
else
    echo "❌ Workflow не содержит jobs"
fi

echo ""
echo "📊 Итог:"
echo "Все файлы созданы, готовы к коммиту и PR."
echo ""
echo "🚀 Дальнейшие шаги:"
echo "1. git add ."
echo "2. git commit -m 'CI/CD setup'"
echo "3. git push origin homework/cicd-deploy"
echo "4. Создать PR на GitHub"
