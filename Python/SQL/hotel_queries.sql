CREATE TABLE IF NOT EXISTS users (
    user_id       VARCHAR(50) PRIMARY KEY,
    name          VARCHAR(100),
    phone_number  VARCHAR(15),
    mail_id       VARCHAR(100),
    billing_address VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS bookings (
    booking_id    VARCHAR(50) PRIMARY KEY,
    booking_date  DATETIME,
    room_no       VARCHAR(50),
    user_id       VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS items (
    item_id       VARCHAR(50) PRIMARY KEY,
    item_name     VARCHAR(100),
    item_rate     DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS booking_commercials (
    id            VARCHAR(50) PRIMARY KEY,
    booking_id    VARCHAR(50),
    bill_id       VARCHAR(50),
    bill_date     DATETIME,
    item_id       VARCHAR(50),
    item_quantity DECIMAL(10,2)
);

-- Sample Data

INSERT INTO users VALUES
('u001', 'John Doe',   '9700000001', 'john@example.com', 'Hyderabad'),
('u002', 'Jane Smith', '9700000002', 'jane@example.com', 'Mumbai'),
('u003', 'Ravi Kumar', '9700000003', 'ravi@example.com', 'Chennai');

INSERT INTO bookings VALUES
('bk001', '2021-09-10 10:00:00', 'rm-101', 'u001'),
('bk002', '2021-11-01 14:00:00', 'rm-102', 'u001'),
('bk003', '2021-11-15 09:00:00', 'rm-103', 'u002'),
('bk004', '2021-10-05 11:00:00', 'rm-104', 'u003'),
('bk005', '2021-11-20 16:00:00', 'rm-105', 'u003');

INSERT INTO items VALUES
('itm001', 'Tawa Paratha', 18.00),
('itm002', 'Mix Veg',      89.00),
('itm003', 'Dal Fry',      75.00),
('itm004', 'Paneer Curry', 120.00),
('itm005', 'Rice',         40.00);

INSERT INTO booking_commercials VALUES
('bc001', 'bk002', 'bl001', '2021-11-01 12:00:00', 'itm001', 3),
('bc002', 'bk002', 'bl001', '2021-11-01 12:00:00', 'itm002', 1),
('bc003', 'bk003', 'bl002', '2021-11-15 15:00:00', 'itm003', 2),
('bc004', 'bk003', 'bl002', '2021-11-15 15:00:00', 'itm004', 1),
('bc005', 'bk004', 'bl003', '2021-10-05 11:00:00', 'itm001', 5),
('bc006', 'bk004', 'bl003', '2021-10-05 11:00:00', 'itm002', 10),
('bc007', 'bk005', 'bl004', '2021-11-20 17:00:00', 'itm004', 3),
('bc008', 'bk005', 'bl004', '2021-11-20 17:00:00', 'itm005', 2),
('bc009', 'bk001', 'bl005', '2021-09-10 13:00:00', 'itm003', 4),
('bc010', 'bk001', 'bl005', '2021-09-10 13:00:00', 'itm005', 1);


-- Q1. For every user, get user_id and last booked room_no

SELECT u.user_id, b.room_no
FROM users u
JOIN bookings b ON u.user_id = b.user_id
WHERE b.booking_date = (
    SELECT MAX(b2.booking_date)
    FROM bookings b2
    WHERE b2.user_id = u.user_id
);


-- Q2. booking_id and total billing amount for bookings
--     created in November 2021
SELECT
    bc.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_billing_amount
FROM booking_commercials bc
JOIN items i    ON bc.item_id    = i.item_id
JOIN bookings b ON bc.booking_id = b.booking_id
WHERE DATE_FORMAT(b.booking_date, '%Y-%m') = '2021-11'
GROUP BY bc.booking_id;


-- Q3. bill_id and bill amount for bills in October 2021
--     where bill amount > 1000

SELECT
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE DATE_FORMAT(bc.bill_date, '%Y-%m') = '2021-10'
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;


-- Q4. Most ordered and least ordered item of each month
--     in year 2021

WITH monthly_orders AS (
    SELECT
        DATE_FORMAT(bc.bill_date, '%Y-%m') AS month,
        i.item_name,
        SUM(bc.item_quantity)              AS total_qty
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY DATE_FORMAT(bc.bill_date, '%Y-%m'), i.item_name
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

-- Q5. Customers with the second highest bill value
--     of each month in year 2021

WITH bill_totals AS (
    SELECT
        DATE_FORMAT(bc.bill_date, '%Y-%m')     AS month,
        b.user_id,
        bc.bill_id,
        SUM(bc.item_quantity * i.item_rate)    AS bill_amount
    FROM booking_commercials bc
    JOIN items    i ON bc.item_id    = i.item_id
    JOIN bookings b ON bc.booking_id = b.booking_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY DATE_FORMAT(bc.bill_date, '%Y-%m'), b.user_id, bc.bill_id
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
