-- KPI #2: Top rotation per month (OUT movements)
-- Top 10 items per month by OUT quantity

WITH monthly AS (
  SELECT
    date_trunc('month', m.moved_at)::date AS month,
    p.product_id,
    p.product_code,
    p.product_name,
    p.category,
    SUM(m.quantity) AS total_out_qty
  FROM public.movements m
  JOIN public.products p ON p.product_id = m.product_id
  WHERE m.movement_type = 'OUT'
  GROUP BY 1, 2, 3, 4, 5
),
ranked AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY month ORDER BY total_out_qty DESC) AS rn
  FROM monthly
)
SELECT
  month,
  product_code,
  product_name,
  category,
  total_out_qty,
  rn AS rank_in_month
FROM ranked
WHERE rn <= 10
ORDER BY month DESC, total_out_qty DESC;