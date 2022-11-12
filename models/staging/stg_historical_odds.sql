with games as (
  Select 
        JSON_EXTRACT:timestamp::timestamp as timestamp,
        JSON_EXTRACT:previous_timestamp::timestamp as previous_timestamp,
        JSON_EXTRACT:next_timestamp::timestamp as next_timestamp,
        games.value:away_team::string as away_team_name,
        games.value:home_team::string as home_team_name,
        games.value:id::string as id,
        games.value:sport_key::string as sport_key,
        games.value:commence_time::timestamp as game_start,
        games.value:bookmakers as bookmakers
        
  from {{source('nhl_api_odds', 'nhl_api_odds')}}, table(flatten(JSON_EXTRACT:data)) as games

  ),
  
  
bookmakers as (
  
  Select 
          timestamp,
          previous_timestamp,
          next_timestamp,
          away_team_name,
          home_team_name,
          id,
          sport_key,
          game_start,
          bookmakers_flatten.value:key::string as bookmaker,
          bookmakers_flatten.value:markets as markets

  from games, table(flatten(bookmakers)) as bookmakers_flatten
  ),
  
markets as (  
  
  Select
        id,
        timestamp,
        previous_timestamp,
        next_timestamp,
        away_team_name,
        home_team_name,
        sport_key,
        game_start,
        bookmaker,
        markets_flatten.value:key::string as market,
        markets_flatten.value:outcomes as outcomes

  from bookmakers, table(flatten(markets)) as markets_flatten
  
  ),
  
odds as (
  Select
          {{ dbt_utils.surrogate_key(['id', 'bookmaker', 'market'])}} as odds_id,
          timestamp,
          previous_timestamp,
          next_timestamp,
          case
            when home_team_name = 'St Louis Blues' then 'St. Louis Blues' 
            else home_team_name 
          end as home_team_name,
          case
            when away_team_name = 'St Louis Blues' then 'St. Louis Blues' 
            else away_team_name 
          end as away_team_name,
          sport_key,
          game_start,
          game_start::date as game_start_date,
          bookmaker,
          market,
          outcomes_flatten.value:name::string as name,
          outcomes_flatten.value:price::decimal(10,2) as decimal_odds,
          {{ decimal_to_american_odds('decimal_odds') }} as american_odds,
          {{ decimal_odds_to_prob('decimal_odds') }} as prob
          
  from markets, table(flatten(outcomes)) as outcomes_flatten

)

Select
        odds_id,
        {{ dbt_utils.surrogate_key(['game_start_date', 'home_team_name', 'away_team_name'])}} as game_relation_id,
        timestamp,
        previous_timestamp,
        next_timestamp,
        home_team_name,
        away_team_name,
        sport_key,
        game_start,
        game_start_date,
        bookmaker,
        market,
        name,
        decimal_odds,
        american_odds,
        prob
from odds