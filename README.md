# Control de Stock + Alertas — PostgreSQL, n8n y Telegram

Caso pequeño de **Operations + Data + Automation**: calcula stock actual en PostgreSQL, detecta productos por debajo del punto de reposición y envía una alerta automática por Telegram mediante n8n.

El proyecto está pensado como una demostración simple y revisable del recorrido completo **dato → regla → acción**.

---

## Problema

Tener movimientos de stock registrados no alcanza si alguien debe revisar manualmente qué productos necesitan reposición.

La necesidad es convertir esos movimientos en una señal operativa:

```text
movimientos
    ↓
stock actual
    ↓
comparación con reorder_level
    ↓
faltantes
    ↓
alerta
```

---

## Qué hace

- Modela `products` y `movements` en PostgreSQL.
- Calcula stock actual mediante la vista `vw_stock_current`.
- Detecta faltantes cuando `current_stock < reorder_level`.
- Calcula la cantidad faltante para alcanzar el nivel de reposición.
- n8n consulta el resultado y arma un mensaje.
- Telegram recibe una alerta con código, producto, stock actual, nivel objetivo y faltante.

---

## Evidencia incluida

El repositorio contiene material para comprobar el flujo sin depender sólo de la descripción:

- `outputs/kpi_faltantes.txt` — resultado del KPI en SQL;
- `outputs/workflow.png` — captura del workflow de n8n;
- `outputs/telegram.png` — captura del mensaje recibido en Telegram.

---

## Stack

- PostgreSQL 16
- SQL
- n8n
- Docker
- Telegram Bot API

---

## Estructura

```text
sql/
  schema.sql          # tablas
  sample_data.sql     # datos de demo
  views.sql           # vw_stock_current
  kpis.sql            # consulta de faltantes

n8n/
  alert_stock_n8n.json

outputs/
  kpi_faltantes.txt
  workflow.png
  telegram.png
```

---

## Lógica principal

La vista agrega movimientos de entrada y salida para obtener el stock actual. La consulta de KPI filtra los productos debajo del nivel de reposición y calcula la diferencia.

Conceptualmente:

```sql
current_stock < reorder_level
```

produce una fila de alerta con:

```text
product_code
product_name
current_stock
reorder_level
shortage
```

n8n transforma esas filas en un mensaje legible y lo envía por Telegram.

---

## Cómo ejecutarlo

1. Crear una base PostgreSQL.
2. Ejecutar, en orden:
   - `sql/schema.sql`
   - `sql/sample_data.sql`
   - `sql/views.sql`
   - `sql/kpis.sql`
3. Importar `n8n/alert_stock_n8n.json` en n8n.
4. Configurar credenciales de PostgreSQL y Telegram dentro de n8n.
5. Ejecutar el workflow y verificar la alerta.

No se almacenan secretos en el repositorio.

---

## Qué demuestra este proyecto

- SQL aplicado a una necesidad operativa concreta.
- Separación entre datos de movimientos y KPI derivado.
- Automatización a partir de una condición de negocio.
- Integración PostgreSQL → n8n → Telegram.
- Evidencia visible del resultado final.

---

## Alcance

Es un caso deliberadamente pequeño. No pretende reemplazar un sistema completo de inventario ni modela todavía historial de alertas, deduplicación, acknowledgement o políticas avanzadas de reposición.

Esas extensiones quedan fuera del objetivo principal: mostrar de forma simple cómo un dato operativo puede transformarse en una acción automática.
