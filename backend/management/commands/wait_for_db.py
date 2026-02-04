from django.core.management.base import BaseCommand
import time
import sys
from django.db import connections
from django.db.utils import OperationalError
class Command(BaseCommand):
    help = 'Wait for database to become available'

    def add_arguments(self, parser):
        parser.add_argument(
            '--timeout',
            type=int,
            default=60,
            help='Maximum time to wait for database in seconds (default: 60)'
        )
        parser.add_argument(
            '--interval',
            type=float,
            default=2.0,
            help='Interval between retries in seconds (default: 2.0)'
        )

    def handle(self, *args, **options):
        self.stdout.write(self.style.NOTICE('Waiting for database connection...'))
        
        timeout = options['timeout']
        interval = options['interval']
        max_retries = int(timeout / interval)
        
        for i in range(max_retries):
            try:
                connection = connections['default']
                connection.ensure_connection()
                
                self.stdout.write(
                    self.style.SUCCESS(f'✅ Database is available! Connection established.')
                )
                return
            except OperationalError as e:
                if i == 0:
                    self.stdout.write(self.style.WARNING(f'Database not ready: {e}'))
                
                self.stdout.write(f'Attempt {i + 1}/{max_retries}: Retrying in {interval} seconds...')
                
                if i < max_retries - 1:
                    time.sleep(interval)
                else:
                    self.stdout.write(
                        self.style.ERROR(
                            f'❌ Could not connect to database after {timeout} seconds.'
                        )
                    )
                    sys.exit(1)
