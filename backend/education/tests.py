from django.test import TestCase

class SimpleTest(TestCase):
    def test_addition(self):
        """Простой тест математики"""
        self.assertEqual(1 + 1, 2)
    
    def test_import_education(self):
        """Проверка импорта приложения"""
        try:
            import education
            self.assertTrue(True)
        except ImportError:
            self.fail("Failed to import education")
    
    def test_health_view(self):
        """Проверка, что view существует"""
        from education.views import health_check
        self.assertTrue(callable(health_check))
