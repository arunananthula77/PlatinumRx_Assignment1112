
SELECT u.user_id, b.room_no
FROM users u
JOIN bookings b ON u.user_id = b.user_id
WHERE b.booking_date = (
    SELECT MAX(b2.booking_date)
    FROM bookings b2
    WHERE b2.user_id = u.user_id
);

SELECT
    bc.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_billing_amount
FROM booking_commercials bc
JOIN items i    ON bc.item_id    = i.item_id
JOIN bookings b ON bc.booking_id = b.booking_id
WHERE strftime('%Y-%m', b.booking_date) = '2021-11'
GROUP BY bc.booking_id;


SELECT
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE strftime('%Y-%m', bc.bill_date) = '2021-10'
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;




WITH monthly_orders AS (
    SELECT
        strftime('%Y-%m', bc.bill_date) AS month,
        i.item_name,
        SUM(bc.item_quantity)              AS total_qty
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE strftime('%Y', bc.bill_date) = 2021
    GROUP BY strftime('%Y-%m', bc.bill_date), i.item_name
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY month ORDER BY total_qty DESC) AS rk_most,
        RANK() OVER (PARTITION BY month ORDER BY total_qty ASC)  AS rk_least
    FROM monthly_orders
)
SELECT
    month,
    MAX(CASE WHEN rk_most  = 1 THEN item_name END) AS most_ordered_item,
    MAX(CASE WHEN rk_least = 1 THEN item_name END) AS least_ordered_item
FROM ranked
GROUP BY month
ORDER BY month;



WITH bill_totals AS (
    SELECT
        strftime('%Y-%m', bc.bill_date)     AS month,
        b.user_id,
        bc.bill_id,
        SUM(bc.item_quantity * i.item_rate)    AS bill_amount
    FROM booking_commercials bc
    JOIN items    i ON bc.item_id    = i.item_id
    JOIN bookings b ON bc.booking_id = b.booking_id
    WHERE strftime('%Y', bc.bill_date) = 2021
    GROUP BY strftime('%Y-%m', bc.bill_date), b.user_id, bc.bill_id
),
ranked AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY month ORDER BY bill_amount DESC) AS rnk
    FROM bill_totals
)
SELECT
    r.month,
    u.user_id,
    u.name,
    r.bill_amount
FROM ranked r
JOIN users u ON r.user_id = u.user_id
WHERE r.rnk = 2
ORDER BY r.month;
