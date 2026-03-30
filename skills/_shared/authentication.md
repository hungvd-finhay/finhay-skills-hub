# Finhay Authentication

All requests require HMAC-SHA256 signed headers. The shared [request.sh](./scripts/request.sh) script handles signing automatically — use it for all API calls.

This document is a reference for the signing protocol internals.

## Config

Source: environment variables or `~/.finhay/credentials/.env`

```bash
FINHAY_API_KEY=ak_test_...
FINHAY_API_SECRET=64_char_hex_secret
FINHAY_BASE_URL=https://open-api.fhsc.com.vn
SUB_ACCOUNT_ID=0001234567
USER_ID=123456
```

| Variable | Required | Description |
|----------|----------|-------------|
| `FINHAY_API_KEY` | Yes | Maps to `X-FH-APIKEY` header |
| `FINHAY_API_SECRET` | Yes | Used to compute `X-FH-SIGNATURE` |
| `FINHAY_BASE_URL` | No | Defaults to `https://open-api.fhsc.com.vn` |
| `SUB_ACCOUNT_ID` | No | For trading endpoints that need it in the path |
| `USER_ID` | No | For the PnL endpoint |

## Headers

Every request must include:

| Header | Value |
|--------|-------|
| `X-FH-APIKEY` | API key from config |
| `X-FH-TIMESTAMP` | `Date.now()` (milliseconds) |
| `X-FH-NONCE` | 16 random bytes, hex-encoded |
| `X-FH-SIGNATURE` | HMAC-SHA256 of signing input, hex-encoded |

## Signing

Algorithm: `HMAC-SHA256` with `FINHAY_API_SECRET` as key.

Signing input — 3 lines, each terminated with `\n` (including the last):

```
{TIMESTAMP}\n{METHOD}\n{REQUEST_PATH}\n
```

**QUERY_PARAMS are NOT included in the signing input.** Only `TIMESTAMP`, `METHOD`, and `REQUEST_PATH` are signed.

## Rate Limits

Per API key, sliding 60-second window:

| Tier | Limit (weight/60s) |
|------|--------------------|
| FREE | 600 |
| BASIC | 1200 |
| PRO | 3000 |
| ENTERPRISE | 10000 |

Each request costs weight = 1. On HTTP 429, wait until `X-RateLimit-Reset` before retrying.
