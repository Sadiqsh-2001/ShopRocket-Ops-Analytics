Select * from orders_enriched;
Select carrier,count(order_id)as total_orders,sum(is_sla_breached) as total_sla_breaches,ROUND(100.00 * sum(is_sla_breached)/count(order_id),2) as breach_percentage
from orders_enriched
group by carrier
order by breach_percentage desc;