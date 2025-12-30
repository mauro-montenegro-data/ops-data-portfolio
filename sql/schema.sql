-- sql/schema.sql
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
