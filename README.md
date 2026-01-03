# Depot Stock Alert — PostgreSQL + n8n + Telegram

A small “operations control” project: compute current stock in PostgreSQL and send **real Telegram alerts** when items fall below a reorder level. Built as a portfolio-ready example for **Operations Analyst (Data & Automation)** roles.

## What this does
- Builds a minimal inventory model (`products`, `movements`) in PostgreSQL.
- Computes current stock via a view: `vw_stock_current`.
- Detects shortages when `current_stock < reorder_level`.
- Runs an n8n workflow that queries shortages and sends a Telegram message listing:
  `product_code, product_name, current_stock, reorder_level, shortage`.

## Proof (evidence)
- `outputs/kpi_faltantes.txt` — SQL KPI result (shortages)
- `outputs/workflow.png` — n8n workflow screenshot
- `outputs/telegram.png` — real Telegram message screenshot

## Tech stack
- PostgreSQL 16
- SQL
- n8n (Docker)
- Telegram Bot API
- Git + GitHub

## Repo structure
- `sql/`
  - `schema.sql` — tables
  - `sample_data.sql` — demo data (fake)
  - `views.sql` — `vw_stock_current`
  - `kpis.sql` — shortage KPI query
- `n8n/`
  - `alerta_stock_n8n.json` — exported n8n workflow
- `outputs/` — evidence (txt/png)
- `docs/` — short notes (optional)

## Quickstart (local)
### 1) PostgreSQL
Create a database (example: `ops_portfolio`) and run the scripts in this order:

1. `sql/schema.sql`
2. `sql/sample_data.sql`
3. `sql/views.sql`
4. `sql/kpis.sql`

Quick check:
```sql
SELECT * FROM vw_stock_current ORDER BY product_id;
```

### 2) n8n workflow (Telegram alert)

1. Start n8n (Docker).
2. Import the workflow from: ``n8n/alerta_stock_n8n.json``.
3. Create credentials in n8n:
   - **Postgres:** host / port / db / user / password
   - **Telegram:** bot token + chat_id
4. Run the workflow manually (or schedule it) and confirm the message arrives.

> No secrets are stored in this repository. Use n8n credentials and/or local `.env` files.


## How it works (high level)
- `vw_stock_current` aggregates movements (IN/OUT) to compute current stock.
- The KPI query in `sql/kpis.sql` filters where stock is below reorder level and calculates the shortage.
- n8n pulls those rows and formats a message to Telegram.

## Roadmap (small improvements)
- Add a scheduled trigger (e.g., Mondays 08:00).
- Add an `alerts` table to log sent alerts (traceability).
- Add KPI #2 (top monthly rotation) and KPI #3 (monthly consumption by category).

