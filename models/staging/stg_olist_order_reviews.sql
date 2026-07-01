select
    cast(review_id as varchar) as review_id,
    cast(order_id as varchar) as order_id,
    cast(review_score as integer) as review_score,
    nullif(cast(review_comment_title as varchar), '') as review_comment_title,
    nullif(cast(review_comment_message as varchar), '') as review_comment_message,
    try_cast(review_creation_date as timestamp) as review_created_at,
    try_cast(review_answer_timestamp as timestamp) as review_answered_at
from {{ source('raw_olist', 'order_reviews') }}
