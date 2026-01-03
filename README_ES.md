# Alerta de Stock del Depósito — PostgreSQL + n8n + Telegram

Proyecto chico de **control operativo**: calcula stock actual en PostgreSQL y envía **alertas reales por Telegram** cuando un ítem cae por debajo del mínimo (reorder level). Armado como ejemplo “portfolio-ready” para roles de **Operations Analyst (Data & Automation)**.

## Qué hace
- Crea un modelo mínimo de inventario en PostgreSQL (`products`, `movements`).
- Calcula stock actual con una vista: `vw_stock_current`.
- Detecta faltantes cuando `current_stock < reorder_level`.
- Ejecuta un workflow en n8n que consulta faltantes y envía un mensaje por Telegram con:
  `product_code, product_name, current_stock, reorder_level, shortage (falta)`.

## Evidencias (proof)
- `outputs/day1_kpi_faltantes.txt` — resultado del KPI SQL (faltantes)
- `outputs/day2_workflow.png` — captura del workflow n8n
- `outputs/day2_telegram.png` — captura del mensaje real en Telegram

## Stack
- PostgreSQL 16
- SQL
- n8n (Docker)
- Telegram Bot API
- Git + GitHub

## Estructura del repo
- `sql/`
  - `schema.sql` — tablas
  - `sample_data.sql` — datos de ejemplo (fake)
  - `views.sql` — vista `vw_stock_current`
  - `kpis.sql` — query KPI de faltantes
- `n8n/`
  - `alerta_stock_n8n.json` — export del workflow n8n
- `outputs/` — evidencias (txt/png)
- `docs/` — notas cortas (opcional)

## Quickstart (local)

### 1) PostgreSQL
Creá una base (ej: `ops_portfolio`) y corré los scripts en este orden:

1. `sql/schema.sql`
2. `sql/sample_data.sql`
3. `sql/views.sql`
4. `sql/kpis.sql`

Chequeo rápido:
```sql
SELECT * FROM vw_stock_current ORDER BY product_id;
```
### 2) Workflow n8n (alerta a Telegram)

1. Levantá n8n (Docker).
2. Importá el workflow desde: `n8n/alerta_stock_n8n.json`.
3. Creá credenciales en n8n:
   - **Postgres:** host / port / db / user / password
   - **Telegram:** bot token + chat_id
4. Ejecutá el workflow manualmente (o programalo) y confirmá que llega el mensaje.

> No se guardan secretos en este repo. Usá credenciales de n8n y/o `.env` local.

## Cómo funciona (alto nivel)
- `vw_stock_current` agrega movimientos (IN/OUT) para calcular stock actual.
- El KPI en `sql/kpis.sql` filtra los productos con stock por debajo del mínimo y calcula la **falta**.
- n8n trae esas filas y arma el texto para enviarlo por Telegram.

## Próximas mejoras (roadmap)
- Agregar trigger programado (ej: lunes 08:00).
- Crear tabla `alerts` para registrar alertas enviadas (trazabilidad).
- Agregar KPI #2: top rotación mensual (por salidas).
- Agregar KPI #3: consumo mensual por categoría.

## Nota
Este repo está armado con datos fake para demostrar el patrón **vista → KPI → alerta**.  
Luego se puede adaptar a tablas reales (ENTRADAS/SALIDAS/PRODUCTOS) manteniendo la misma lógica.

