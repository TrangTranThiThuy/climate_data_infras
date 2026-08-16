with source_data as (

    select * from {{ source('airbyte_postgres','weather_underground_fr') }}

)

select *
from source_data