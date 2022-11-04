Select 
    partition_date,
    {{ dbt_utils.surrogate_key(['JSON_EXTRACT:gameData:game:pk::string', 'plays.value:about:eventId::int', 'plays.value:about.ordinalNum::string '])}} as play_id,
    JSON_EXTRACT:gameData:game:pk::string as game_id,
    plays.value:about:dateTime::timestamp as event_timestamp,
    plays.value:about:eventId::int as event_id,
    plays.value:team.id:: int as event_team_id,
    plays.value:coordinates.x::int as x_coor,
    plays.value:coordinates.y::int as y_coor,
    plays.value:result.description::string as description,
    plays.value:result.event::string as event,
    plays.value:result.eventCode::string as event_code,
    plays.value:result.eventTypeId::string as event_type_id,
    plays.value:about.period::int as period,
    plays.value:about.periodType::string as period_type,
    plays.value:about.ordinalNum::string as period_s

from {{source('SNOWFLAKE_RAW', 'RAW_NHL_GAME_DATA')}}, table(flatten(JSON_EXTRACT:liveData.plays.allPlays)) plays

{% if is_incremental() %}
where partition_date = date('{{ run_started_at }}')
{% endif %}