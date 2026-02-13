#!/bin/bash

echo "================================================"
echo "ПРОВЕРКА ПРОЕКТА ПО КРИТЕРИЯМ ДОМАШНЕГО ЗАДАНИЯ"
echo "================================================"
echo ""

# 1. КРИТЕРИЙ: Файл docker-compose.yaml в корне проекта
echo "1. ПРОВЕРКА docker-compose.yaml"
echo "--------------------------------"
if [ -f "docker-compose.yaml" ]; then
    echo "✅ docker-compose.yaml находится в корне проекта"
    
    # Проверяем сервисы
    echo "Проверка сервисов в docker-compose.yaml:"
    SERVICES=("backend" "db" "redis" "celery_worker" "celery_beat")
    ALL_SERVICES_PRESENT=true
    
    for service in "${SERVICES[@]}"; do
        if grep -q "^  $service:" docker-compose.yaml; then
            echo "  ✅ Сервис $service найден"
        else
            echo "  ❌ Сервис $service НЕ найден"
            ALL_SERVICES_PRESENT=false
        fi
    done
    
    if [ "$ALL_SERVICES_PRESENT" = true ]; then
        echo "✅ Все необходимые сервисы присутствуют"
    else
        echo "❌ Не все сервисы найдены"
    fi
    
    # Проверяем порты
    echo ""
    echo "Проверка портов:"
    if grep -q "ports:" docker-compose.yaml && grep -q "8000:8000" docker-compose.yaml && grep -q "5432:5432" docker-compose.yaml && grep -q "6379:6379" docker-compose.yaml; then
        echo "✅ Правильные порты указаны (8000, 5432, 6379)"
    else
        echo "❌ Проблемы с портами"
    fi
    # Проверяем зависимости
    echo ""
    echo "Проверка зависимостей:"
    if grep -q "depends_on:" docker-compose.yaml; then
        echo "✅ Зависимости между сервисами указаны"
    else
        echo "❌ Зависимости не указаны"
    fi
    
    # Проверяем переменные окружения
    echo ""
    echo "Проверка переменных окружения в docker-compose.yaml:"
    if grep -q "env_file:" docker-compose.yaml; then
        echo "✅ Переменные окружения подключены через env_file"
        if grep -q "env_file:" docker-compose.yaml | grep -q "\.env"; then
            echo "✅ Файл .env указан в env_file"
        fi
    elif grep -q "environment:" docker-compose.yaml; then
        echo "✅ Переменные окружения указаны через environment"
    else
        echo "❌ Переменные окружения не настроены"
    fi
    
else
    echo "❌ docker-compose.yaml НЕ найден в корне проекта"
fi

echo ""
echo "2. ПРОВЕРКА ПЕРЕМЕННЫХ ОКРУЖЕНИЯ"
echo "--------------------------------"
# Проверяем .env.example
if [ -f ".env.example" ]; then
    echo "✅ Шаблон .env.example находится в корне проекта"
    
    # Проверяем содержимое .env.example
    echo "Содержимое .env.example:"
    echo "-----------------------"
    cat .env.example
    echo "-----------------------"
    
    # Проверяем наличие чувствительных данных
    if grep -q "SECRET_KEY" .env.example && \
       grep -q "POSTGRES_PASSWORD" .env.example && \
       grep -q "CELERY_BROKER_URL" .env.example; then
        echo "✅ Все чувствительные данные вынесены в переменные"
    else
        echo "❌ Не все чувствительные данные вынесены"
    fi
else
    echo "❌ .env.example НЕ найден в корне проекта"
fi

# Проверяем, что .env не в репозитории
echo ""
echo "Проверка, что .env не в репозитории:"
if [ -f ".env" ]; then
    if git status --porcelain .env 2>/dev/null | grep -q ".env"; then
        echo "⚠️  .env отслеживается Git (это плохо!)"
    else
        echo "✅ .env НЕ отслеживается Git (правильно)"
    fi
else
    echo "ℹ️  Файл .env не существует (создайте из .env.example)"
fi

echo ""
echo "3. ПРОВЕРКА README.md"
echo "---------------------"

if [ -f "README.md" ]; then
    echo "✅ README.md существует"
    
    # Проверяем наличие инструкций по запуску
    echo ""
    echo "Проверка инструкций в README.md:"
    
    if grep -q "docker-compose" README.md || grep -q "docker compose" README.md; then
        echo "✅ Упоминание docker-compose есть"
    else
        echo "❌ Нет упоминания docker-compose"
    fi
    
    if grep -q "up --build" README.md || grep -q "up -d" README.md; then
        echo "✅ Команда для запуска проекта указана"
    else
        echo "❌ Команда для запуска не указана"
    fi
    # Проверяем описание проверки сервисов
    SERVICES_CHECK_COUNT=0
    if grep -iq "localhost:8000" README.md; then ((SERVICES_CHECK_COUNT++)); fi
    if grep -iq "5432" README.md || grep -iq "postgres" README.md; then ((SERVICES_CHECK_COUNT++)); fi
    if grep -iq "6379" README.md || grep -iq "redis" README.md; then ((SERVICES_CHECK_COUNT++)); fi
    if grep -iq "celery" README.md; then ((SERVICES_CHECK_COUNT++)); fi
    
    if [ $SERVICES_CHECK_COUNT -ge 2 ]; then
        echo "✅ Описана проверка сервисов ($SERVICES_CHECK_COUNT упоминаний)"
    else
        echo "❌ Недостаточно описания проверки сервисов"
    fi
    
else
    echo "❌ README.md НЕ найден"
fi

echo ""
echo "4. ПРОВЕРКА GIT И GITHUB"
echo "------------------------"

# Проверяем наличие веток
echo "Проверка веток Git:"
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)
if [ -n "$CURRENT_BRANCH" ]; then
    echo "Текущая ветка: $CURRENT_BRANCH"
    
    # Проверяем наличие ветки develop
    if git branch --list develop 2>/dev/null | grep -q develop; then
        echo "✅ Ветка develop существует"
    else
        echo "❌ Ветка develop НЕ существует"
    fi
    
    # Проверяем, что мы в ветке домашней работы
    if [[ "$CURRENT_BRANCH" == *"homework"* ]] || [[ "$CURRENT_BRANCH" == *"docker"* ]]; then
        echo "✅ Находимся в ветке домашней работы ($CURRENT_BRANCH)"
    else
        echo "⚠️  Не в ветке домашней работы"
    fi
else
    echo "❌ Не в Git репозитории"
fi

# Проверяем наличие удаленного репозитория
echo ""
echo "Проверка удаленного репозитория:"
if git remote -v 2>/dev/null | grep -q "origin"; then
    echo "✅ Удаленный репозиторий настроен"
    REMOTE_URL=$(git remote get-url origin 2>/dev/null)
    echo "  URL: $REMOTE_URL"
    
    # Проверяем, что это GitHub
    if echo "$REMOTE_URL" | grep -q "github.com"; then
        echo "✅ Репозиторий на GitHub"
    else
        echo "⚠️  Репозиторий не на GitHub"
    fi
else
    echo "❌ Удаленный репозиторий не настроен"
fi

# Проверяем .gitignore
echo ""
echo "Проверка .gitignore:"
if [ -f ".gitignore" ]; then
    echo "✅ .gitignore существует"
    
    IGNORED_FILES=(".env" ".idea" "venv" "__pycache__")
    IGNORE_COUNT=0
    
    for file in "${IGNORED_FILES[@]}"; do
        if grep -q "$file" .gitignore; then
            echo "  ✅ $file игнорируется"
            ((IGNORE_COUNT++))
        else
            echo "  ❌ $file НЕ игнорируется"
        fi
    done
    
    if [ $IGNORE_COUNT -eq ${#IGNORED_FILES[@]} ]; then
        echo "✅ .gitignore настроен правильно"
    else
        echo "⚠️  .gitignore настроен не полностью"
    fi
else
    echo "❌ .gitignore НЕ найден"
fi
# Проверяем, что игнорируемые файлы не в коммитах
echo ""
echo "Проверка игнорируемых файлов в коммитах:"
PROBLEM_FOUND=false

# Проверяем .env
if git ls-files .env 2>/dev/null | grep -q ".env"; then
    echo "❌ .env отслеживается Git (должен быть в .gitignore)"
    PROBLEM_FOUND=true
fi

# Проверяем .idea
if [ -d ".idea" ]; then
    if git ls-files .idea 2>/dev/null | head -5 | wc -l | grep -q "[1-9]"; then
        echo "❌ Файлы .idea отслеживаются Git"
        PROBLEM_FOUND=true
    fi
fi

# Проверяем __pycache__
if find . -name "__pycache__" -type d 2>/dev/null | head -1 | grep -q "__pycache__"; then
    if git ls-files | grep -q "__pycache__"; then
        echo "❌ __pycache__ отслеживается Git"
        PROBLEM_FOUND=true
    fi
fi

if [ "$PROBLEM_FOUND" = false ]; then
    echo "✅ Игнорируемые файлы не в коммитах"
fi

# Проверяем, что изменения загружены на GitHub
echo ""
echo "Проверка загрузки на GitHub:"
if git ls-remote --heads origin 2>/dev/null | grep -q "$CURRENT_BRANCH"; then
    echo "✅ Ветка $CURRENT_BRANCH загружена на GitHub"
else
    echo "❌ Ветка $CURRENT_BRANCH НЕ загружена на GitHub"
    echo "   Выполните: git push origin $CURRENT_BRANCH"
fi
echo ""
echo "5. ДОПОЛНИТЕЛЬНЫЕ ПРОВЕРКИ"
echo "--------------------------"

# Проверяем структуру backend
echo "Проверка структуры backend:"
if [ -f "backend/Dockerfile" ]; then
    echo "✅ backend/Dockerfile существует"
    
    if grep -q "python" backend/Dockerfile; then
        echo "✅ Dockerfile использует Python"
    fi
else
    echo "❌ backend/Dockerfile НЕ найден"
fi

if [ -f "backend/requirements.txt" ]; then
    echo "✅ backend/requirements.txt существует"
else
    echo "❌ backend/requirements.txt НЕ найден"
fi

if [ -f "backend/manage.py" ]; then
    echo "✅ backend/manage.py существует"
else
    echo "❌ backend/manage.py НЕ найден"
fi

# Проверяем кастомную команду wait_for_db
if [ -f "backend/management/commands/wait_for_db.py" ]; then
    echo "✅ Кастомная команда wait_for_db существует"
else
    echo "❌ wait_for_db.py НЕ найден"
fi

echo ""
echo "================================================"
echo "ИТОГОВАЯ ОЦЕНКА"
echo "================================================"

# Подсчитываем результаты
TOTAL_CHECKS=0
PASSED_CHECKS=0

# Функция для подсчета
count_check() {
    ((TOTAL_CHECKS++))
    if [ "$1" = true ]; then
        ((PASSED_CHECKS++))
    fi
}
# Оцениваем каждый критерий
echo "Критерий 1: docker-compose.yaml"
echo "  • В корне проекта: $( [ -f "docker-compose.yaml" ] && echo "✅" || echo "❌" )"
count_check $([ -f "docker-compose.yaml" ] && echo true || echo false)

echo "  • Все сервисы: $(grep -q "^  backend:" docker-compose.yaml && grep -q "^  db:" docker-compose.yaml && grep -q "^  redis:" docker-compose.yaml && grep -q "^  celery_worker:" docker-compose.yaml && grep -q "^  celery_beat:" docker-compose.yaml && echo "✅" || echo "❌")"
count_check $(grep -q "^  backend:" docker-compose.yaml && grep -q "^  db:" docker-compose.yaml && grep -q "^  redis:" docker-compose.yaml && grep -q "^  celery_worker:" docker-compose.yaml && grep -q "^  celery_beat:" docker-compose.yaml && echo true || echo false)

echo ""
echo "Критерий 2: Переменные окружения"
echo "  • .env.example в корне: $( [ -f ".env.example" ] && echo "✅" || echo "❌" )"
count_check $([ -f ".env.example" ] && echo true || echo false)

echo "  • env_file в docker-compose.yaml: $(grep -q "env_file:" docker-compose.yaml && echo "✅" || echo "❌")"
count_check $(grep -q "env_file:" docker-compose.yaml && echo true || echo false)

echo ""
echo "Критерий 3: README.md"
echo "  • Файл существует: $( [ -f "README.md" ] && echo "✅" || echo "❌" )"
count_check $([ -f "README.md" ] && echo true || echo false)

echo "  • Есть команда запуска: $(grep -q "up --build" README.md && echo "✅" || echo "❌")"
count_check $(grep -q "up --build" README.md && echo true || echo false)

echo ""
echo "Критерий 4: Git и GitHub"
echo "  • Ветка домашней работы: $( [[ "$CURRENT_BRANCH" == *"homework"* ]] && echo "✅" || echo "❌" )"
count_check $([[ "$CURRENT_BRANCH" == *"homework"* ]] && echo true || echo false)

echo "  • .gitignore настроен: $( [ -f ".gitignore" ] && grep -q ".env" .gitignore && echo "✅" || echo "❌" )"
count_check $([ -f ".gitignore" ] && grep -q ".env" .gitignore && echo true || echo false)

echo ""
echo "================================================"
echo "РЕЗУЛЬТАТ: $PASSED_CHECKS/$TOTAL_CHECKS критериев выполнено"
if [ $PASSED_CHECKS -eq $TOTAL_CHECKS ]; then
    echo "✅ ВСЕ КРИТЕРИИ ВЫПОЛНЕНЫ! Проект готов к сдаче."
else
    echo "⚠️  НЕ ВСЕ КРИТЕРИИ ВЫПОЛНЕНЫ. Нужно исправить."
fi
echo ""
echo "СЛЕДУЮЩИЕ ШАГИ:"
echo "1. Создайте ветку develop, если её нет: git branch develop"
echo "2. Создайте Pull Request на GitHub из ветки $CURRENT_BRANCH в develop"
echo "3. Отправьте ссылку на PR наставнику"
