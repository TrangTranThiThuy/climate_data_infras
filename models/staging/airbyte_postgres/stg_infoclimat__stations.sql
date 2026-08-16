with source_data as (

    select * from {{ source('airbyte_postgres','station_infoclimat') }}

),

unnested as (
    select 
        _airbyte_raw_id,
        station.value ->> 'id' as station_id,
        station.value ->> 'name' as station_name,
        (station.value ->> 'latitude')::numeric as latitude,
        (station.value ->> 'longitude')::numeric as longitude,
        (station.value ->> 'elevation')::int as elevation,
        station.value ->> 'type' as station_type
    from source_data,
        jsonb_array_elements(stations) as station(value)

)

select *
from unnested