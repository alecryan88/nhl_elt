Select 
    partition_date,
    JSON_EXTRACT:gameData:game:pk::string as game_id,
    teams.value:id::int as team_id,
    teams.value:venue.id::int as  venue_id,
    teams.value:venue.city::string as venue_city,
    teams.value:venue.name::string as venue_name,
    teams.value:venue:timeZone.id::string as venue_timezone,
    teams.value:venue:timeZone.offset::int as venue_timezone_offset
   
from {{source('nhl_api_source', 'nhl_api_game_events')}}, table(flatten(JSON_EXTRACT:gameData:teams)) teams

{% if is_incremental() %}
where partition_date = date('{{ run_started_at }}')
{% endif %}