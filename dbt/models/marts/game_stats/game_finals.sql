{%- set table_name = this -%}

Select  
        partition_date,
        game_id,
        game_relation_id,
        game_season,
        game_start,
        game_end,
        game_type,
        team_name,
        division_name,
        conference_name,
        home_away_status,
        sum(coalesce(goals_scored,0)) as goals_scored,
        sum(coalesce(overtime_goals_scored,0))  as overtime_goals_scored,
        sum(coalesce(assists,0)) as assists,
        sum(coalesce(shots_missed,0)) as shots_missed,
        sum(coalesce(shots_on_goal,0)) as shots_on_goal,
        sum(coalesce(goals_against,0)) as goals_against,
        sum(coalesce(overtime_goals_against,0)) as overtime_goals_against,
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
        sum(coalesce(shootout_shots_faced,0)) as shootout_shots_faced,
        case when sum(coalesce(goals_scored,0)) > sum(coalesce(goals_against,0)) then 1 else 0 end regulation_win,
        case when sum(coalesce(goals_scored,0)) < sum(coalesce(goals_against,0)) then 1 else 0 end regulation_loss,
        case when sum(coalesce(shootout_goals,0)) > sum(coalesce(shootout_goals_against,0)) then 1 else 0 end shootout_win,
        case when sum(coalesce(shootout_goals,0)) < sum(coalesce(shootout_goals_against,0)) then 1 else 0 end shootout_loss,
        case when sum(coalesce(overtime_goals_scored,0)) > sum(coalesce(overtime_goals_against,0)) then 1 else 0 end overtime_win,
        case when sum(coalesce(overtime_goals_scored,0)) < sum(coalesce(overtime_goals_against,0)) then 1 else 0 end overtime_loss,
        regulation_win + shootout_win + overtime_win as win,
        regulation_loss as loss,
        shootout_loss + overtime_loss as otl,
        case
            when win > 0 then 2
            when otl > 0 then 1 
            else 0
        end points
          
from {{ref('game_player_stats' )}}

{% if is_incremental() %}
where partition_date = date('{{ run_started_at }}')
{% endif %}

{{ dbt_utils.group_by(n=11) }}