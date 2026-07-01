select
    c.customer_unique_id,
    min(o.purchased_at) as first_order_at,
    max(o.purchased_at) as latest_order_at,
    count(distinct o.order_id) as lifetime_order_count
from {{ ref('stg_olist_orders') }} o
left join {{ ref('stg_olist_customers') }} c
    on o.customer_id = c.customer_id
where o.purchased_at is not null
group by 1
