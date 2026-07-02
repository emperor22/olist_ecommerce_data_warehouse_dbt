select
    c.customer_id,
    c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,
    fo.first_order_at,
    fo.latest_order_at,
    coalesce(fo.lifetime_order_count, 0) as lifetime_order_count,
    case when coalesce(fo.lifetime_order_count, 0) > 1 then 1 else 0 end as is_repeat_customer
from {{ ref('stg_olist_customers') }} c
left join {{ ref('int_customer_first_order') }} fo
    on c.customer_unique_id = fo.customer_unique_id
