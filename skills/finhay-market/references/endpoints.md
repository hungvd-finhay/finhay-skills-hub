# Market Endpoints

Resolve credentials, build auth headers, and sign requests per [authentication.md](../_shared/authentication.md).

**All market endpoints are `GET`, read-only. None require `SUB_ACCOUNT_ID` or `USER_ID`.**

> ⚠️ `QUERY_PARAMS` are NOT included in the signing input. Only `TIMESTAMP`, `METHOD`, and `REQUEST_PATH` are signed.

## Response Keys

- `result` — only `/market/stock-realtime`
- `data` — all other endpoints

## Enums

See the endpoint detail files for enum values used in each response.

## Common Errors

- Missing `FINHAY_API_KEY`
- More than one of `symbol`, `symbols`, `exchange` for `/market/stock-realtime`
- Signature computed from wrong method or path
- `error_code: "400"` for invalid request validation

Standard error codes: `400` = invalid request, `401` = auth failure, `429` = rate limited.

---

## Stock

| # | Path | Query params | Res key | Note | Detail |
|---|------|-------------|---------|------|--------|
| 1 | `/market/stock-realtime` | 1-of: `symbol`, `symbols`, `exchange` | `result` | `result` = object for `symbol`, array for `symbols`/`exchange` | [detail](./endpoints/stock-realtime.md) |

## Funds

| # | Path | Path params | Query params | Res key | Detail |
|---|------|-------------|-------------|---------|--------|
| 2 | `/market/funds` | — | — | `data` | [detail](./endpoints/funds.md) |
| 3 | `/market/funds/:fund/portfolio` | `fund`* | `month` | `data` | [detail](./endpoints/fund-portfolio.md) |
| 4 | `/market/funds/:fund/months` | `fund`* | — | `data` | [detail](./endpoints/fund-months.md) |

## Financial Data — Summary

| # | Path | Query params | Res key | Note | Detail |
|---|------|-------------|---------|------|--------|
| 5 | `/market/financial-data` | — | `data` | All types: gold, silver, crypto, bank rates | [detail](./endpoints/financial-data.md) |

## Financial Data — Precious Metals

| # | Path | Query params | Res key | Note | Detail |
|---|------|-------------|---------|------|--------|
| 6 | `/market/financial-data/gold` | — | `data` | SJC gold + global price | [detail](./endpoints/gold.md) |
| 7 | `/market/financial-data/silver` | — | `data` | Same shape as gold | [detail](./endpoints/silver.md) |
| 8 | `/market/financial-data/gold-chart` | `days` (default 30) | `data` | Gold price chart | [detail](./endpoints/gold-chart.md) |
| 9 | `/market/financial-data/silver-chart` | `days` (default 30) | `data` | Silver price chart | [detail](./endpoints/silver-chart.md) |
| 10 | `/market/financial-data/gold-providers` | — | `data` | Gold by provider: PNJ, DOJI, BTMC, SJC | [detail](./endpoints/gold-providers.md) |
| 11 | `/market/financial-data/metal-providers` | — | `data` | Gold + silver by provider | [detail](./endpoints/metal-providers.md) |

## Financial Data — Other

| # | Path | Query params | Res key | Note | Detail |
|---|------|-------------|---------|------|--------|
| 12 | `/market/financial-data/bank-interest-rates` | — | `data` | May return `{}` if not yet cached | [detail](./endpoints/bank-interest-rates.md) |
| 13 | `/market/financial-data/cryptos/top-trending` | — | `data` | Top trending cryptocurrencies | [detail](./endpoints/cryptos-top-trending.md) |
| 14 | `/market/financial-data/macro` | `type`*, `country`*, `period` | `data` | Macro data VN/US | [detail](./endpoints/macro.md) |

## Reports

| # | Path | Path params | Res key | Note | Detail |
|---|------|-------------|---------|------|--------|
| 15 | `/market/recommendation-reports/:symbol` | `symbol`* | `data` | Returns `[]` if no reports | [detail](./endpoints/recommendation-reports.md) |

## Price History

| # | Path | Query params | Res key | Note | Detail |
|---|------|-------------|---------|------|--------|
| 16 | `/market/price-histories-chart` | `symbol`*, `resolution`* (only `1D`), `from`*, `to`* (seconds) | `data` | Columnar arrays; `from`/`to` in **seconds** not ms | [detail](./endpoints/price-histories-chart.md) |

---

## Choosing the Right Financial Data Endpoint

| Need | Use endpoint |
|------|-------------|
| Everything (gold + silver + crypto + bank rates) | `/market/financial-data` |
| Only gold price (SJC + global) | `/market/financial-data/gold` |
| Gold price by provider (PNJ, DOJI, BTMC...) | `/market/financial-data/gold-providers` |
| Gold price chart (N days) | `/market/financial-data/gold-chart?days=N` |
| Silver equivalents | replace `gold` → `silver` |
| Macro data (CPI, PMI, interest rates...) | `/market/financial-data/macro` |
| Bank deposit rates | `/market/financial-data/bank-interest-rates` |
| Top crypto trending | `/market/financial-data/cryptos/top-trending` |
