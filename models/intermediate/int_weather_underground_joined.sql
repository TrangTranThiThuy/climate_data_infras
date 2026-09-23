with 

weather_data_underground as (
    select 
        _airbyte_raw_id,
        _airbyte_generation_id,
        "date",
        "time",
        "observed_at",
        "gust",
        "uv",
        "wind",
        "solar",
        "speed",
        "humidity",
        "pressure",
        "dew_point",
        "temperature",
        "precip_rate",
        "precip_accum",
        "station_name"
    from {{ref('stg_weather_underground_fr_be')}}
),

station_ref as (
    select 
        "weather_station_id", 
        "station_name",
        "latitude",
        "longitude",
        "elevation",
        "city",
        "state",
        "hardware",
        "software"
    from {{ref ('weather_stations_ref')}}
),

weather_data_pro as(
    select 
        'observed_at',
        'temperature',
        'humidity',
        'pressure',
        'speed',
        'wind',
        'station_id'
    from {{ref('stg_infoclimat__hourly')}}
)

select 
    wd.observed_at,
    wd.temperature,
    wd.humidity,
    wd.pressure,
    wd.speed,
    wd.wind,
    sr.station_name,
    sr.weather_station_id as station_id,
    'weather_underground' as source

from weather_data_underground as wd 
left join station_ref as sr
    on wd.station_name = sr.station_name
