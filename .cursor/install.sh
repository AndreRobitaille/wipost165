#!/usr/bin/env bash
# Idempotent repository bootstrap for Cursor cloud agents.
# Ruby and system packages come from .cursor/Dockerfile. This script only
# refreshes gems after the selected revision is checked out.
set -euo pipefail

cd "$(dirname "$0")/.."

expected="$(tr -d '[:space:]' < .ruby-version)"
expected="${expected#ruby-}"
actual="$(ruby -e 'print RUBY_VERSION')"
if [[ "$actual" != "$expected" ]]; then
  printf 'Ruby %s is required by .ruby-version; found %s.\n' "$expected" "$actual" >&2
  exit 1
fi

bundler_version="$(awk '/^BUNDLED WITH/{getline; gsub(/[[:space:]]/, "", $0); print; exit}' Gemfile.lock)"
if [[ -z "$bundler_version" ]]; then
  echo "Gemfile.lock is missing a BUNDLED WITH version." >&2
  exit 1
fi

export BUNDLER_VERSION="$bundler_version"
# Bundler 4 prints only the version number, for example "4.0.16".
if [[ "$(bundle --version)" != "$bundler_version" ]]; then
  gem install bundler -v "$bundler_version" --no-document
fi

# Same dependency step as `bin/setup --skip-server`: check, then install.
# Frozen install refuses to rewrite Gemfile.lock. Bundler 4 otherwise adds
# its own checksum and leaves the checkout dirty.
bundle check || BUNDLE_FROZEN=1 bundle install
