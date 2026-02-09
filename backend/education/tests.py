from django.test import TestCase

class EducationTests(TestCase):
    """Тесты для проверки работы CI/CD"""
    
    def test_ci_cd_workflow(self):
        """Тест для проверки что CI/CD pipeline работает"""
        self.assertTrue(True, "CI/CD pipeline должен работать")
    
    def test_django_installed(self):
        """Тест что Django правильно установлен"""
        try:
            import django
            self.assertTrue(True, "Django установлен")
        except ImportError:
            self.fail("Django не установлен")
