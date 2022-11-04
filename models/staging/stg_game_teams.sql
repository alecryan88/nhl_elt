Select 
    partition_date,
    JSON_EXTRACT:gameData:game:pk::string as game_id,
    teams.value:id::int as team_id,
    teams.value:name::string as team_name,
    teams.value:division.id::int as division_id,
    teams.value:venue.id::int as  venue_id,
    teams.value:officialSiteUrl::string as url,
    teams.value:triCode::string as team_tri_code,
    teams.value:active::boolean as team_active_status
   
from {{source('SNOWFLAKE_RAW', 'RAW_NHL_GAME_DATA')}}, table(flatten(JSON_EXTRACT:gameData:teams)) teams

{% if is_incremental() %}
where partition_date = date('{{ run_started_at }}')
{% endif %}