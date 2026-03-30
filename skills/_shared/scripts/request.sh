#!/bin/bash
set -euo pipefail

METHOD="${1:-}"
REQUEST_PATH="${2:-}"
QUERY_PARAMS="${3:-}"

if [ -z "$METHOD" ] || [ -z "$REQUEST_PATH" ]; then
  echo 'Usage: request.sh METHOD PATH [QUERY]' >&2
  echo 'Example: request.sh GET /market/stock-realtime "symbol=VNM"' >&2
  exit 1
fi

# Load credentials
CRED="$HOME/.finhay/credentials/.env"
if [ -f "$CRED" ]; then
  PERM=$(stat -f "%Lp" "$CRED" 2>/dev/null || stat -c "%a" "$CRED" 2>/dev/null)
  [ "$PERM" != "600" ] && echo "WARNING: $CRED is accessible by other users. Run: chmod 600 $CRED" >&2
  set -a
  . "$CRED"
  set +a
fi

FINHAY_BASE_URL="${FINHAY_BASE_URL:-https://open-api.fhsc.com.vn}"

if [ -z "${FINHAY_API_KEY:-}" ] || [ -z "${FINHAY_API_SECRET:-}" ]; then
  echo "ERROR: FINHAY_API_KEY and FINHAY_API_SECRET required." >&2
  echo "Set via environment variables or ~/.finhay/credentials/.env" >&2
  exit 1
fi

# Sign request
TIMESTAMP=$(date +%s%3N 2>/dev/null || python3 -c 'import time; print(int(time.time()*1000))')
NONCE=$(openssl rand -hex 16)
SIGNATURE=$(printf '%s\n%s\n%s\n' "$TIMESTAMP" "$METHOD" "$REQUEST_PATH" | openssl dgst -sha256 -hmac "$FINHAY_API_SECRET" -binary | xxd -p | tr -d '\n')

# Build URL
URL="${FINHAY_BASE_URL}${REQUEST_PATH}"
[ -n "$QUERY_PARAMS" ] && URL="${URL}?${QUERY_PARAMS}"

# Execute request
HTTP_RESPONSE=$(curl -s -w "\n%{http_code}" --max-time 30 \
  -X "$METHOD" \
  -H "X-FH-APIKEY: $FINHAY_API_KEY" \
  -H "X-FH-TIMESTAMP: $TIMESTAMP" \
  -H "X-FH-NONCE: $NONCE" \
  -H "X-FH-SIGNATURE: $SIGNATURE" \
  -H "User-Agent: finhay-skill/1.0.0" \
  "$URL")

HTTP_CODE=$(echo "$HTTP_RESPONSE" | tail -1)
BODY=$(echo "$HTTP_RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -ge 400 ]; then
  echo "ERROR: HTTP $HTTP_CODE" >&2
  echo "$BODY" >&2
  exit 1
fi

printf '%s' "$BODY"
