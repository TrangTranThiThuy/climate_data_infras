with hourly as (

    select *
    from {{ ref('stg_infoclimat__hourly') }}

),

station as (

    select *
    from {{ ref('stg_infoclimat__stations') }}

),

joined as (

    select
        h.station_id,
        s.station_name,
        s.latitude,
        s.longitude,
        s.elevation,
        s.station_type,

        h.observed_at,
        h.temperature,
        h.pressure,
        h.humidity,
        h.speed,
        h.wind,
        h.rain_1h,

        'infoclimat' as source

    from hourly h

    left join station s
        on h.station_id = s.station_id

)

select *
from joined