
SELECT
    customer_id,
    COUNT(*) AS order_count,
    SUM(amount) AS total_spent
FROM DCM_LEARNING.PROD.ORDERS_RAW
GROUP BY customer_id