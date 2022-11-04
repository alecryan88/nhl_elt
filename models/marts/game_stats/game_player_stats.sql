{%- set table_name = this -%}

Select 
        d.partition_date,
        d.game_id,
        m.game_season,
        m.game_start,
        m.game_end,
        m.game_type,
        full_name,
        t.team_name,
        div.division_name,
        conf.conference_name,
        d.active_status,
        roster_status,
        jersey_number,
        pos_abv,
        handedness as test_column,
        home_away_status,
        sum(coalesce(goals_scored,0))  as goals_scored,
        sum(coalesce(overtime_goals_scored,0))  as overtime_goals_scored,
        sum(coalesce(assists,0)) as assists,
        sum(coalesce(shots_missed,0)) as shots_missed,
        sum(coalesce(shots_on_goal,0)) as shots_on_goal,
        sum(coalesce(goals_against,0)) as goals_against,
        sum(coalesce(overtime_goals_against,0))  as overtime_goals_against,
        sum(coalesce(saves,0)) as saves,
        sum(coalesce(hits,0)) as hits,
        sum(coalesce(received_hits,0)) as received_hits,
        sum(coalesce(had_shots_blocked,0)) as had_shots_blocked,
        sum(coalesce(blocked_shots,0))as blocked_shots,
        sum(coalesce(faceoffs_won,0)) as faceoffs_won,
        sum(coalesce(faceoffs_lost,0)) as faceoffs_lost,
        sum(coalesce(takeaways,0)) as takeaways,
        sum(coalesce(giveaways,0)) as giveaways,
        sum(coalesce(shootout_goals,0)) as shootout_goals,
        sum(coalesce(shootout_shots,0))  as shootout_shots,
        sum(coalesce(shootout_goals_against,0)) as shootout_goals_against,
        sum(coalesce(shootout_saves,0)) as shootout_saves,
        sum(coalesce(shootout_shots_faced,0)) as shootout_shots_faced

from {{ref('stg_game_roster')}} d

left join {{ref('int_game_player_stats')}} g 
on g.player_id = d.player_id and g.game_id = d.game_id 

left join {{ref('stg_game_metadata')}} m
on m.game_id = d.game_id 

left join {{ref('stg_game_teams')}} t 
on t.team_id = d.team_id  and t.game_id = d.game_id

left join {{ref('stg_game_divisions')}} div 
on t.team_id = div.team_id  and t.game_id = div.game_id

left join {{ref('stg_game_conferences')}} conf 
on div.division_id = conf.division_id  and div.game_id = conf.game_id

{% if is_incremental() %}
where d.partition_date = date('{{ run_started_at }}')
{% endif %}

{{ dbt_utils.group_by(n=16) }}