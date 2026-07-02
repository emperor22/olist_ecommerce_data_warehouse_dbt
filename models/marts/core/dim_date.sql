with date_bounds as (
    select
        cast(min(purchased_at) as date) as min_date,
        cast(max(purchased_at) as date) as max_date
    from {{ ref('stg_olist_orders') }}
    where purchased_at is not null
),

date_spine as (
    select generate_series as date_day
    from date_bounds,
         generate_series(min_date, max_date, interval 1 day)
)

select
    date_day,
    extract(year from date_day) as year,
    extract(quarter from date_day) as quarter,
    extract(month from date_day) as month,
    strftime(date_day, '%Y-%m') as year_month,
    extract(day from date_day) as day_of_month,
    extract(dow from date_day) as day_of_week,
    strftime(date_day, '%A') as day_name,
    case when extract(dow from date_day) in (0, 6) then 1 else 0 end as is_weekend
from date_spine
