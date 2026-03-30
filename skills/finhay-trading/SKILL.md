---
name: finhay-trading
description: "Account balances, portfolio, orders, and profit/loss. Use when user asks about their trading account, stock holdings, order history, or today's PnL."
license: MIT
metadata:
  author: Finhay Securities
  version: "1.0.0"
  homepage: "https://finhay.com.vn"
---

# Finhay Trading

Read-only personal trading data from the Finhay Securities Open API. All requests are `GET` and require HMAC-SHA256 signed headers.

## Pre-flight (run before ANY API call)

Check credentials exist before doing anything else:

```bash
cat ~/.finhay/credentials/.env 2>/dev/null || echo "FILE_NOT_FOUND"
```

If the file is missing or lacks required keys, **stop** — do not call the API. Required keys: `FINHAY_API_KEY`, `FINHAY_API_SECRET`, `SUB_ACCOUNT_ID` (most endpoints), `USER_ID` (PnL endpoint). Show the user this setup command:

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

Tell them to replace placeholders with real values from Finhay Securities. Do not fabricate credentials. Only proceed after credentials are confirmed.

## Making a Request

Use [request.sh](./_shared/scripts/request.sh) for every API call — it loads credentials, signs with HMAC-SHA256, sends the request, and checks errors. Substitute `{subAccountId}` and `{userId}` with real values from the `.env` before calling — the signed path must be the final resolved path.

```bash
# Usage: ./_shared/scripts/request.sh METHOD PATH [QUERY_PARAMS]

# Read SUB_ACCOUNT_ID and USER_ID from credentials
SUB_ACCOUNT_ID=$(grep '^SUB_ACCOUNT_ID=' ~/.finhay/credentials/.env | cut -d= -f2)
USER_ID=$(grep '^USER_ID=' ~/.finhay/credentials/.env | cut -d= -f2)

# Account summary
./_shared/scripts/request.sh GET "/trading/accounts/$SUB_ACCOUNT_ID/summary"

# Order history (fromDate and toDate are required)
./_shared/scripts/request.sh GET "/trading/sub-accounts/$SUB_ACCOUNT_ID/orders" "fromDate=2024-01-01&toDate=2024-01-31"

# Portfolio
./_shared/scripts/request.sh GET "/trading/v2/sub-accounts/$SUB_ACCOUNT_ID/portfolio"

# PnL today
./_shared/scripts/request.sh GET "/trading/pnl-today/$USER_ID"

# Market session
./_shared/scripts/request.sh GET /trading/market/session "exchange=HOSE"
```

Exits non-zero on error. For signing internals, see [authentication.md](./_shared/authentication.md).

## Available Endpoints

| Endpoint | Config needed | Key params | Response key |
|----------|---------------|------------|--------------|
| `/trading/accounts/{subAccountId}/summary` | `SUB_ACCOUNT_ID` | — | `result` |
| `/trading/sub-accounts/{subAccountId}/asset-summary` | `SUB_ACCOUNT_ID` | — | `data` |
| `/trading/sub-accounts/{subAccountId}/orders` | `SUB_ACCOUNT_ID` | `fromDate`, `toDate` (required) | `result` |
| `/trading/v1/accounts/{subAccountId}/order-book` | `SUB_ACCOUNT_ID` | — | `result` |
| `/trading/v1/accounts/{subAccountId}/order-book/{orderId}` | `SUB_ACCOUNT_ID` | `orderId` (path) | `data` |
| `/trading/v2/sub-accounts/{subAccountId}/portfolio` | `SUB_ACCOUNT_ID` | — | `data` |
| `/trading/pnl-today/{userId}` | `USER_ID` | — | `data` |
| `/trading/v5/account/{subAccountId}/user-rights` | `SUB_ACCOUNT_ID` | — | `result` |
| `/trading/market/session` | — | `exchange` (required) | `result` |

Path versions (`v1`, `v2`, `v5`) exist for historical reasons. Always use the exact version as documented above.

Full details, response shapes, and examples: [references/endpoints.md](./references/endpoints.md). Enum values (order status, side, type): [references/enums.md](./references/enums.md).

## Constraints

See [shared constraints](./_shared/constraints.md), plus:

- **Orders endpoint** — `fromDate` and `toDate` are always required. Stop if either is missing.
- **Path params** — substitute `{subAccountId}` and `{userId}` from config before signing. The signed path must be the final resolved path.
