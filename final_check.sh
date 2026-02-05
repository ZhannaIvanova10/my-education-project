#!/bin/bash

echo "🔍 ФИНАЛЬНАЯ ПРОВЕРКА ГОТОВНОСТИ"
echo "================================"

echo "1. Проверка Git статуса:"
git status --short

echo ""
echo "2. Проверка ключевых файлов:"
check_files() {
    for file in "$@"; do
        if [ -f "$file" ]; then
            echo "✅ $file"
        else
            echo "❌ $file - ОТСУТСТВУЕТ"
        fi
    done
}

key_files=(
    ".github/workflows/deploy.yml"
    "docker-compose.yaml"
    "Dockerfile"
    "nginx/Dockerfile"
    "nginx/nginx.conf"
    "nginx/default.conf"
    "ssh_keys/id_ed25519"
    "ssh_keys/id_ed25519.pub"
)

check_files "${key_files[@]}"

echo ""
echo "3. Проверка коммита:"
git log --oneline -1

echo ""
echo "4. Проверка SSH ключей:"
if [ -f "ssh_keys/id_ed25519" ] && [ -f "ssh_keys/id_ed25519.pub" ]; then
    echo "✅ SSH ключи созданы"
    echo "   Публичный ключ: $(cat ssh_keys/id_ed25519.pub | cut -d' ' -f1-2)..."
else
    echo "❌ SSH ключи не созданы"
fi
echo ""
echo "📊 ИТОГ:"
echo "Если все файлы отмечены ✅, создавайте Pull Request!"
echo ""
echo "🚀 ССЫЛКА ДЛЯ СОЗДАНИЯ PR:"
echo "https://github.com/ZhannaIvanova10/my-education-project/compare/develop...homework/cicd-deploy"
