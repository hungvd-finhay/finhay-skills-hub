---
name: finhay-market
description: "Stock prices, funds, gold, silver, crypto, macro indicators, bank rates, and price charts. Use when user asks about stock prices, gold/silver prices, fund performance, interest rates, macro data, or price history charts."
license: MIT
metadata:
  author: Finhay Securities
  version: "1.0.0"
  homepage: "https://finhay.com.vn"
---

# Finhay Market

Read-only market data from the Finhay Securities Open API. All requests are `GET` and require HMAC-SHA256 signed headers.

## Pre-flight (run before ANY API call)

Check credentials exist before doing anything else:

```bash
cat ~/.finhay/credentials/.env 2>/dev/null || echo "FILE_NOT_FOUND"
```

If the file is missing or lacks `FINHAY_API_KEY` / `FINHAY_API_SECRET`, **stop** — do not call the API. Show the user this setup command:

```bash
mkdir -p ~/.finhay/credentials
cat > ~/.finhay/credentials/.env << 'EOF'
FINHAY_API_KEY=ak_test_YOUR_API_KEY_HERE
FINHAY_API_SECRET=YOUR_64_CHAR_HEX_SECRET_HERE
FINHAY_BASE_URL=https://open-api.fhsc.com.vn
EOF
chmod 600 ~/.finhay/credentials/.env
```

Tell them to replace placeholders with real values from Finhay Securities. Do not fabricate credentials. Only proceed after credentials are confirmed.

## Making a Request

Use [request.sh](./_shared/scripts/request.sh) for every API call — it loads credentials, signs with HMAC-SHA256, sends the request, and checks errors.

```bash
# Usage: ./_shared/scripts/request.sh METHOD PATH [QUERY_PARAMS]

# Real-time stock price
./_shared/scripts/request.sh GET /market/stock-realtime "symbol=VNM"

# Multiple stocks
./_shared/scripts/request.sh GET /market/stock-realtime "symbols=VNM,VIC,HPG"

# All stocks on an exchange
./_shared/scripts/request.sh GET /market/stock-realtime "exchange=HOSE"

# Gold prices
./_shared/scripts/request.sh GET /market/financial-data/gold

# Price history chart (from/to in SECONDS)
./_shared/scripts/request.sh GET /market/price-histories-chart "symbol=VNM&resolution=1D&from=1609459200&to=1704067200"

# Macro data
./_shared/scripts/request.sh GET /market/financial-data/macro "type=CPI&country=VN&period=YEARLY"
```

Exits non-zero on error. For signing internals, see [authentication.md](./_shared/authentication.md).

## Available Endpoints

| Category | Endpoint | Key params |
|----------|----------|------------|
| Stock | `/market/stock-realtime` | exactly one of: `symbol`, `symbols`, `exchange` |
| Funds | `/market/funds` | — |
| Fund detail | `/market/funds/:fund/portfolio` | `month` (optional) |
| Gold / Silver | `/market/financial-data/gold`, `silver` | — |
| Charts | `/market/financial-data/gold-chart`, `silver-chart` | `days` (default 30) |
| Providers | `/market/financial-data/gold-providers`, `metal-providers` | — |
| Bank rates | `/market/financial-data/bank-interest-rates` | — |
| Crypto | `/market/financial-data/cryptos/top-trending` | — |
| Macro | `/market/financial-data/macro` | `type`, `country`, `period` |
| Reports | `/market/recommendation-reports/:symbol` | — |
| Price history | `/market/price-histories-chart` | `symbol`, `resolution` (only `1D`), `from`, `to` (seconds) |

Full details, response shapes, and examples: [references/endpoints.md](./references/endpoints.md).

## Constraints

See [shared constraints](./_shared/constraints.md), plus:

- **Stock realtime** — pass exactly one of `symbol`, `symbols`, or `exchange`. Never combine them.
- **Price history** — `from` and `to` are Unix timestamps in **seconds**, not milliseconds. If a value exceeds 9,999,999,999, stop and ask the user to convert. `resolution` must be `1D`. When not provided, default `to` to now and `from` to 5 years ago.
