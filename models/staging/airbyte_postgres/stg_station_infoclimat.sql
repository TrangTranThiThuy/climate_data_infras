with source_data as (

    select * from {{ source('airbyte_postgres','station_infoclimat') }}

)

select *
from source_data