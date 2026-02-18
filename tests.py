from django.test import TestCase

class RootTests(TestCase):
    def test_basic(self):
        self.assertEqual(1, 1)
