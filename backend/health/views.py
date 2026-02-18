from django.http import JsonResponse
from django.db import connection
from django.core.cache import cache
import redis
from django.conf import settings


def health_check(request):
    """Health check endpoint для мониторинга"""
    health_status = {
        'status': 'ok',
        'services': {}
    }

    # Check database
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
            cursor.fetchone()
        health_status['services']['database'] = 'ok'
    except Exception as e:
        health_status['services']['database'] = f'error: {str(e)}'
        health_status['status'] = 'degraded'

    # Check redis
    try:
        redis_client = redis.Redis(
            host=settings.REDIS_HOST,
            port=settings.REDIS_PORT,
            socket_connect_timeout=2
        )
        redis_client.ping()
        health_status['services']['redis'] = 'ok'
    except Exception as e:
        health_status['services']['redis'] = f'error: {str(e)}'
        health_status['status'] = 'degraded'

    # Check cache
    try:
        cache.set('health_check', 'ok', 5)
        if cache.get('health_check') == 'ok':
            health_status['services']['cache'] = 'ok'
        else:
            health_status['services']['cache'] = 'error'
            health_status['status'] = 'degraded'
    except Exception as e:
        health_status['services']['cache'] = f'error: {str(e)}'
        health_status['status'] = 'degraded'

    return JsonResponse(health_status)


def ping(request):
    """Simple ping endpoint"""
    return JsonResponse({'ping': 'pong'})
