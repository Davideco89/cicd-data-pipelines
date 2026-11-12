SELECT
    order_id,
    amount_cents
FROM {{ ref('raw_orders') }}
WHERE amount_cents < 0
