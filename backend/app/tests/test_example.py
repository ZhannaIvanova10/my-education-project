"""Пример теста для CI/CD."""
from django.test import TestCase

class ExampleTest(TestCase):
    """Простой тест для проверки CI/CD."""
    
    def test_example(self):
        """Тест, который всегда проходит."""
        self.assertTrue(True)
        print("✅ Тест пройден успешно!")
