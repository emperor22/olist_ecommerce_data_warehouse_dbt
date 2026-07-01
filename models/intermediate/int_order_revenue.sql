select
    order_id,
    count(*) as order_item_count,
    count(distinct product_id) as distinct_product_count,
    count(distinct seller_id) as distinct_seller_count,
    sum(item_price) as order_item_value,
    sum(freight_value) as order_freight_value,
    sum(item_total_value) as order_gross_value
from {{ ref('int_order_items_enriched') }}
group by 1
