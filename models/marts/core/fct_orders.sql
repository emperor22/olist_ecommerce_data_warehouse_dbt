{{ config(materialized='incremental', unique_key='order_id') }}

select
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    cast(o.purchased_at as date) as order_date,
    o.purchased_at,
    o.approved_at,
    o.delivered_to_carrier_at,
    o.delivered_to_customer_at,
    o.estimated_delivery_at,
    o.order_status,

    coalesce(r.order_item_count, 0) as order_item_count,
    coalesce(r.distinct_product_count, 0) as distinct_product_count,
    coalesce(r.distinct_seller_count, 0) as distinct_seller_count,
    coalesce(r.order_item_value, 0) as order_item_value,
    coalesce(r.order_freight_value, 0) as order_freight_value,
    coalesce(r.order_gross_value, 0) as order_gross_value,

    coalesce(p.total_payment_value, 0) as total_payment_value,
    p.payment_record_count,
    p.payment_method_count,
    p.max_payment_installments,
    p.payment_types,

    rv.review_count,
    rv.avg_review_score,
    rv.min_review_score,
    rv.max_review_score,
    rv.has_review_comment,

    d.purchase_to_approval_days,
    d.purchase_to_carrier_days,
    d.purchase_to_delivery_days,
    d.estimated_delivery_days,
    d.is_late_delivery,
    d.days_late

from {{ ref('stg_olist_orders') }} o
left join {{ ref('stg_olist_customers') }} c
    on o.customer_id = c.customer_id
left join {{ ref('int_order_revenue') }} r
    on o.order_id = r.order_id
left join {{ ref('int_order_payments') }} p
    on o.order_id = p.order_id
left join {{ ref('int_order_reviews') }} rv
    on o.order_id = rv.order_id
left join {{ ref('int_order_delivery') }} d
    on o.order_id = d.order_id

{% if is_incremental() %}
where o.purchased_at >= (select coalesce(max(purchased_at), timestamp '1900-01-01') from {{ this }})
{% endif %}
