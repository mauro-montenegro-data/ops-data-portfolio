-- sql/schema.sql
DROP TABLE IF EXISTS alerts;
DROP TABLE IF EXISTS movements;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
  product_id     SERIAL PRIMARY KEY,
  product_code   TEXT UNIQUE,
  product_name   TEXT NOT NULL,
  category       TEXT,
  reorder_level  INT CHECK (reorder_level >= 0)
);

CREATE TABLE movements (
  movement_id    SERIAL PRIMARY KEY,
  product_id     INT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
  movement_type  TEXT NOT NULL CHECK (movement_type IN ('IN','OUT')),
  quantity       INT  NOT NULL CHECK (quantity > 0),
  moved_at       TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Log de alertas enviadas (evita spam + trazabilidad)
CREATE TABLE alerts (
  alert_id             BIGSERIAL PRIMARY KEY,
  product_id           INT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
  alert_type           TEXT NOT NULL, -- 'SHORTAGE'
  current_stock        INT NOT NULL,
  reorder_level        INT NOT NULL,
  shortage             INT NOT NULL,
  sent_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  sent_day             DATE NOT NULL DEFAULT CURRENT_DATE,
  workflow_run_id       TEXT NULL,
  telegram_message_id  BIGINT NULL,
  telegram_chat_id     BIGINT NULL
);

-- 1 alerta por producto por día (por tipo)
CREATE UNIQUE INDEX IF NOT EXISTS uq_alerts_product_day
ON alerts (product_id, alert_type, sent_day);
