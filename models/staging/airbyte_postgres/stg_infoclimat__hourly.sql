with source as (
    select * from {{ source('airbyte_postgres', 'station_infoclimat') }}
),

by_station as (
    select
        _airbyte_raw_id,
        station_entry.key   as station_id,       -- e.g. "07015"
        station_entry.value as readings           -- array of hourly records
    from source,
         jsonb_each(hourly) as station_entry
    where station_entry.key <> '_params'          -- skip the metadata key
),

unnested as (
    select
        _airbyte_raw_id,
        station_id,
        (reading.value ->> 'dh_utc')::timestamp as observed_at,
        (reading.value ->> 'temperature')::numeric as temperature,
        (reading.value ->> 'pression')::numeric as pressure,
        (reading.value ->> 'humidite')::numeric as humidity,
        (reading.value ->> 'vent_moyen')::numeric as wind_speed,
        (reading.value ->> 'vent_direction')::numeric as wind_direction,
        (reading.value ->> 'pluie_1h')::numeric as rain_1h
    from by_station,
         jsonb_array_elements(readings) as reading(value)
)

select * from unnested