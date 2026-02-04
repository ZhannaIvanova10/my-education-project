#!/bin/bash

echo "🔍 ФИНАЛЬНАЯ ПРОВЕРКА ПЕРЕД СДАЧЕЙ"
echo "=================================="
echo ""

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

success=0
total=0

check() {
    local description=$1
    local command=$2
    shift 2
    
    ((total++))
    
    if eval "$command" "$@" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ $description${NC}"
        ((success++))
        return 0
    else
        echo -e "${RED}❌ $description${NC}"
        return 1
    fi
}
echo "📂 Проверка файловой структуры:"
echo "-------------------------------"
check "Файл docker-compose.yaml существует" "[ -f docker-compose.yaml ]"
check "Папка backend существует" "[ -d backend ]"
check "Dockerfile в backend существует" "[ -f backend/Dockerfile ]"
check ".env.example существует" "[ -f .env.example ]"
check "Makefile существует" "[ -f Makefile ]"
check "README.md существует" "[ -f README.md ]"
check "wait_for_db.py существует" "[ -f backend/management/commands/wait_for_db.py ]"

echo ""
echo "🔧 Проверка содержимого файлов:"
echo "------------------------------"
check "docker-compose.yaml содержит 5 сервисов" "grep -c '^  [a-z_]*:' docker-compose.yaml | grep -q '^5$'"
check "docker-compose.yaml имеет healthcheck" "grep -q 'healthcheck:' docker-compose.yaml"
check "docker-compose.yaml использует env_file" "grep -q 'env_file:' docker-compose.yaml"
check "Dockerfile использует Python" "grep -q 'python:' backend/Dockerfile"
check "requirements.txt содержит Django" "grep -q 'Django' backend/requirements.txt"
check ".gitignore содержит .env" "grep -q '\.env' .gitignore"

echo ""
echo "📝 Проверка документации:"
echo "-----------------------"
check "README содержит команду docker compose up" "grep -q 'docker compose up' README.md"
check "README содержит localhost:8000" "grep -q 'localhost:8000' README.md"
check "README содержит Makefile" "grep -q 'Makefile' README.md"
check ".env.example содержит SECRET_KEY" "grep -q 'SECRET_KEY' .env.example"
check ".env.example содержит POSTGRES_PASSWORD" "grep -q 'POSTGRES_PASSWORD' .env.example"

echo ""
echo "🐳 Проверка Docker конфигурации:"
echo "-------------------------------"
check "Порт 8000 для backend" "grep -q '\"8000:8000\"' docker-compose.yaml"
check "Порт 5432 для db" "grep -q '\"5432:5432\"' docker-compose.yaml"
check "Порт 6379 для redis" "grep -q '\"6379:6379\"' docker-compose.yaml"
check "depends_on в backend" "grep -q 'depends_on:' docker-compose.yaml"
check "Команда wait_for_db в backend" "grep -q 'wait_for_db' docker-compose.yaml"

echo ""
echo "📊 Результаты:"
echo "-------------"
percentage=$((success * 100 / total))
echo "Выполнено: $success из $total проверок ($percentage%)"

if [ $percentage -eq 100 ]; then
    echo -e "\n${GREEN}🎉 ВСЕ ПРОВЕРКИ ПРОЙДЕНЫ! ПРОЕКТ ГОТОВ К СДАЧЕ!${NC}"
    echo -e "\n📋 Следующие шаги:"
    echo "1. git add check_final_submission.sh"
    echo "2. git commit -m 'add final validation script'"
    echo "3. git push origin homework/docker-compose"
    echo "4. На GitHub создать Pull Request из homework/docker-compose в develop"
elif [ $percentage -ge 80 ]; then
    echo -e "\n${YELLOW}⚠️  БОЛЬШИНСТВО ПРОВЕРОК ПРОЙДЕНО. Проверьте неудачные проверки.${NC}"
else
    echo -e "\n${RED}❌ НУЖНО ИСПРАВИТЬ ОШИБКИ ПЕРЕД СДАЧЕЙ${NC}"
fi
exit $((100 - percentage))
