with source_data as (

    select * from {{ source('airbyte_postgres','station_infoclimat') }}

),

unnested as (
    select 
        _airbyte_raw_id,
        metadata.value ->> 'temperature' as temperature,
        metadata.value ->> 'pression' as pressure,
        metadata.value ->> 'humidite' as humidity,
        metadata.value ->> 'point_de_rosee' as dew_point,
        metadata.value ->> 'visibilite' as visibility,
        metadata.value ->> 'vent_moyen' as wind_speed,
        metadata.value ->> 'vent_rafales' as wind_gust,
        metadata.value ->> 'vent_direction' as wind_direction,
        metadata.value ->> 'pluie_1h' as rain_1h,
        metadata.value ->> 'pluie_24h' as rain_24h,
        metadata.value ->> 'neige_au_sol' as rain_snow,
        metadata.value ->> 'nebulosite' as cloud_cover,
        metadata.value ->> 'temps_omm' as weather_condition
    from source_data,
        jsonb_array_elements(metadata) as metadata(value)
)


select * 
from unnested