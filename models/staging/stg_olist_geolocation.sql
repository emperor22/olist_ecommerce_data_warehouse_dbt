select
    cast(geolocation_zip_code_prefix as varchar) as geolocation_zip_code_prefix,
    cast(geolocation_lat as double) as geolocation_lat,
    cast(geolocation_lng as double) as geolocation_lng,
    lower(trim(cast(geolocation_city as varchar))) as geolocation_city,
    upper(trim(cast(geolocation_state as varchar))) as geolocation_state
from {{ source('raw_olist', 'geolocation') }}
