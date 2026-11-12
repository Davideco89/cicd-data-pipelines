{{ config(materialized='table') }}

SELECT
    order_date,
    COUNT(*) AS completed_order_count,
    SUM(amount_cents) AS revenue_cents
FROM {{ ref('stg_orders') }}
WHERE status = 'completed'
GROUP BY order_date
