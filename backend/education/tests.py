from django.test import TestCase

class SimpleTest(TestCase):
    def test_true_is_true(self):
        """Самый простой тест"""
        self.assertTrue(True)
    
    def test_math_works(self):
        """Проверка математики"""
        self.assertEqual(1 + 1, 2)
    
    def test_django_imports(self):
        """Проверка импорта Django"""
        import django
        from django.conf import settings
        self.assertTrue(True)
