with products as (
    select
        cast(product_id as varchar) as product_id,
        cast(product_category_name as varchar) as product_category_name,
        cast(product_name_lenght as integer) as product_name_length,
        cast(product_description_lenght as integer) as product_description_length,
        cast(product_photos_qty as integer) as product_photos_qty,
        cast(product_weight_g as double) as product_weight_g,
        cast(product_length_cm as double) as product_length_cm,
        cast(product_height_cm as double) as product_height_cm,
        cast(product_width_cm as double) as product_width_cm
    from {{ source('raw_olist', 'products') }}
),

translations as (
    select
        cast(product_category_name as varchar) as product_category_name,
        cast(product_category_name_english as varchar) as product_category_name_english
    from {{ source('raw_olist', 'product_category_translation') }}
)

select
    p.product_id,
    p.product_category_name,
    coalesce(t.product_category_name_english, p.product_category_name, 'unknown') as product_category_name_english,
    p.product_name_length,
    p.product_description_length,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,
    p.product_length_cm * p.product_height_cm * p.product_width_cm as product_volume_cm3
from products p
left join translations t
    on p.product_category_name = t.product_category_name
