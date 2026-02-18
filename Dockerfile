FROM python:3.10-slim

WORKDIR /app

# Копируем только backend
COPY backend/ /app/backend/
COPY backend/requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app/backend

CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000"]