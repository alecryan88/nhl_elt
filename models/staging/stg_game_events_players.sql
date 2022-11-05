Select  
      partition_date,
       {{ dbt_utils.surrogate_key(['game_id', 'event_id', 'period_s'])}} as play_id,
      game_id,
      game_season,
      event_id,
      players.value:player:id::string as player_id,
      players.value:playerType::string as player_type
  from (
    Select 
      partition_date,
      JSON_EXTRACT:gameData:game:pk::string as game_id,
      JSON_EXTRACT:gameData:game:season::string as game_season,
      plays.value:about:eventId::int as event_id,
      plays.value:players as players,
      plays.value:about.ordinalNum::string as period_s

    from {{source('nhl_api_source', 'nhl_api_game_events')}}, table(flatten(JSON_EXTRACT:liveData.plays.allPlays)) plays

    {% if is_incremental() %}
    where partition_date = date('{{ run_started_at }}')
    {% endif %}

  ), table(flatten(players)) players