select
    order_id,
    count(*) as review_count,
    avg(review_score) as avg_review_score,
    min(review_score) as min_review_score,
    max(review_score) as max_review_score,
    max(review_created_at) as latest_review_created_at,
    max(review_answered_at) as latest_review_answered_at,
    max(case when review_comment_message is not null then 1 else 0 end) as has_review_comment
from {{ ref('stg_olist_order_reviews') }}
group by 1
