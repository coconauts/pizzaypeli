#!/bin/sh
# Restarts the web container if a newer imdbinfo is available on PyPI.
# Restarting triggers entrypoint.sh, which runs `pip install -U imdbinfo`.
#
# Safe to run frequently from a host crontab, e.g. every 10 minutes:
#   */10 * * * * /path/to/pizzaypeli/update-imdbinfo.sh >> /var/log/pizzaypeli-update.log 2>&1

set -eu

cd "$(dirname "$0")"

# Bail if the web container isn't running.
if ! docker compose ps --status running --services 2>/dev/null | grep -qx web; then
    echo "$(date -Is): web container is not running, skipping"
    exit 0
fi

# `pip index versions` reports both INSTALLED and LATEST; compare them.
# (The subcommand is marked experimental but has been stable since pip 21.2.)
output=$(docker compose exec -T web pip index versions imdbinfo 2>/dev/null)
installed=$(echo "$output" | awk '/INSTALLED:/ {print $2}')
latest=$(echo "$output" | awk '/LATEST:/ {print $2}')

if [ -z "$installed" ] || [ -z "$latest" ]; then
    echo "$(date -Is): could not parse pip output (installed='$installed' latest='$latest')" >&2
    exit 1
fi

if [ "$installed" != "$latest" ]; then
    echo "$(date -Is): imdbinfo $installed -> $latest, restarting web"
    docker compose restart web
fi
