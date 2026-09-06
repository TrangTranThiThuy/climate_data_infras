with source_data as (

    select * from {{ source('airbyte_postgres','weather_underground_be') }}

),

renamed as (
    select 
        _airbyte_raw_id,
        _airbyte_generation_id,
        "UV" as uv,
        to_timestamp("Date", 'YYYY-MM-DD') as "date",
        "Gust" as gust,
        "Time" as time,
        ("Date" || ' ' || "Time")::timestamp as observed_at,
        "Wind" as wind,
        "Solar" as solar,
        "Speed" as speed,
        "Humidity" as humidity,
        "Pressure" as pressure,
        "Dew_Point" as dew_point,
        "Temperature" as temperature,
        "Precip__Rate_" as precip_rate,
        "Precip__Accum_" as precip_accum
    from source_data
)

select *
from renamed