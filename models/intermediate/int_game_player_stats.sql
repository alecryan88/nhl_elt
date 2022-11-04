Select  
         a.partition_date,
         a.play_id,
         a.GAME_ID,
         a.event_timestamp,
         a.PERIOD_TYPE,
         a.PERIOD,
         a.EVENT_ID,
         b.player_id,
         sum(case when EVENT_TYPE_ID = 'GOAL' and PLAYER_TYPE = 'Scorer' and PERIOD_S not in ('SO', 'OT') then 1 else 0 end) goals_scored,
         sum(case when EVENT_TYPE_ID = 'GOAL' and PLAYER_TYPE = 'Scorer' and PERIOD_S = 'OT' then 1 else 0 end) overtime_goals_scored,
         sum(case when EVENT_TYPE_ID = 'GOAL' and PLAYER_TYPE = 'Assist' and PERIOD_S != 'SO' then 1 else 0 end) assists,
         sum(case when EVENT_TYPE_ID = 'GOAL' and PLAYER_TYPE = 'Goalie' and PERIOD_S not in ('SO', 'OT') then 1 else 0 end) goals_against,
         sum(case when EVENT_TYPE_ID = 'GOAL' and PLAYER_TYPE = 'Goalie' and PERIOD_S = 'OT' then 1 else 0 end) overtime_goals_against,
         sum(case when EVENT_TYPE_ID = 'SHOT' and PLAYER_TYPE = 'Shooter' and PERIOD_S != 'SO' then 1 else 0 end) + sum(case when EVENT_TYPE_ID = 'GOAL' and PLAYER_TYPE = 'Scorer' then 1 else 0 end) shots_on_goal,
         sum(case when EVENT_TYPE_ID = 'MISSED_SHOT' and PLAYER_TYPE = 'Shooter' and PERIOD_S != 'SO' then 1 else 0 end) shots_missed,
         sum(case when EVENT_TYPE_ID = 'SHOT' and PLAYER_TYPE = 'Goalie' and PERIOD_S != 'SO' then 1 else 0 end) saves,
         sum(case when EVENT_TYPE_ID = 'HIT' and PLAYER_TYPE = 'Hitter' then 1 else 0 end) hits,
         sum(case when EVENT_TYPE_ID = 'HIT' and PLAYER_TYPE = 'Hittee' then 1 else 0 end) received_hits,
         sum(case when EVENT_TYPE_ID = 'BLOCKED_SHOT' and PLAYER_TYPE = 'Shooter' then 1 else 0 end) had_shots_blocked,
         sum(case when EVENT_TYPE_ID = 'BLOCKED_SHOT' and PLAYER_TYPE = 'Blocker' then 1 else 0 end) blocked_shots,
         sum(case when EVENT_TYPE_ID = 'FACEOFF' and PLAYER_TYPE = 'Winner' then 1 else 0 end) faceoffs_won,
         sum(case when EVENT_TYPE_ID = 'FACEOFF' and PLAYER_TYPE = 'Loser' then 1 else 0 end) faceoffs_lost,
         sum(case when EVENT_TYPE_ID = 'TAKEAWAY' then 1 else 0 end) takeaways,
         sum(case when EVENT_TYPE_ID = 'GIVEAWAY' then 1 else 0 end) giveaways,
         sum(case when EVENT_TYPE_ID = 'GOAL' and PLAYER_TYPE = 'Scorer' and PERIOD_S = 'SO' then 1 else 0 end) shootout_goals,
         sum(case when EVENT_TYPE_ID in ('SHOT', 'MISSED_SHOT') and PLAYER_TYPE = 'Shooter' and PERIOD_S = 'SO' then 1 else 0 end) + sum(case when EVENT_TYPE_ID = 'GOAL' and PLAYER_TYPE = 'Scorer' and PERIOD_S = 'SO' then 1 else 0 end) shootout_shots,
         sum(case when EVENT_TYPE_ID = 'GOAL' and PLAYER_TYPE = 'Goalie' and PERIOD_S = 'SO' then 1 else 0 end) shootout_goals_against,
         sum(case when EVENT_TYPE_ID in ('SHOT', 'MISSED_SHOT') and PLAYER_TYPE = 'Goalie' and PERIOD_S = 'SO' then 1 else 0 end) shootout_saves,
         sum(case when EVENT_TYPE_ID = 'GOAL' and PLAYER_TYPE = 'Goalie' and PERIOD_S = 'SO' then 1 else 0 end) + sum(case when EVENT_TYPE_ID in ('SHOT', 'MISSED_SHOT') and PLAYER_TYPE = 'Goalie' and PERIOD_S = 'SO' then 1 else 0 end) shootout_shots_faced

  from {{ref ('stg_game_events')}} a

  left join {{ref ('stg_game_events_players')}} b 
  on a.play_id = b.play_id
  and a.partition_date = b.partition_date

  {% if is_incremental() %}
  where a.partition_date = date('{{ run_started_at }}')
  {% endif %}

 {{ dbt_utils.group_by(n=8) }}
