from django.test import TestCase


class SimpleTest(TestCase):
    def test_basic_addition(self):
        """Простой тест для проверки работы CI/CD"""
        self.assertEqual(1 + 1, 2)

    def test_django_import(self):
        """Проверка импорта Django"""
        import django
        self.assertTrue(True)

    def test_education_app_imports(self):
        """Проверка импорта нашего приложения"""
        try:
            from education import views
            self.assertTrue(True)
        except ImportError:
            self.fail("Failed to import education app")