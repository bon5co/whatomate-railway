#!/bin/sh
# Whatomate on Railway: translate the Railway variables into Whatomate's WHATOMATE_<SECTION>__<KEY> settings, bind to the injected PORT
# and start the stock server with -migrate, which creates the schema and (only while no user exists) the default administrator.
set -eu
cd /app

need() { eval "v=\${$1:-}"; [ -n "$v" ] || { echo "[railway-boot] $1 is required" >&2; exit 1; }; }
for n in JWT_SECRET ENCRYPTION_KEY DB_HOST DB_USER DB_PASS DB_NAME REDIS_HOST REDIS_PASS WHATOMATE_ADMIN_EMAIL WHATOMATE_ADMIN_PASSWORD RAILWAY_PUBLIC_DOMAIN; do need "$n"; done

# Railway's healthcheck and edge dial the injected PORT.
export WHATOMATE_SERVER__PORT="${PORT:-8080}"
export WHATOMATE_APP__ENVIRONMENT=production
export WHATOMATE_SERVER__ALLOWED_ORIGINS="https://$RAILWAY_PUBLIC_DOMAIN"
export WHATOMATE_JWT__SECRET="$JWT_SECRET"
export WHATOMATE_APP__ENCRYPTION_KEY="$ENCRYPTION_KEY"
export WHATOMATE_DATABASE__HOST="$DB_HOST" WHATOMATE_DATABASE__PORT=5432 WHATOMATE_DATABASE__USER="$DB_USER" \
       WHATOMATE_DATABASE__PASSWORD="$DB_PASS" WHATOMATE_DATABASE__NAME="$DB_NAME" WHATOMATE_DATABASE__SSL_MODE=disable
export WHATOMATE_REDIS__HOST="$REDIS_HOST" WHATOMATE_REDIS__PORT=6379 WHATOMATE_REDIS__PASSWORD="$REDIS_PASS"
export WHATOMATE_STORAGE__LOCAL_PATH=/app/uploads
export WHATOMATE_DEFAULT_ADMIN__EMAIL="$WHATOMATE_ADMIN_EMAIL" WHATOMATE_DEFAULT_ADMIN__PASSWORD="$WHATOMATE_ADMIN_PASSWORD" \
       WHATOMATE_DEFAULT_ADMIN__FULL_NAME="${WHATOMATE_ADMIN_NAME:-Admin}"

# the volume is mounted root-owned; the app runs as root, so say what it can write
mkdir -p /app/uploads /app/audio
[ -w /app/uploads ] || { echo "[railway-boot] /app/uploads is not writable (owner $(stat -c %u:%g /app/uploads))" >&2; exit 1; }
echo "[railway-boot] uploads owner=$(stat -c %u:%g /app/uploads), serving https://$RAILWAY_PUBLIC_DOMAIN on $WHATOMATE_SERVER__PORT"

exec "$@"
