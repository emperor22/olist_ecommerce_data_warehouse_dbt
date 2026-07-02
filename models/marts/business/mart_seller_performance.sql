select
    s.seller_id,
    s.seller_city,
    s.seller_state,
    count(distinct oi.order_id) as order_count,
    count(*) as item_count,
    count(distinct oi.product_id) as product_count,
    sum(oi.item_price) as item_revenue,
    sum(oi.freight_value) as freight_revenue,
    sum(oi.item_total_value) as gross_revenue,
    avg(o.avg_review_score) as avg_review_score,
    avg(o.purchase_to_delivery_days) as avg_delivery_days,
    avg(o.is_late_delivery) as late_delivery_rate
from {{ ref('fct_order_items') }} oi
left join {{ ref('dim_sellers') }} s
    on oi.seller_id = s.seller_id
left join {{ ref('fct_orders') }} o
    on oi.order_id = o.order_id
group by 1, 2, 3
