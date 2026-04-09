1] # Get user_id and last booked room_no for every user
SELECT b.user_id, b.room_no
FROM bookings b
JOIN (
    SELECT user_id, MAX(booking_date) AS last_booking
    FROM bookings
    GROUP BY user_id
) lb
ON b.user_id = lb.user_id AND b.booking_date = lb.last_booking;


2] # Get booking_id and total billing amount of every booking created in November, 2021
SELECT bc.booking_id,
       SUM(bc.item_quantity * i.item_rate) AS total_bill
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date) = 11
  AND YEAR(bc.bill_date) = 2021
GROUP BY bc.booking_id;

3]#Get bill_id and bill amount of all the bills raised in October, 2021 having bill amount >1000
SELECT bc.bill_id,
       SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date) = 10
  AND YEAR(bc.bill_date) = 2021
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;

4]#Determine the most ordered and least ordered item of each month of year 2021
WITH item_orders AS (
    SELECT 
        MONTH(bc.bill_date) AS month,
        bc.item_id,
        SUM(bc.item_quantity) AS total_qty
    FROM booking_commercials bc
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), bc.item_id
),
ranked_items AS (
    SELECT *,
           RANK() OVER (PARTITION BY month ORDER BY total_qty DESC) AS rnk_desc,
           RANK() OVER (PARTITION BY month ORDER BY total_qty ASC) AS rnk_asc
    FROM item_orders
)
SELECT *
FROM ranked_items
WHERE rnk_desc = 1 OR rnk_asc = 1;

5]#Find the customers with the second highest bill value of each month of year 2021
WITH monthly_bills AS (
    SELECT 
        b.user_id,
        MONTH(bc.bill_date) AS month,
        SUM(bc.item_quantity * i.item_rate) AS total_bill
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY b.user_id, MONTH(bc.bill_date)
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY month ORDER BY total_bill DESC) AS rnk
    FROM monthly_bills
)
SELECT *
FROM ranked
WHERE rnk = 2;
