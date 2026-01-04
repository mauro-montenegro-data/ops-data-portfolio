# Decisions (why this is built this way)

## Goal
Send **real stock shortage alerts** to Telegram with a minimal, portfolio-ready setup (PostgreSQL + SQL + n8n), without dashboards.

## Key decisions

1) **View-first design (`vw_stock_current`)**
- Stock is computed in SQL (single source of truth).
- n8n only consumes results; no business logic duplicated in the workflow.

2) **Daily de-dup to avoid spam**
- We log alerts in `public.alerts` and enforce: **1 alert per product per day** using:
  - `sent_day` (DATE)
  - unique constraint/index on `(product_id, alert_type, sent_day)`

3) **KPI returns only “new shortages”**
- `sql/kpis.sql` filters shortages and excludes items already alerted today via `NOT EXISTS` against `public.alerts`.

4) **One Telegram message, many logged rows**
- Telegram sends **one** message listing all shortages.
- We still log **one row per product** in `alerts` for traceability and reporting.

5) **Traceability fields are intentional**
- `workflow_run_id`: ties rows to a specific n8n execution.
- `telegram_message_id` + `telegram_chat_id`: audit evidence that an alert was actually sent.

6) **Fake data first, then adapt to real tables**
- This repo uses demo tables (`products`, `movements`) to prove the pattern:
  `view → KPI → alert → log`
- Later it can be adapted to real operational tables (e.g., ENTRADAS/SALIDAS/PRODUCTOS) keeping the same pattern.
