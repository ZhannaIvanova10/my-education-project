#!/bin/bash

echo "================================================"
echo "ФИНАЛЬНАЯ ПРОВЕРКА ПРОЕКТА CI/CD"
echo "================================================"
echo

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "1. ПРОВЕРКА WORKFLOW:"
echo "-------------------"

# Проверяем полную структуру deploy.yml
echo "Содержимое deploy.yml (первые 30 строк):"
echo "----------------------------------------"
head -30 .github/workflows/deploy.yml
echo

# Проверяем ключевые элементы
echo "Ключевые проверки:"

jobs_found=0
jobs_needed=("lint" "test" "build" "deploy")
for job in "${jobs_needed[@]}"; do
    if grep -q "^  $job:" .github/workflows/deploy.yml; then
        echo -e "  ${GREEN}✅ Job $job существует${NC}"
        ((jobs_found++))
    else
        echo -e "  ${RED}❌ Job $job не найден${NC}"
    fi
done
echo
echo "2. ПРОВЕРКА ЗАВИСИМОСТЕЙ:"
echo "-------------------------"

# Проверяем зависимости
dependencies_ok=0
dependencies=(
    "test -> lint"
    "build -> test" 
    "deploy -> build"
)

for dep in "${dependencies[@]}"; do
    from_job=${dep% -> *}
    to_job=${dep#* -> }
    if grep -A5 "^  $from_job:" .github/workflows/deploy.yml | grep -q "needs: $to_job"; then
        echo -e "  ${GREEN}✅ $dep правильная${NC}"
        ((dependencies_ok++))
    else
        echo -e "  ${RED}❌ $dep неправильная${NC}"
    fi
done

echo
echo "3. ПРОВЕРКА УСЛОВИЙ ЗАПУСКА:"
echo "---------------------------"

if grep -q "homework/cicd-deploy" .github/workflows/deploy.yml; then
    echo -e "  ${GREEN}✅ Ветка homework/cicd-deploy в триггерах${NC}"
else
    echo -e "  ${RED}❌ Ветка не в триггерах${NC}"
fi
echo
echo "4. ИТОГОВЫЙ РЕЗУЛЬТАТ:"
echo "----------------------"

if [ $jobs_found -eq 4 ] && [ $dependencies_ok -eq 3 ]; then
    echo -e "${GREEN}================================================${NC}"
    echo -e "${GREEN}✅ ВСЕ ПРОВЕРКИ ПРОЙДЕНЫ УСПЕШНО!${NC}"
    echo -e "${GREEN}✅ WORKFLOW НАСТРОЕН КОРРЕКТНО!${NC}"
    echo -e "${GREEN}================================================${NC}"
else
    echo -e "${RED}================================================${NC}"
    echo -e "${RED}❌ ЕСТЬ ПРОБЛЕМЫ В КОНФИГУРАЦИИ${NC}"
    echo -e "${RED}✅ Найдено jobs: $jobs_found/4${NC}"
    echo -e "${RED}✅ Правильных зависимостей: $dependencies_ok/3${NC}"
    echo -e "${RED}================================================${NC}"
fi

echo
echo "5. РЕКОМЕНДАЦИИ:"
echo "---------------"
echo "1. Сделайте коммит и пуш изменений"
echo "2. Проверьте GitHub Actions по ссылке:"
echo "   https://github.com/ZhannaIvanova10/my-education-project/actions"
echo "3. Обновите комментарий в PR"
echo "4. Сообщите наставнику о готовности"
