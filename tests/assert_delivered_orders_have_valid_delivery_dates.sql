select *
from {{ ref('fct_orders') }}
where order_status = 'delivered'
  and delivered_to_customer_at is not null
  and purchased_at is not null
  and delivered_to_customer_at < purchased_at
