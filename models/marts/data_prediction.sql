with table_mart as
(
    select *
    from {{ ref('int_weather_underground_union') }}
)

select * from table_mart
