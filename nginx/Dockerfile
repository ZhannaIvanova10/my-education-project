FROM nginx:alpine

# Копируем конфигурацию
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

# Создаем директорию для статических файлов
RUN mkdir -p /var/www/static

# Открываем порты
EXPOSE 80 443
