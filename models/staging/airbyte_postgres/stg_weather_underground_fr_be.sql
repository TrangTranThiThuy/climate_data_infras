with source_data as (
    
    select * from {{ source('airbyte_postgres','weather_underground_fr_be') }}

),

renamed as (
    select 
        _airbyte_raw_id,
        _airbyte_generation_id,
        to_timestamp("Date", 'YYYY-MM-DD') as "date",
        "Time" as time,
        ("Date" || ' ' || "Time")::timestamp as observed_at,
        "Gust" as gust,
        "UV" as uv,
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
    where "Date" is not null 
        and "Time" is not null
)

select * from renamed