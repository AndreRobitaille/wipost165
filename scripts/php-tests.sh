#!/usr/bin/env sh
# Runs the pure-logic PHP tests. Uses a local php if present, otherwise Docker.
set -e
DIR="$(cd "$(dirname "$0")/.." && pwd)"

if command -v php >/dev/null 2>&1; then
  exec php "$DIR/scripts/php-tests.php"
elif command -v docker >/dev/null 2>&1; then
  exec docker run --rm -v "$DIR":/app -w /app php:8.3-cli php scripts/php-tests.php
else
  echo "Neither php nor docker is available. Install PHP 8.1+ or Docker to run these tests." >&2
  exit 1
fi
