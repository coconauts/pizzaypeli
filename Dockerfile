FROM python:3.12-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt gunicorn whitenoise

# Copy application code
COPY . .

# Collect static files
RUN python manage.py collectstatic --noinput

# Create data directory for persistent files
RUN mkdir -p /app/data

# Expose port
EXPOSE 8000

CMD ["./entrypoint.sh"]
