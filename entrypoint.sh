#!/bin/sh
# This is the entrypoint for the docker container.
# It generates and persists a secret key if one doesn't exists, 
# runs migrations and starts the server.

# Generate secret key if not provided and file doesn't exist
if [ -z "$DJANGO_SECRET_KEY" ]; then
    if [ ! -f /app/data/.secret_key ]; then
        python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())" > /app/data/.secret_key
    fi
    export DJANGO_SECRET_KEY=$(cat /app/data/.secret_key)
fi

# Run migrations and start server
python manage.py migrate
exec gunicorn --bind 0.0.0.0:8000 pizzaypeli.wsgi:application
