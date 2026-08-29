{{ config(materialized='table') }}
SELECT
    customer_id,
    COUNT(*) AS order_count,
    SUM(amount) AS total_spent
FROM {{ source('dcm_raw', 'ORDERS_RAW') }}
GROUP BY customer_id