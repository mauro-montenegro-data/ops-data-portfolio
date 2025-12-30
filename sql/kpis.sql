-- kpis.sql
-- KPI 1: Faltantes (placeholder)
-- Próximo paso: adaptar a ENTRADAS/SALIDAS/PRODUCTOS y generar alerta real

SELECT
  p.product_code,
  p.product_name,
  p.category,
  COALESCE(s.current_stock, 0) AS current_stock,
  p.reorder_level,
  (p.reorder_level - COALESCE(s.current_stock, 0)) AS shortage
FROM products p
LEFT JOIN vw_stock_current s ON s.product_id = p.product_id
WHERE p.reorder_level IS NOT NULL
  AND COALESCE(s.current_stock, 0) < p.reorder_level
ORDER BY shortage DESC;
