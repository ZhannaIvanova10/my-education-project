Проект онлайн-обучения с Docker Compose
Быстрый старт
1. Клонирование репозитория
bash
git clone https://github.com/ZhannaIvanova10/my-education-project.git
cd my_education_project
2. Настройка переменных окружения
bash
cp .env.example .env
Отредактируйте файл .env и укажите свои значения.

3. Запуск проекта через Docker Compose
bash
docker compose up --build
4. Создание суперпользователя Django
bash
docker compose exec backend python manage.py createsuperuser
Проверка работоспособности сервисов
Backend (Django)
Веб-интерфейс: http://localhost:8000

Административная панель: http://localhost:8000/admin

База данных (PostgreSQL)
bash
docker compose exec db psql -U education_user -d education_db -c "\l"
Redis
bash
docker compose exec redis redis-cli ping
Celery Worker
bash
docker compose logs celery_worker
Celery Beat
bash
docker compose logs celery_beat
Основные команды
bash
# Запуск в фоновом режиме
docker compose up -d --build

# Остановка всех сервисов
docker compose down

# Просмотр логов
docker compose logs -f backend

# Выполнение миграций
docker compose exec backend python manage.py migrate
Структура проекта
text
my_education_project/
├── docker-compose.yaml
├── .env.example
├── .gitignore
├── README.md
└── backend/
    ├── Dockerfile
    ├── requirements.txt
    ├── manage.py
    └── ...
Решение проблем с Docker Desktop
Если Docker Desktop не запускается:

Нажмите Win, введите "Docker Desktop", нажмите Enter

Или перезагрузите компьютер

Или переустановите Docker Desktop

🛠️ Управление через Makefile
Для удобства используйте команды Makefile:

bash
# Показать все команды
make help

# Запуск
make up              # Запуск с логами
make up-detach       # Запуск в фоне

# Остановка
make down            # Остановить сервисы
make clean           # Полная очистка (контейнеры + тома)

# Управление
make restart         # Перезапустить все сервисы
make build           # Пересобрать контейнеры

# Логи
make logs            # Логи всех сервисов
make logs-backend    # Логи только бэкенда

# Django команды
make migrate         # Применить миграции
make superuser       # Создать суперпользователя
make test            # Запустить тесты

# Мониторинг
make status          # Статус всех сервисов
make shell           # Shell в контейнере backend
🐳 Сервисы проекта
Сервис	Порт	Описание	Контейнер
Backend (Django)	8000	Основное приложение	education_backend
PostgreSQL	5432	База данных	education_db
Redis	6379	Кэш и брокер для Celery	education_redis
Celery Worker	-	Фоновые задачи	education_celery_worker
Celery Beat	-	Периодические задачи	education_celery_beat
✅ Финальная проверка перед сдачей
Запустите скрипт проверки:

bash
./check_final_submission.sh
Скрипт проверит все критерии домашнего задания и покажет готовность к сдаче.