# Pizza y Peli

A simple app to plan and keep track of our home cinema sessions.

<img src="claude_log/8.png" style="max-width:700px; width:100%;" />

Made with Django, and mostly vibecoded with Claude and Cursor. I'm trying to keep a log of the prompts used at [claude_log/prompts.md](claude_log/prompts.md)

Uses https://github.com/tveronesi/imdbinfo to fetch movie metadata from imdb (no API keys required).

## Run with Docker

You'll need Docker: https://docs.docker.com/engine/install/

Build and run:

```
docker compose up --build
```

Then visit http://localhost:8000

This runs with production settings (gunicorn + whitenoise, DEBUG=False).

To stop: `docker compose down`

To run in background:

`docker compose start` or `docker compose up -d`

To force a clean rebuild:

`docker compose build --no-cache`

### Configuration

Some settings can be overriden with environment variables:

- `CUSTOM_DOMAIN`: **required** if you're running on a public server (or you'll get 400 errors). Defaults to localhost.
- `PORT`: defaults to 8000, if unset.
- ... and more. 

Check [.env.example](.env.example) for the full list. Make a copy to edit to your needs:

`cp .env.example .env`

## Development cookbook

Note: make and use a virtualenv for all commands:

```
python3 -m venv .venv
source .venv/bin/activate
```

Install dependencies: 
```pip install -r requirements.txt```


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

## Keeping imdbinfo up to date

We're relying on a third party library parsing the imDB html directly (https://github.com/tveronesi/imdbinfo). As such, every time imdb changes the format, the library becomes outdated and the app breaks. If you're getting 500 errors, most likely this is the cause.

A quick fix is to force a version bump on the library:

`pip install -U imdbinfo`

To mitigate this in production:

- The container's entrypoint runs `pip install -U imdbinfo` on every start, so a `docker compose restart web` is enough to pick up a new release.
- A helper script, [update-imdbinfo.sh](update-imdbinfo.sh), checks if the pip version is stale, and restarts the container when there's a new version.
- You can setup a crontab that runs this script in a production server: `*/10 * * * * /path/to/pizzaypeli/update-imdbinfo.sh >> /var/log/pizzaypeli-update.log 2>&1`


