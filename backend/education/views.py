cat > backend/education/views.py << 'EOF'
from django.http import JsonResponse

def health_check(request):
    return JsonResponse({'status': 'ok', 'service': 'education'})