Select 
    partition_date,
    JSON_EXTRACT:gameData:game:pk::string as game_id,
    JSON_EXTRACT:gameData:game:season::string as game_season,
    trim(split_part(officials.value:official.fullName::string,' ',1))  as official_first_name,
    trim(split_part(officials.value:official.fullName::string,' ',2))  as official_last_name,
    officials.value:official.id::int as official_id,
    officials.value:officialType::string as official_type
    
from {{source('nhl_api_source', 'nhl_api_game_events')}}, table(flatten(JSON_EXTRACT:liveData:boxscore:officials)) officials

{% if is_incremental() %}
where partition_date = date('{{ run_started_at }}')
{% endif %}