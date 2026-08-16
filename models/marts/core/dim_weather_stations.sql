with reference_data as (

    select * from {{ ref('weather_stations_ref') }}

)

select
    weather_station_id,
    station_name,
    latitude,
    longitude,
    elevation,
    city,
    state,
    hardware,
    software
from reference_data