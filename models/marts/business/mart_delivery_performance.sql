select
    date_trunc('month', order_date) as order_month,
    customer_state,
    count(distinct order_id) as order_count,
    avg(purchase_to_delivery_days) as avg_delivery_days,
    avg(estimated_delivery_days) as avg_estimated_delivery_days,
    sum(is_late_delivery) as late_delivery_count,
    avg(is_late_delivery) as late_delivery_rate,
    avg(days_late) as avg_days_late,
    avg(avg_review_score) as avg_review_score
from {{ ref('fct_orders') }} o
left join {{ ref('dim_customers') }} c
    on o.customer_id = c.customer_id
where order_date is not null
group by 1, 2
