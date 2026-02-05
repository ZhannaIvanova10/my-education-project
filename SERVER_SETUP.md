# 🖥️ Инструкция по настройке продакшен сервера

## Выбор хостинга

### Вариант 1: DigitalOcean (рекомендуется)
1. Зарегистрируйтесь на [digitalocean.com](https://digitalocean.com)
2. Создайте новый Droplet:
   - Выберите Ubuntu 22.04 LTS
   - Basic план ($6/месяц)
   - Выберите регион ближайший к вам
   - Добавьте свой SSH ключ
3. Запишите IP адрес сервера

### Вариант 2: Timeweb Cloud (российский)
1. Зарегистрируйтесь на [timeweb.cloud](https://timeweb.cloud)
2. Создайте облачный сервер
3. Выберите Ubuntu 22.04

## Настройка сервера

### Шаг 1: Подключение
\`\`\`bash
ssh root@ВАШ_IP_АДРЕС
\`\`\`

### Шаг 2: Базовая настройка
\`\`\`bash
# Обновление системы
apt update && apt upgrade -y

# Установка необходимого ПО
apt install -y docker.io docker-compose nginx git

# Проверка установки
docker --version
docker-compose --version
\`\`\`

### Шаг 3: Создание пользователя для деплоя
\`\`\`bash
# Создаем пользователя
adduser deployer

# Добавляем в группы
usermod -aG sudo deployer
usermod -aG docker deployer

# Настраиваем SSH доступ
mkdir -p /home/deployer/.ssh
cp /root/.ssh/authorized_keys /home/deployer/.ssh/
chown -R deployer:deployer /home/deployer/.ssh
chmod 700 /home/deployer/.ssh
chmod 600 /home/deployer/.ssh/authorized_keys
\`\`\`

### Шаг 4: Настройка фаервола
\`\`\`bash
# Разрешаем необходимые порты
ufw allow OpenSSH
ufw allow 80    # HTTP
ufw allow 443   # HTTPS
ufw allow 8000  # Django приложение

# Включаем фаервол
ufw --force enable

# Проверяем правила
ufw status
\`\`\`

### Шаг 5: Настройка проекта
\`\`\`bash
# Подключаемся как deployer
ssh deployer@ВАШ_IP_АДРЕС

# Клонируем проект
git clone https://github.com/ZhannaIvanova10/my-education-project
cd my-education-project

# Создаем .env файл
cp .env.production.example .env

# Редактируем .env файл
nano .env
# ИЛИ
vim .env
\`\`\`

## Настройка Nginx (опционально)

\`\`\`bash
sudo nano /etc/nginx/sites-available/myapp
\`\`\`

Добавьте конфигурацию:
\`\`\`nginx
server {
    listen 80;
    server_name ваш-домен.com ваш-ip-адрес;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
\`\`\`

## Генерация SSH ключа для GitHub Actions

\`\`\`bash
# На вашем локальном компьютере:
ssh-keygen -t rsa -b 4096 -C "github-actions-deploy"

# Публичный ключ добавьте на сервер
cat ~/.ssh/id_rsa.pub
# Скопируйте вывод и добавьте в /home/deployer/.ssh/authorized_keys на сервере

# Приватный ключ добавьте в GitHub Secrets как SSH_PRIVATE_KEY
cat ~/.ssh/id_rsa
\`\`\`

## Тестирование деплоя

\`\`\`bash
# На сервере:
cd /home/deployer/my-education-project
./deploy.sh
\`\`\`

## Проверка работоспособности

1. Откройте в браузере: \`http://ВАШ_IP_АДРЕС:8000\`
2. Проверьте логи: \`docker-compose logs\`
3. Проверьте статус: \`docker-compose ps\`

## Устранение проблем

### Проблема: Docker permission denied
\`\`\`bash
sudo usermod -aG docker $USER
newgrp docker
\`\`\`

### Проблема: Порт 8000 занят
\`\`\`bash
sudo lsof -i :8000
sudo kill -9 <PID>
\`\`\`

### Проблема: Ошибки базы данных
\`\`\`bash
docker-compose exec backend python manage.py migrate
docker-compose exec backend python manage.py createsuperuser
\`\`\`

## Мониторинг

\`\`\`bash
# Просмотр логов в реальном времени
docker-compose logs -f

# Использование ресурсов
docker stats

# Проверка сетевых соединений
docker network ls
docker network inspect my-education-project_default
\`\`\`

## Резервное копирование

\`\`\`bash
# Бэкап базы данных
docker-compose exec postgres pg_dump -U education_user education_db > backup.sql

# Бэкап статических файлов
tar -czf static_backup.tar.gz staticfiles/ media/
\`\`\`

## Обновление

\`\`\`bash
# Автоматическое обновление через GitHub Actions
# Просто сделайте push в ветку main

# Ручное обновление
cd /home/deployer/my-education-project
git pull
./deploy.sh
\`\`\`

## 🔗 Полезные ссылки
- [DigitalOcean](https://digitalocean.com)
- [Timeweb Cloud](https://timeweb.cloud)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Documentation](https://docs.docker.com)
- [Django Deployment Checklist](https://docs.djangoproject.com/en/stable/howto/deployment/checklist/)
