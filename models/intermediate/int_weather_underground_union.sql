with belgium as (

    select
        observed_at,
        temperature,
        humidity,
        pressure,
        speed,
        wind,
        gust,
        solar,
        uv,
        dew_point,
        precip_rate,
        precip_accum,
        'BE' as country,
        'weather_underground' as source

    from {{ ref('stg_weather_underground_be') }}

),

france as (

    select
        observed_at,
        temperature,
        humidity,
        pressure,
        speed,
        wind,
        gust,
        solar,
        uv,
        dew_point,
        precip_rate,
        precip_accum,
        'FR' as country,
        'weather_underground' as source

    from {{ ref('stg_weather_underground_fr') }}

)

select * from belgium

union all

select * from france