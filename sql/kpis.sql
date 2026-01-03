-- kpis.sql
-- KPI 1: Faltantes (placeholder)
-- Próximo paso: adaptar a ENTRADAS/SALIDAS/PRODUCTOS y generar alerta real

SELECT
  p.product_id,
  p.product_code,
  p.product_name,
  p.category,
  COALESCE(s.current_stock, 0) AS current_stock,
  p.reorder_level,
  (p.reorder_level - COALESCE(s.current_stock, 0)) AS shortage
FROM public.products p
LEFT JOIN public.vw_stock_current s ON s.product_id = p.product_id
WHERE p.reorder_level IS NOT NULL
  AND COALESCE(s.current_stock, 0) < p.reorder_level
  AND NOT EXISTS (
    SELECT 1
    FROM public.alerts a
    WHERE a.product_id = p.product_id
      AND a.alert_type = 'SHORTAGE'
      AND a.sent_day = CURRENT_DATE
  )
ORDER BY shortage DESC;
