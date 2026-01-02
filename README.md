# Ops Data Portfolio

## North Star
Construir un sistema de control operativo automatizado (PostgreSQL + SQL + n8n) que genere **alertas reales de stock** y sirva como portfolio para roles remotos de Operations Analyst (Data & Automation).

## Stack
- PostgreSQL
- SQL
- n8n
- Google Sheets
- GitHub

## Qué vas a encontrar acá
- Queries SQL reutilizables para stock, consumos y faltantes
- Workflows de n8n (alertas, automatización)
- Outputs simples (TXT/PNG/CSV/Sheets), sin dashboards pesados

## Estado actual (progreso)
✅ Hecho:
- KPI de faltantes funcionando con datos fake (`sql/kpis.sql`)
- Vista de stock actual (`sql/views.sql` → `vw_stock_current`)
- Workflow n8n exportado que consulta Postgres y envía alerta a Telegram (`n8n/alerta_stock_n8n.json`)

📌 Evidencias:
- `outputs/day1_kpi_faltantes.txt` (resultado KPI)
- `outputs/day2_workflow.png` (captura del flujo n8n)
- (pendiente) `outputs/day2_telegram.png` (captura del mensaje real)

## Estructura del repo
- `sql/` → queries y scripts SQL
- `n8n/` → exports de workflows
- `data/` → datos de ejemplo (si aplica)
- `outputs/` → resultados exportados (txt/capturas/csv)
- `docs/` → documentación corta (setup, supuestos, notas)

## Entregable Semana 1
- `sql/schema.sql`
- `sql/sample_data.sql`
- `sql/views.sql`
- `sql/kpis.sql`

## Cómo ejecutar (local)
1) Abrí pgAdmin o psql
2) Corré los scripts en este orden:
   - `sql/schema.sql`
   - `sql/sample_data.sql`
   - `sql/views.sql`
   - `sql/kpis.sql`
3) (Opcional) Importá el workflow en n8n desde `n8n/alerta_stock_n8n.json`

> Nota: Primero lo hacemos con dataset de ejemplo. Luego lo adaptamos a tus tablas reales (ENTRADAS/SALIDAS/PRODUCTOS).
