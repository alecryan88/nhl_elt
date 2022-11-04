Select 
    partition_date,
    JSON_EXTRACT:gameData:game:pk::string as game_id,
    player.value:id::string as player_id, 
    player.value:birthCity::string as birth_city,
    player.value:birthCountry::string as birth_country,
    player.value:birthDate::date as birth_date,
    player.value:birthStateProvince::string as birth_state_province,
    player.value:firstName::string as first_name,
    player.value:lastName::string as last_name,
    (trim(split_part(player.value:height::string, '''', 1))::int * 12) + trim(split_part(split_part(player.value:height::string, '''', 2)::string, '"', 1))::int as height_inches,
    player.value:nationality::string as nationality,
    player.value:shootsCatches::string as handedness,
    player.value:weight::int as weight,
    '{{ run_started_at }}' as last_updated_dbt
        

from {{source('SNOWFLAKE_RAW', 'RAW_NHL_GAME_DATA')}}, table(flatten(JSON_EXTRACT:gameData:players)) player

{% if is_incremental() %}
where partition_date = date('{{ run_started_at }}')
{% endif %}