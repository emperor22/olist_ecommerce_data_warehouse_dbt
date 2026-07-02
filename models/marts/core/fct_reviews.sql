select
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_created_at,
    review_answered_at,
    case when review_comment_message is not null then 1 else 0 end as has_review_comment
from {{ ref('stg_olist_order_reviews') }}
