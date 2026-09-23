with station_pro as (
    select 
        h."station_id",
        h."observed_at",
        h."temperature",
        h."pressure",
        h."humidity",
        h."speed",
        h."wind",
        s."station_name",
        'station pro' as source
    from {{ref('stg_infoclimat__hourly')}} as h
    left join {{ref('stg_infoclimat__stations')}} as s
    on h."station_id" = s."station_id"
)

select *
from station_pro