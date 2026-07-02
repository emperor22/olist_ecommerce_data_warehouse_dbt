with customer_orders as (
    select
        customer_unique_id,
        order_id,
        purchased_at,
        order_gross_value,
        row_number() over (
            partition by customer_unique_id
            order by purchased_at
        ) as order_number
    from {{ ref('fct_orders') }}
    where customer_unique_id is not null
      and purchased_at is not null
),

customer_summary as (
    select
        customer_unique_id,
        min(purchased_at) as first_order_at,
        max(purchased_at) as latest_order_at,
        count(distinct order_id) as lifetime_order_count,
        sum(order_gross_value) as lifetime_gross_revenue,
        max(case when order_number = 2 then purchased_at end) as second_order_at
    from customer_orders
    group by 1
)

select
    customer_unique_id,
    first_order_at,
    latest_order_at,
    lifetime_order_count,
    lifetime_gross_revenue,
    case when lifetime_order_count > 1 then 1 else 0 end as is_repeat_customer,
    second_order_at,
    case
        when second_order_at is null then null
        else date_diff('day', first_order_at, second_order_at)
    end as days_between_first_and_second_order
from customer_summary
