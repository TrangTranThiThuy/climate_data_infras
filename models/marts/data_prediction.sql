{{
    config(
        materialized='table',
        schema='marts',
        indexes=[
            {'columns': ['station_id', 'observed_at']}]
            )
}}

with 
station_pro as
(
    select 
        "station_id",
        "station_name",
        "observed_at",
        "temperature",
        "pressure",
        "humidity",
        "speed",
        "source"
        -- "wind"
    from {{ ref('int_station_pro') }}
),

station_amateur as 
(
    select 
        "station_id",
        "station_name",
        "observed_at",
        "temperature",
        "pressure",
        "humidity",
        "speed",
        "source"
        -- "wind"
    from {{ref('int_weather_underground_joined')}}
)

select * from station_pro
union all
select * from station_amateur
