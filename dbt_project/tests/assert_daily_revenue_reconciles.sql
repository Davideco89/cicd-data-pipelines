WITH expected AS (
    SELECT
        order_date,
        COUNT(*) AS completed_order_count,
        SUM(amount_cents) AS revenue_cents
    FROM {{ ref('raw_orders') }}
    WHERE status = 'completed'
    GROUP BY order_date
),

actual AS (
    SELECT
        order_date,
        completed_order_count,
        revenue_cents
    FROM {{ ref('fct_daily_revenue') }}
)

SELECT
    COALESCE(expected.order_date, actual.order_date) AS order_date,
    expected.completed_order_count AS expected_order_count,
    actual.completed_order_count AS actual_order_count,
    expected.revenue_cents AS expected_revenue_cents,
    actual.revenue_cents AS actual_revenue_cents
FROM expected
FULL OUTER JOIN actual
    ON expected.order_date = actual.order_date
WHERE
    expected.order_date IS NULL
    OR actual.order_date IS NULL
    OR expected.completed_order_count
        IS DISTINCT FROM actual.completed_order_count
    OR expected.revenue_cents IS DISTINCT FROM actual.revenue_cents
