from django.core.management.base import BaseCommand
import time
from django.db import connections
from django.db.utils import OperationalError

class Command(BaseCommand):
    help = 'Wait for database to become available'

    def handle(self, *args, **options):
        self.stdout.write('Waiting for database...')
        max_retries = 20
        
        for i in range(max_retries):
            try:
                connection = connections['default']
                connection.cursor()
                self.stdout.write(self.style.SUCCESS('Database available!'))
                return
            except OperationalError:
                self.stdout.write(f'Database unavailable, waiting 2s... ({i+1}/{max_retries})')
                time.sleep(2)
        
        self.stdout.write(self.style.ERROR('Could not connect to database!'))
