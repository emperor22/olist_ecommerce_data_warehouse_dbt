select
    order_date,
    count(distinct order_id) as order_count,
    count(distinct customer_unique_id) as customer_count,
    sum(order_item_count) as item_count,
    sum(order_item_value) as item_revenue,
    sum(order_freight_value) as freight_revenue,
    sum(order_gross_value) as gross_revenue,
    sum(total_payment_value) as payment_value,
    avg(order_gross_value) as avg_order_value,
    avg(avg_review_score) as avg_review_score,
    avg(purchase_to_delivery_days) as avg_delivery_days,
    sum(is_late_delivery) as late_delivery_count
from {{ ref('fct_orders') }}
where order_date is not null
group by 1
