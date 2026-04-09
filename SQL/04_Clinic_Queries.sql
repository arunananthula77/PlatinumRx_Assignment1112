
-- Q1. Revenue from each sales channel in a given year (2021)

SELECT
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel
ORDER BY total_revenue DESC;

-- Q2. Top 10 most valuable customers in a given year (2021)

SELECT
    cs.uid,
    c.name,
    SUM(cs.amount) AS total_spend
FROM clinic_sales cs
JOIN customer c ON cs.uid = c.uid
WHERE YEAR(cs.datetime) = 2021
GROUP BY cs.uid, c.name
ORDER BY total_spend DESC
LIMIT 10;

-- Q3. Month-wise revenue, expense, profit, and
--     profitability status for year 2021

WITH rev AS (
    SELECT
        DATE_FORMAT(datetime, '%Y-%m') AS month,
        SUM(amount)                    AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY DATE_FORMAT(datetime, '%Y-%m')
),
exp AS (
    SELECT
        DATE_FORMAT(datetime, '%Y-%m') AS month,
        SUM(amount)                    AS expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY DATE_FORMAT(datetime, '%Y-%m')
)
SELECT
    r.month,
    COALESCE(r.revenue, 0)                                AS revenue,
    COALESCE(e.expense, 0)                                AS expense,
    COALESCE(r.revenue, 0) - COALESCE(e.expense, 0)      AS profit,
    CASE
        WHEN COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) >= 0
        THEN 'Profitable'
        ELSE 'Not-Profitable'
    END AS status
FROM rev r
LEFT JOIN exp e ON r.month = e.month
ORDER BY r.month;

-- Q4. Most profitable clinic for each city in a given month
--     (Change '2021-09' to your target month)

WITH clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.city,
        COALESCE(SUM(cs.amount), 0) - COALESCE(SUM(ex.amount), 0) AS profit
    FROM clinics cl
    LEFT JOIN clinic_sales cs
           ON cl.cid = cs.cid
          AND DATE_FORMAT(cs.datetime, '%Y-%m') = '2021-09'
    LEFT JOIN expenses ex
           ON cl.cid = ex.cid
          AND DATE_FORMAT(ex.datetime, '%Y-%m') = '2021-09'
    GROUP BY cl.cid, cl.clinic_name, cl.city
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rnk
    FROM clinic_profit
)
SELECT city, cid, clinic_name, profit
FROM ranked
WHERE rnk = 1
ORDER BY city;


-- Q5. Second least profitable clinic for each state
--     in a given month (Change '2021-09' to your target month)

WITH clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.state,
        COALESCE(SUM(cs.amount), 0) - COALESCE(SUM(ex.amount), 0) AS profit
    FROM clinics cl
    LEFT JOIN clinic_sales cs
           ON cl.cid = cs.cid
          AND DATE_FORMAT(cs.datetime, '%Y-%m') = '2021-09'
    LEFT JOIN expenses ex
           ON cl.cid = ex.cid
          AND DATE_FORMAT(ex.datetime, '%Y-%m') = '2021-09'
    GROUP BY cl.cid, cl.clinic_name, cl.state
),
ranked AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS rnk
    FROM clinic_profit
)
SELECT state, cid, clinic_name, profit
FROM ranked
WHERE rnk = 2
ORDER BY state;
