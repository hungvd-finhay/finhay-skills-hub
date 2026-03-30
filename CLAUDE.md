# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Overview

This is a **Claude Code plugin** — a collection of agent skills for the Finhay Securities Open API. The project provides skills for querying Vietnamese stock market data (real-time prices, funds, commodities, macro indicators, price charts) and personal brokerage account data (balances, portfolio, orders, PnL). All API calls use HMAC-SHA256 signed headers via a shared request script.

## Architecture

- **skills/** — 2 skill definitions (each is a `SKILL.md` with YAML frontmatter + endpoint reference)
- **skills/_shared/** — Shared references (authentication, constraints, request script)
- **.claude-plugin/** — Plugin metadata for Claude Code marketplace
- **credentials.example** — Example `.env` template for `~/.finhay/credentials/.env`

## Available Skills

| Skill | Purpose | When to Use |
|-------|---------|-------------|
| finhay-market | Stock prices, funds, gold, silver, crypto, macro indicators, bank rates, price charts, recommendation reports | User asks about stock prices, gold prices, fund performance, interest rates, macro data, or wants to chart a symbol's price history |
| finhay-trading | Account balance, asset summary, portfolio, orders, order book, PnL today, user rights, market session | User asks about their trading account, stock holdings, order history, today's gains, or market session status |

## Prerequisites

- `node` >= 18 (for request signing and execution)
- `~/.finhay/credentials/.env` with `FINHAY_API_KEY` and `FINHAY_API_SECRET`

## Making API Requests

All skills use `skills/_shared/scripts/request.sh` — a Node.js script that handles credential loading, HMAC-SHA256 signing, request execution, and error checking. Never construct API calls manually; always use this script.

```bash
# Usage: skills/_shared/scripts/request.sh METHOD PATH [QUERY_PARAMS]
skills/_shared/scripts/request.sh GET /market/stock-realtime "symbol=VNM"
```
