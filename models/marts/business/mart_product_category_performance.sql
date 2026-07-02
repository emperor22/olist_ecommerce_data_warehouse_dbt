select
    coalesce(p.product_category_name_english, 'unknown') as product_category_name_english,
    count(distinct oi.order_id) as order_count,
    count(*) as item_count,
    count(distinct oi.product_id) as product_count,
    count(distinct oi.seller_id) as seller_count,
    sum(oi.item_price) as item_revenue,
    sum(oi.freight_value) as freight_revenue,
    sum(oi.item_total_value) as gross_revenue,
    avg(oi.item_price) as avg_item_price,
    avg(o.avg_review_score) as avg_review_score,
    avg(o.is_late_delivery) as late_delivery_rate
from {{ ref('fct_order_items') }} oi
left join {{ ref('dim_products') }} p
    on oi.product_id = p.product_id
left join {{ ref('fct_orders') }} o
    on oi.order_id = o.order_id
group by 1
