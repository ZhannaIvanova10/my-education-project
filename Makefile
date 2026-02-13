.PHONY: help up down build restart logs clean test migrate superuser

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m # No Color

help:
	@echo "$(YELLOW)Доступные команды:$(NC)"
	@echo "$(GREEN)make up$(NC)        - Запустить все сервисы"
	@echo "$(GREEN)make up-detach$(NC) - Запустить в фоновом режиме"
	@echo "$(GREEN)make down$(NC)      - Остановить все сервисы"
	@echo "$(GREEN)make build$(NC)     - Пересобрать контейнеры"
	@echo "$(GREEN)make restart$(NC)   - Перезапустить все сервисы"
	@echo "$(GREEN)make logs$(NC)      - Показать логи всех сервисов"
	@echo "$(GREEN)make logs-backend$(NC) - Логи только бэкенда"
	@echo "$(GREEN)make clean$(NC)     - Остановить и удалить все контейнеры, тома"
	@echo "$(GREEN)make test$(NC)      - Запустить тесты"
	@echo "$(GREEN)make migrate$(NC)   - Применить миграции"
	@echo "$(GREEN)make superuser$(NC) - Создать суперпользователя Django"
	@echo "$(GREEN)make status$(NC)    - Показать статус всех сервисов"
	@echo "$(GREEN)make shell$(NC)     - Открыть shell в контейнере backend"

up:
	@echo "$(YELLOW)Запуск всех сервисов...$(NC)"
	docker-compose up --build

up-detach:
	@echo "$(YELLOW)Запуск в фоновом режиме...$(NC)"
	docker-compose up --build -d

down:
	@echo "$(YELLOW)Остановка всех сервисов...$(NC)"
	docker-compose down

build:
	@echo "$(YELLOW)Пересборка контейнеров...$(NC)"
	docker-compose build --no-cache

restart:
	@echo "$(YELLOW)Перезапуск сервисов...$(NC)"
	docker-compose restart

logs:
	@echo "$(YELLOW)Логи всех сервисов:$(NC)"
	docker-compose logs -f

logs-backend:
	@echo "$(YELLOW)Логи бэкенда:$(NC)"
	docker-compose logs -f backend

clean:
	@echo "$(YELLOW)Полная очистка:$(NC)"
	docker-compose down -v
	docker system prune -f

test:
	@echo "$(YELLOW)Запуск тестов...$(NC)"
	docker-compose exec backend python manage.py test

migrate:
	@echo "$(YELLOW)Применение миграций...$(NC)"
	docker-compose exec backend python manage.py migrate

superuser:
	@echo "$(YELLOW)Создание суперпользователя Django...$(NC)"
	docker-compose exec backend python manage.py createsuperuser

status:
	@echo "$(YELLOW)Статус сервисов:$(NC)"
	docker-compose ps
shell:
	@echo "$(YELLOW)Открытие shell в контейнере backend...$(NC)"
	docker-compose exec backend /bin/bash

env-template:
	@echo "$(YELLOW)Создание .env из шаблона...$(NC)"
	cp .env.example .env
	@echo "$(GREEN)Файл .env создан. Отредактируйте его при необходимости.$(NC)"
