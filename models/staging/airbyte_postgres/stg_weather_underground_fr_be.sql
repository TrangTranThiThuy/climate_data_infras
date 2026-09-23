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
        "UV" as uv,
        "Wind" as wind,
        nullif(regexp_replace("Gust", '[^0-9.-]', '', 'g'), '')::numeric as gust,
        nullif(regexp_replace("Solar", '[^0-9.-]', '', 'g'), '')::numeric as solar,
        nullif(regexp_replace("Speed", '[^0-9.-]', '', 'g'), '')::numeric as speed,
        nullif(regexp_replace("Humidity", '[^0-9.-]', '', 'g'), '')::numeric as humidity,
        nullif(regexp_replace("Pressure", '[^0-9.-]', '', 'g'), '')::numeric as pressure,
        nullif(regexp_replace("Dew_Point", '[^0-9.-]', '', 'g'), '')::numeric as dew_point,
        nullif(regexp_replace("Temperature", '[^0-9.-]', '', 'g'), '')::numeric as temperature,
        nullif(regexp_replace("Precip__Rate_", '[^0-9.-]', '', 'g'), '')::numeric as precip_rate,
        nullif(regexp_replace("Precip__Accum_", '[^0-9.-]', '', 'g'), '')::numeric as precip_accum,

        case 
            when "_ab_source_file_url" like '%Ichtegem%' then 'WeerstationBS'
            when "_ab_source_file_url" like '%Madeleine%' then 'La Madeleine'
        else null 
        end as station_name

    from source_data
    where "Date" is not null 
        and "Time" is not null
)

select * 
from renamed