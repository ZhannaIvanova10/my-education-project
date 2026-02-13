<<<<<<< HEAD
"""WSGI конфигурация для CI/CD тестов."""
=======
>>>>>>> origin/homework/docker-compose
import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
application = get_wsgi_application()
