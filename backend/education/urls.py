from django.urls import path
from . import views

urlpatterns = [
    # Временный маршрут для тестирования
    path('health/', views.health_check, name='health-check'),
]