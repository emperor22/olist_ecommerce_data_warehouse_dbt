select
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    p.product_category_name,
    p.product_category_name_english,
    oi.seller_id,
    s.seller_city,
    s.seller_state,
    oi.shipping_limit_at,
    oi.item_price,
    oi.freight_value,
    oi.item_price + oi.freight_value as item_total_value
from {{ ref('stg_olist_order_items') }} oi
left join {{ ref('stg_olist_products') }} p
    on oi.product_id = p.product_id
left join {{ ref('stg_olist_sellers') }} s
    on oi.seller_id = s.seller_id
