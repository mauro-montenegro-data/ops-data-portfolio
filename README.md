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
- Outputs simples (CSV/Sheets), sin dashboards pesados

## Estructura del repo
- `sql/` → queries y scripts SQL
- `n8n/` → exports de workflows
- `data/` → datos de ejemplo (si aplica)
- `outputs/` → resultados exportados (CSV/capturas)
- `docs/` → documentación corta (setup, notas)

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

> Nota: Primero lo hacemos con dataset de ejemplo. Luego lo adaptamos a tus tablas reales (ENTRADAS/SALIDAS/PRODUCTOS).
