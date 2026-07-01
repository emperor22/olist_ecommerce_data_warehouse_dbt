select
    order_id,
    purchased_at,
    approved_at,
    delivered_to_carrier_at,
    delivered_to_customer_at,
    estimated_delivery_at,

    date_diff('day', purchased_at, approved_at) as purchase_to_approval_days,
    date_diff('day', purchased_at, delivered_to_carrier_at) as purchase_to_carrier_days,
    date_diff('day', purchased_at, delivered_to_customer_at) as purchase_to_delivery_days,
    date_diff('day', purchased_at, estimated_delivery_at) as estimated_delivery_days,

    case
        when delivered_to_customer_at is null or estimated_delivery_at is null then null
        when delivered_to_customer_at > estimated_delivery_at then 1
        else 0
    end as is_late_delivery,

    case
        when delivered_to_customer_at is null or estimated_delivery_at is null then null
        else date_diff('day', estimated_delivery_at, delivered_to_customer_at)
    end as days_late
from {{ ref('stg_olist_orders') }}
