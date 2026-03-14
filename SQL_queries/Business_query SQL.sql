-- ============================================================
-- SHOPROCKET OPS ANALYTICS — BUSINESS SQL QUERIES
-- Dataset: Olist Brazilian E-Commerce (Synthetic Enrichment)
-- Author: Sadique Shoaib
-- ============================================================


-- ============================================================
-- QUERY 1: Carrier-wise SLA Breach Rate
-- Business Question: Which carrier has the highest SLA breach rate?
-- ============================================================

SELECT
    carrier,
    COUNT(order_id)                                                        AS total_orders,
    SUM(is_sla_breached)                                                   AS total_sla_breaches,
    ROUND(100.0 * SUM(is_sla_breached) / NULLIF(COUNT(order_id), 0), 2)  AS breach_rate_pct
FROM orders_enriched
GROUP BY carrier
ORDER BY breach_rate_pct DESC;

/*
INSIGHT: Delhivery has the highest breach rate at 18.59% — nearly 3x compared
to BlueDart (6.87%), ShadowFax (6.88%), and Ecom Express (7.33%).
Despite handling the most volume (34,576 orders), Delhivery's SLA performance
is a critical operational red flag.
*/


-- ============================================================
-- QUERY 2: City-wise Delivery Performance (Top 10 Cities)
-- Business Question: Which cities have the worst delivery performance?
-- ============================================================

SELECT
    c.customer_city,
    COUNT(o.order_id)                                                          AS total_orders,
    ROUND(AVG(o.actual_delivery_days), 2)                                      AS avg_delivery_days,
    ROUND(100.0 * SUM(o.is_sla_breached) / NULLIF(COUNT(o.order_id), 0), 2)  AS breach_rate_pct
FROM customers c
INNER JOIN orders_enriched o ON c.customer_id = o.customer_id
GROUP BY c.customer_city
ORDER BY total_orders DESC
LIMIT 10;

/*
INSIGHT: Sao Paulo is the best performer — highest volume (15,540 orders) with
only 5.48% breach rate and 7.6 avg delivery days. Salvador is the worst —
22.65% breach rate and 18.88 avg delivery days. Clear pattern: cities farther
from Sao Paulo experience significantly slower and less reliable delivery.
*/


-- ============================================================
-- QUERY 3: Revenue by Product Category (Top 10)
-- Business Question: Which product categories generate the most revenue?
-- ============================================================

SELECT
    p.product_category_name_english,
    COUNT(DISTINCT oi.order_id)    AS total_orders,
    ROUND(SUM(oi.price), 2)        AS total_revenue,
    ROUND(AVG(oi.price), 2)        AS avg_order_value
FROM products_enriched p
INNER JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;

/*
INSIGHT: health_beauty leads in total revenue (R$1.25M, 8,836 orders).
watches_gifts has the highest avg order value (R$201) — a premium category
with fewer but higher-value transactions. bed_bath_table ranks 3rd by revenue
but has a lower avg order value (R$93), driven purely by volume (9,417 orders).
*/


-- ============================================================
-- QUERY 4: Payment Method Analysis
-- Business Question: What is the payment method distribution and revenue share?
-- ============================================================

SELECT
    payment_type,
    COUNT(order_id)                                                              AS total_transactions,
    ROUND(SUM(payment_value), 2)                                                 AS total_revenue,
    ROUND(AVG(payment_value), 2)                                                 AS avg_payment_value,
    ROUND(100.0 * COUNT(order_id) / SUM(COUNT(order_id)) OVER (), 2)            AS pct_share
FROM payments
GROUP BY payment_type
ORDER BY total_transactions DESC;

/*
INSIGHT: Credit card dominates with 73.92% of all transactions and highest avg
value (R$163). Boleto (Brazil's cash payment system) holds 19.04% — significant
offline customer segment. Debit card adoption is surprisingly low at just 1.47%.
*/


-- ============================================================
-- QUERY 5: Seller Performance Ranking (Top 10 by Revenue)
-- Business Question: Who are the top revenue-generating sellers?
-- ============================================================

SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    oi.seller_tier,
    COUNT(oi.order_id)          AS total_orders,
    ROUND(SUM(oi.price), 2)     AS total_revenue,
    ROUND(AVG(oi.price), 2)     AS avg_order_value
FROM order_items oi
INNER JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_city, s.seller_state, oi.seller_tier
ORDER BY total_revenue DESC
LIMIT 10;

/*
INSIGHT: Top seller (Guariba, SP) generated R$229K from 1,156 orders.
Key anomaly: 2nd ranked seller (Lauro de Freitas, BA) achieved R$222K from
only 410 orders — avg order value of R$543, indicating premium product focus.
6 of top 10 sellers are Bronze tier, suggesting seller_tier is volume-based,
not value-based — a potential flaw in the tier classification system.
*/


-- ============================================================
-- QUERY 6: Order Status / Cancellation Analysis
-- Business Question: What is the order fulfillment funnel breakdown?
-- ============================================================

SELECT
    order_status,
    COUNT(*)                                                             AS total_orders,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2)                  AS pct_share
FROM orders_enriched
GROUP BY order_status
ORDER BY total_orders DESC;

/*
INSIGHT: 97.02% of orders are successfully delivered — strong fulfillment rate.
However, canceled (0.63%) + unavailable (0.61%) = 1.24% combined loss rate.
At scale across ~99K orders, this represents ~1,230 lost orders — significant
revenue leakage that warrants investigation into root causes.
*/


-- ============================================================
-- QUERY 7: Monthly Revenue Trend
-- Business Question: How has order volume and revenue grown over time?
-- ============================================================

SELECT
    EXTRACT(YEAR FROM oe.order_purchase_timestamp)   AS yr,
    EXTRACT(MONTH FROM oe.order_purchase_timestamp)  AS mnth,
    COUNT(oe.order_id)                               AS total_orders,
    ROUND(SUM(oi.price), 2)                          AS total_revenue,
    ROUND(AVG(oi.price), 2)                          AS avg_order_value
FROM orders_enriched oe
INNER JOIN order_items oi ON oe.order_id = oi.order_id
GROUP BY 1, 2
ORDER BY 1, 2 ASC;

/*
INSIGHT: Platform grew ~8x from Jan 2017 (955 orders) to peak months in 2018
(~8,200 orders/month). November 2017 spike to 8,665 orders and R$1M revenue
confirms strong Black Friday effect. Avg order value remained stable at
R$110-135 throughout growth, indicating healthy, consistent pricing.
*/


-- ============================================================
-- QUERY 8: Customer Review Score vs Delivery Performance
-- Business Question: How does delivery delay impact customer satisfaction?
-- ============================================================

SELECT
    r.review_score,
    COUNT(oe.order_id)                                                         AS total_orders,
    ROUND(AVG(oe.actual_delivery_days), 2)                                     AS avg_delivery_days,
    ROUND(AVG(oe.actual_delivery_days - oe.promised_delivery_days), 2)        AS avg_delay_days,
    ROUND(100.0 * SUM(oe.is_sla_breached) / NULLIF(COUNT(oe.order_id), 0), 2) AS sla_breach_rate_pct
FROM reviews_clean r
INNER JOIN orders_enriched oe ON r.order_id = oe.order_id
GROUP BY r.review_score
ORDER BY r.review_score ASC;

/*
INSIGHT: Direct inverse correlation between delivery speed and review score.
1-star orders: avg 2.67 days late, 29.36% breach rate.
5-star orders: avg 2.80 days early, only 6.92% breach rate.
Conclusion: On-time delivery is the single strongest driver of customer
satisfaction — operational logistics improvements directly translate to
better reviews and retention.
*/