# Trading & Portfolio Endpoints

Resolve credentials, build auth headers, and sign requests per [authentication.md](../_shared/authentication.md).

> ⚠️ `QUERY_PARAMS` are NOT included in the signing input. Only `TIMESTAMP`, `METHOD`, and `REQUEST_PATH` are signed.

## Config Keys Required

Resolve from `~/.finhay/config.json`:

```json
{
  "SUB_ACCOUNT_ID": "0001234567",
  "USER_ID": 123456
}
```

Rules:
- `SUB_ACCOUNT_ID` required for all `/trading/accounts/` and `/trading/sub-accounts/` paths
- `USER_ID` required only for `/trading/pnl-today/{userId}`
- do not ask for these values if already in config

## Common Errors

- Missing `FINHAY_API_KEY`
- Wrong endpoint path or missing `/trading` prefix
- Missing `SUB_ACCOUNT_ID` for a path that requires it
- Missing `USER_ID` for `/trading/pnl-today/{userId}`
- Missing `fromDate` or `toDate` for orders endpoint
- Signature computed from different method or path
- `error_code: "400"` for invalid request validation

Standard error codes: `400` = invalid request, `401` = auth failure, `429` = rate limited.

## Path Versioning

API trading has multiple version paths due to development history:
- No version (`/trading/accounts/...`, `/trading/sub-accounts/...`): original API
- v1 (`/trading/v1/accounts/...`): order book API
- v2 (`/trading/v2/sub-accounts/...`): improved portfolio API
- v5 (`/trading/v5/account/...`): latest user rights API

Always use the exact version path as documented. Do not change version numbers.

## Response Keys

- `result` — account-summary, orders, order-book (list), user-rights, market-session
- `data` — asset-summary, order-book (detail), portfolio, pnl-today

---

## Account

| # | Method | Path | Config | Required params | Res key | Detail |
|---|--------|------|--------|----------------|---------|--------|
| 1 | GET | `/trading/accounts/{subAccountId}/summary` | `SUB_ACCOUNT_ID` | — | `result` | [detail](./endpoints/account-summary.md) |
| 2 | GET | `/trading/sub-accounts/{subAccountId}/asset-summary` | `SUB_ACCOUNT_ID` | — | `data` | [detail](./endpoints/asset-summary.md) |

## Orders

| # | Method | Path | Config | Required params | Res key | Detail |
|---|--------|------|--------|----------------|---------|--------|
| 3 | GET | `/trading/sub-accounts/{subAccountId}/orders` | `SUB_ACCOUNT_ID` | `fromDate`, `toDate` | `result` | [detail](./endpoints/orders.md) |
| 4 | GET | `/trading/v1/accounts/{subAccountId}/order-book` | `SUB_ACCOUNT_ID` | — | `result` | [detail](./endpoints/order-book.md) |
| 5 | GET | `/trading/v1/accounts/{subAccountId}/order-book/{orderId}` | `SUB_ACCOUNT_ID` | `orderId` (path) | `data` | [detail](./endpoints/order-book-detail.md) |

## Portfolio

| # | Method | Path | Config | Required params | Res key | Detail |
|---|--------|------|--------|----------------|---------|--------|
| 6 | GET | `/trading/v2/sub-accounts/{subAccountId}/portfolio` | `SUB_ACCOUNT_ID` | — | `data` | [detail](./endpoints/portfolio.md) |

## PnL

| # | Method | Path | Config | Required params | Res key | Detail |
|---|--------|------|--------|----------------|---------|--------|
| 7 | GET | `/trading/pnl-today/{userId}` | `USER_ID` | — | `data` | [detail](./endpoints/pnl-today.md) |

## User Rights

| # | Method | Path | Config | Required params | Res key | Detail |
|---|--------|------|--------|----------------|---------|--------|
| 8 | GET | `/trading/v5/account/{subAccountId}/user-rights` | `SUB_ACCOUNT_ID` | — | `result` | [detail](./endpoints/user-rights.md) |

## Market Session

| # | Method | Path | Config | Required params | Res key | Detail |
|---|--------|------|--------|----------------|---------|--------|
| 9 | GET | `/trading/market/session` | — | `exchange`* | `result` | [detail](./endpoints/market-session.md) |

---

## How to Use

1. Find the endpoint in the table above
2. Check the Config column — resolve value from `~/.finhay/config.json`
3. Check Required params — ensure all are present
4. Use Res key to parse response
5. Click Detail link for full params and response example
6. Auth headers and signing: see [authentication.md](../_shared/authentication.md)
