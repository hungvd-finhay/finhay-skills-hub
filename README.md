# finhay-skills-hub

Agent skills for the [Finhay Securities](https://finhay.com.vn) Open API. Works with Claude Code, Cursor, and other AI coding assistants.

## Skills

| Skill | Description |
|-------|-------------|
| `finhay-market` | Stock prices, funds, gold, silver, crypto, macro indicators, price charts |
| `finhay-trading` | Account balance, portfolio, orders, PnL, market session |

## Install

### Claude Code plugin

```bash
claude plugin add finhay/finhay-skills-hub
```

### npx (skills.sh)

```bash
npx skills add finhay/finhay-skills-hub --skill finhay-market
npx skills add finhay/finhay-skills-hub --skill finhay-trading
```

## Setup

Create `~/.finhay/credentials/.env`:

```bash
mkdir -p ~/.finhay/credentials
cp credentials.example ~/.finhay/credentials/.env
```

Edit with your credentials:

```bash
FINHAY_API_KEY=ak_test_your_api_key
FINHAY_API_SECRET=your_64_char_hex_secret
FINHAY_BASE_URL=https://open-api.fhsc.com.vn
SUB_ACCOUNT_ID=0001234567
USER_ID=123456
```

| Variable | Required | Description |
|----------|----------|-------------|
| `FINHAY_API_KEY` | Yes | API key (`ak_test_*` or `ak_live_*`) |
| `FINHAY_API_SECRET` | Yes | 64-character hex secret |
| `FINHAY_BASE_URL` | No | Defaults to `https://open-api.fhsc.com.vn` |
| `SUB_ACCOUNT_ID` | No | Needed for trading endpoints |
| `USER_ID` | No | Needed for PnL endpoint |

## Prerequisites

- `node` >= 18 (for request signing and execution)

## License

MIT
