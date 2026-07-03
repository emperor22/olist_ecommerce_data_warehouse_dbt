select *
from {{ ref('fct_orders') }}
where order_gross_value < 0
   or order_item_value < 0
   or order_freight_value < 0
   or total_payment_value < 0
