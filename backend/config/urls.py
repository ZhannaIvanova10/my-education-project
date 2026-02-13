from django.urls import include

urlpatterns += [
    path('api/', include('health.urls')),
]