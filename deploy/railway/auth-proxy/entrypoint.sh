#!/bin/sh
# Hash the plaintext password from Railway variables at startup so only the
# bcrypt hash is handed to Caddy.
set -eu
: "${BASIC_AUTH_USER:?Set BASIC_AUTH_USER in Railway variables}"
: "${BASIC_AUTH_PASSWORD:?Set BASIC_AUTH_PASSWORD in Railway variables}"
: "${UPSTREAM:?Set UPSTREAM, e.g. openseo.railway.internal:3001}"
BASIC_AUTH_HASH="$(caddy hash-password --plaintext "$BASIC_AUTH_PASSWORD")"
export BASIC_AUTH_HASH
unset BASIC_AUTH_PASSWORD
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
