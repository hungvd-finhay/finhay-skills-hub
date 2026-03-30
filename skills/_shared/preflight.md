# Pre-flight Checks

Before making any API call, verify these prerequisites:

## 1. Node.js

```bash
node --version  # Must be >= 18
```

If not installed, stop and tell the user to install Node.js.

## 2. Credentials

Check environment variables or `~/.finhay/credentials/.env`:

```bash
cat ~/.finhay/credentials/.env
```

Must contain at least:
- `FINHAY_API_KEY` — format: `ak_test_*` or `ak_live_*`
- `FINHAY_API_SECRET` — 64-character hex string

If missing, stop and tell the user:

```bash
mkdir -p ~/.finhay/credentials
cat > ~/.finhay/credentials/.env << 'EOF'
FINHAY_API_KEY=ak_test_YOUR_API_KEY_HERE
FINHAY_API_SECRET=YOUR_64_CHAR_HEX_SECRET_HERE
FINHAY_BASE_URL=https://open-api.fhsc.com.vn
SUB_ACCOUNT_ID=0001234567
USER_ID=123456
EOF
chmod 600 ~/.finhay/credentials/.env
```

## 3. Request script

The shared request script handles authentication automatically:

```bash
# From any skill directory:
../_shared/scripts/request.sh METHOD PATH [QUERY_PARAMS]
```

Never construct API calls manually — always use this script.
