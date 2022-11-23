select 
    partition_date,
    JSON_EXTRACT:gameData:game:pk::string as game_id,
    teams.value:division.id::int as division_id,
    teams.value:division.name::string as division_name,
    teams.value:id::int as team_id
   
from {{source('nhl_api_source', 'nhl_api_game_events')}}, table(flatten(JSON_EXTRACT:gameData:teams)) teams

{% if is_incremental() %}
where partition_date = date('{{ run_started_at }}')
{% endif %}