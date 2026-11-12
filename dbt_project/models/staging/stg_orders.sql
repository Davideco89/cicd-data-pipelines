{{ config(materialized='view') }}

SELECT
    order_id,
    customer_id,
    order_date,
    status,
    amount_cents
FROM {{ ref('raw_orders') }}
