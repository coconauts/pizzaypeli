# Pizza y Peli

A simple app to plan and keep track of our home cinema sessions.

<img src="claude_log/8.png" style="max-width:700px; width:100%;" />

Made with Django, and mostly vibecoded with Claude and Cursor. I'm trying to keep a log of the prompts used at [claude_log/prompts.md](claude_log/prompts.md)

Uses https://github.com/tveronesi/imdbinfo to fetch movie metadata from imdb (no API keys required).

## Run with docker:

Build and run the docker image with:

`docker compose up --build`, then visit http://localhost:8000  

The docker setup runs a production build with gunicorn and whitenoise. 


### Deploying

If deploying to a public server, and `.env` file is needed with some security settings. Copy the sample env file:

```
cp .env.example .env
```

And then:

- Update `DJANGO_ALLOWED_HOSTS` to include your domain
- Generate a secret key with: `python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"`, then set it as the value for `DJANGO_SECRET_KEY`


## Local install

Make and use a virtualenv for all commands:

```
python3 -m venv .venv
source .venv/bin/activate
```

Thn install dependencies:

```pip install -r requirements.txt```

## Development

Note: use the virtual env for all commands:

`source .venv/bin/activate`

Run the app:

`python manage.py runserver`

Handle migrations:

```
python manage.py makemigrations # to create migrations for model changes
python mange.py migrate # to apply the changes to the DB
```

Django shell:

`python manage.py shell`

Add new dependencies:

`pip freeze > requirements.txt`

