-- The best selling product details
SELECT * FROM product WHERE 
product_id=(SELECT o.product_id FROM orders AS o WHERE 
            cancelation_status=0 
            GROUP BY o.product_id
            ORDER BY SUM(quantity) DESC
            LIMIT 1);
 
-- Most cancelled product details
SELECT * FROM product WHERE
product_id= (SELECT o.product_id FROM orders AS o WHERE
             cancelation_status=1
             GROUP BY order_id
             ORDER BY SUM(quantity) DESC
             LIMIT 1);

-- Who all made cancelation and how much time
SELECT c.*, COUNT(o.order_id) AS cancellation_count FROM 
customers AS c JOIN orders AS o ON
c.customer_id= o.customer_id 
WHERE o.cancelation_status=1
GROUP BY c.customer_id
ORDER BY cancellation_count;

-- who made maximum orders and the count
SELECT c.*, COUNT(o.order_id) as quantity_purchased FROM
orders o JOIN customers c ON
o.customer_id=c.customer_id 
WHERE o.cancelation_status=0
GROUP BY o.customer_id 
ORDER BY quantity_purchased DESC;

-- most purchased 5 brands
SELECT p.brand , COUNT(o.order_id) AS number_of_purchases FROM
orders o JOIN product p ON
p.product_id=o.order_id
WHERE o.cancelation_status=0
GROUP BY p.brand
ORDER BY number_of_purchases DESC
LIMIT 5;

-- most purchased 5 product category
SELECT p.category AS product_category , SUM(o.quantity) AS number_of_purchases FROM
orders o JOIN product p ON
p.product_id=o.order_id
WHERE o.cancelation_status=0
GROUP BY p.category
ORDER BY number_of_purchases DESC
LIMIT 5;



--  The cancellation count of each product
SELECT p.product_id,p.brand,
    COUNT(o.order_id) AS total_orders,
    SUM(o.cancelation_status=1) AS cancellation_count,
    ROUND(SUM(o.cancelation_status)/COUNT(o.order_id)*100, 2) AS cancellation_rate_percent 
    FROM product p JOIN orders o ON p.product_id = o.product_id
	GROUP BY p.product_id, p.brand
    ORDER BY cancellation_rate_percent DESC;
