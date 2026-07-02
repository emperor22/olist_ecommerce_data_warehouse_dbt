select
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.product_category_name_english,
    oi.seller_id,
    cast(o.purchased_at as date) as order_date,
    o.purchased_at,
    oi.shipping_limit_at,
    oi.item_price,
    oi.freight_value,
    oi.item_total_value
from {{ ref('int_order_items_enriched') }} oi
left join {{ ref('stg_olist_orders') }} o
    on oi.order_id = o.order_id
