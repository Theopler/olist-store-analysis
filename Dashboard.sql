create database olist_superstore;

use olist_superstore;

select* from olist_geolocation_dataset;
SELECT*FROM olist_orders_dataset;
select*from olist_order_payments_dataset;
select * from olist_order_reviews_dataset;
select*from olist_order_items_dataset;
select*from olist_products_dataset;
select* from olist_order_payments_dataset;
select * from olist_order_reviews_dataset;
#1 kpi Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics
SELECT
    CASE 
        WHEN DAYOFWEEK(o.order_purchase_timestamp) IN (1,7)
        then 'Weekend'
        ELSE 'Weekday'
    End as Day_Types,
     round(count(distinct o.order_id),0) as Total_orders,
     round(sum(p.payment_value),0)as Total_payments,
    round(avg(p.payment_value),0)as Avg_payments
    from 
    olist_orders_dataset o
    join
    olist_order_payments_dataset p on o.order_id=p.order_id
    group by
     Day_Types;
     
     #2kpi Number of Orders with review score 5 and payment type as credit card.
select
  count(distinct p.order_id)as no_of_orders
  from
  olist_order_payments_dataset p 
  join
  olist_order_reviews_dataset r on p.order_id=r.order_id
  where
  r.review_score= 5
  and
  p.payment_type= 'credit_card';
  
  #3 kpi Average number of days taken for order_delivered_customer_date for pet_shop
select 
    product_category_name,
    round(avg(datediff(O.order_delivered_customer_date, O.order_purchase_timestamp)),0)as avg_days
from
 olist_orders_dataset o
 join
 olist_order_items_dataset i on i.order_id=o.order_id
 join
 olist_products_dataset p on p.product_id=i.product_id
 where
 p. product_category_name='pet_shop'
 and
 o.order_delivered_customer_date is not null;
 
 #4 kpi Average price and payment values from customers of sao paulo city
select
round(avg(i.price),0) as avg_price,
round(avg(p.payment_value),0) as avg_payment_value
from 
olist_customers_dataset c
join
olist_orders_dataset o on o.customer_id=c.customer_id
join
olist_order_items_dataset i on i.order_id=o.order_id
join
olist_order_payments_dataset p  on o.order_id=p.order_id
where
c.customer_city='sao paulo';
        
#5 kpi Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores

select
rew.review_score,
avg(datediff(order_delivered_customer_date, order_purchase_timestamp)) as avgshippingdays
from
olist_orders_dataset as ord
join
olist_order_reviews_dataset rew on rew.order_id=ord.order_id
group by
rew.review_score
order by
rew.review_score;


SELECT
    r.review_score,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date,
                       o.order_purchase_timestamp)), 2) AS avg_shipping_days,
    COUNT(*) AS total_orders
FROM olist_orders_dataset o
JOIN olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score;
