with source_data as (

    select * from {{source_data('airbyte_postgres','weather_underground_fr')}}

)

select *
from source_data