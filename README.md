# Проект онлайн-обучения с Docker Compose

## Быстрый старт

### 1. Клонирование репозитория
```bash
git clone https://github.com/ZhannaIvanova10/my-education-project.git
cd my_education_project
```

### 2. Настройка переменных окружения
```bash
cp .env.example .env
```
Отредактируйте файл `.env` и укажите свои значения.

### 3. Запуск проекта через Docker Compose
```bash
docker compose up --build
```
### 4. Создание суперпользователя Django
```bash
docker compose exec backend python manage.py createsuperuser
```

## Проверка работоспособности сервисов

### Backend (Django)
- **Веб-интерфейс**: http://localhost:8000
- **Административная панель**: http://localhost:8000/admin

### База данных (PostgreSQL)
```bash
docker compose exec db psql -U education_user -d education_db -c "\l"
```

### Redis
```bash
docker compose exec redis redis-cli ping
```

### Celery Worker
```bash
docker compose logs celery_worker
```

### Celery Beat
```bash
docker compose logs celery_beat
```

## Основные команды

```bash
# Запуск в фоновом режиме
docker compose up -d --build

# Остановка всех сервисов
docker compose down

# Просмотр логов
docker compose logs -f backend
# Выполнение миграций
docker compose exec backend python manage.py migrate
```

## Структура проекта
```
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
```

## Решение проблем с Docker Desktop

Если Docker Desktop не запускается:
1. Нажмите Win, введите "Docker Desktop", нажмите Enter
2. Или перезагрузите компьютер
3. Или переустановите Docker Desktop
