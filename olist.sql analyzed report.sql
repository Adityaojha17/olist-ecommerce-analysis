-- how does revenue change month by month ? 
select date_format( ot.order_purchase_datestatamp,'%y-%m') as months,
round(sum(o.price) , 2) as month_evenue from orderstiming as ot
inner join olist_orders as o
on ot.order_id = o. order_id
group by months
order by months;
-- which product categories generate the most revenue ?
select
p.product_category_name, round(sum(o.price) , 2) as mostrevenue
from products as p
inner join olist_orders as o
on p.product_id = o.product_id
group by p.product_category_name
order by mostrevenue desc; 
-- which states generate the highest revenue ? 
select
s.seller_state ,round(sum(o.price) , 2) as mostrevenue
from seller as s
inner join olist_orders as o
on s.seller_id = o.seller_id
group by s.seller_state
order by mostrevenue desc; 

-- what is the average order value and how does that vary ? 
select date_format( ot.order_purchase_datestatamp,'%y-%m') as months,
round(avg(o.price) , 2) as  avg_month_evenue from orderstiming as ot
inner join olist_orders as o
on ot.order_id = o. order_id
group by months
order by months;
-- which seller generate the highest revenue ?
select
s.seller_id ,round(sum(o.price) , 2) as mostrevenue
from seller as s
inner join olist_orders as o
on s.seller_id = o.seller_id
group by s.seller_id
order by mostrevenue desc;  
-- which seller have high revenue but low customer ratings ? 
select
s.seller_id , round(sum(o.price) , 2) as mostrevenue,min(r.review_score)as low_rating 
from seller as s
inner join olist_orders as o
on s.seller_id = o.seller_id
inner join review_rating as r
on o.order_id = r.order_id
group by s.seller_id 
order by mostrevenue desc;  
-- which categories has highest sell with low customers satisfaction ? 
s
-- what percentage of order are delivered late  ? 
-- which states have the highest late delivery rates? 
select  c.customer_state, count(*) as total_orders, 
count(
	case
		when datediff(ot.order_delivered_customer_date, ot.order_estimated_delivery_date)>0 then 1 
else 0
end)  as late_order ,
round(count
(
case when datediff(ot.order_delivered_customer_date, ot.order_estimated_delivery_date)>0 then 1 
else 0 end)/ count(*) * 100 ,2) as late_delivery_rate
from orderstiming as ot
join customer_data as c
on  c.customer_id = ot.customer_id
where ot.order_status = 'delivered'
and ot. order_delivered_customer_date !='0000-00-00'
and ot.order_estimated_delivery_date != '0000-00-00'
group by c.customer_state 
order by  late_delivery_rate
desc;

-- does late delivery affect customers review scores ? 
select round(avg(r.review_score)) as review_scores,case
when datediff(ot.order_delivered_customer_date, ot.order_estimated_delivery_date)
> 0 then 'late delviery'
else 'on time'
end as delivery_affect
from orderstiming as ot
join review_rating as r
on ot.order_id = r. order_id
group by delivery_affect;
-- which payment methods are most commonly used most lucrative ? 
select p.payment_type,round(sum(o.price),2) total_payment,
count(p.payment_type) as transcation_count
from payments as p
join
olist_orders as o
on p.order_id = o.order_id
group by payment_type ;

-- which product categories have the highest frieght cost ? 
select
p.product_category_name, round(sum(o.freight_value) , 2) as highest_freight_cost
from products as p
inner join olist_orders as o
on p.product_id = o.product_id
group by p.product_category_name
order by  highest_freight_cost desc; 

-- are there sellers with strong sales but unusally high shipping costs ?
select seller_id, round(sum(price),2) as totalcost,
round(sum(freight_value),2) as shippingcost,
round(round(sum(freight_value),2)/round(sum(price),2)* 100,2) as precentage
from olist_orders
group by seller_id;

-- are customers concreated in a few states, and do those states drive most of the revenue ? 
select c.customer_state, count( distinct c.customer_id) as total_customers,round(sum(o.price),2) as total_revenue
from olist_orders as o
join orderstiming as ot 
on o.order_id = ot.order_id 
join customer_data as c
on ot.customer_id = c.customer_id
group by c.customer_state;
-- what are the biggest business problems olist should address based on the data ? 
use portflio;