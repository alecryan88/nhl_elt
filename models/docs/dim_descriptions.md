{% docs partition_date %} Partition column for game date. {% enddocs %}

{% docs game_id %} Unique identifier for each game. {% enddocs %}

{% docs conference_id %} Unique identifier for each conference. {% enddocs %}

{% docs conference_name %} The name of the conference. {% enddocs %}

{% docs division_id %} Unique identifier for each division. {% enddocs %}

{% docs division_name %} The name of the division. {% enddocs %}

{% docs team_id %} Unique identifier for each team. {% enddocs %}

{% docs play_id %} Unique identifier for each play. Surrogate key of game_id, event_id & period. {% enddocs %}

{% docs event_timestamp %} The timestamp of when the event occured. {% enddocs %}

{% docs event_id %} Unique id for each event in-game. Resets each period. {% enddocs %}

{% docs event_team_id %} The team_id that initiated the event. {% enddocs %}

{% docs x_coor %} The x-coordinate of where the event occured on the ice. {% enddocs %}

{% docs y_coor %} The y-coordinate of where the event occured on the ice. {% enddocs %}

{% docs description %} Text description of what occured in the event. {% enddocs %}

{% docs event %} The type of the event. {% enddocs %}

{% docs event_code %} Home team + event_id. {% enddocs %}

{% docs event_type_id %} The unique identifier for the type of event. {% enddocs %}

{% docs period %} The period of type integer. {% enddocs %}

{% docs period_s %} The period of type string. {% enddocs %}

{% docs period_type %} The period type. {% enddocs %}

{% docs game_season %} Unique identifier for the season in which the game was played. {% enddocs %}

{% docs player_id %} Unique identifier for each player. {% enddocs %}

{% docs player_type %} Text description of the players role in the event. {% enddocs %}

{% docs game_type %} The type of game. Can be R (Regular Season), PR (Preseason), A (All-Star Game) or P (Playoffs). {% enddocs %}

{% docs away_team_id %} The team_id of the away team. {% enddocs %}

{% docs home_team_id %} The team_id of the home team. {% enddocs %}

{% docs game_start %} The timestamp of when the game started. {% enddocs %}

{% docs game_end %} The timestamp of when the game ended. {% enddocs %}

{% docs game_state %} The state of the game. If batch job, the state should always = Final. {% enddocs %}

{% docs official_first_name %} The officials first name. {% enddocs %}

{% docs official_last_name %} The officials last name. {% enddocs %}

{% docs official_id %} The officials last name. {% enddocs %}

{% docs official_type %} Distinguishes a linesmnan from a referee. {% enddocs %}

{% docs home_away_status %} Text column describing Home/Away orientation. {% enddocs %}

{% docs active_status %} Text column describing whether a player is active or scratched. {% enddocs %}

{% docs jersey_number %} The players jersey number. {% enddocs %}

{% docs full_name %} The players full name. {% enddocs %}

{% docs roster_status %} Flags whether a player is on the corresponding team's NHL roster. {% enddocs %}

{% docs pos_abv %} The players abbreviated position. {% enddocs %}

{% docs pos_name %} The players position name. {% enddocs %}

{% docs pos_type %} The players position type. Groups C, LW & RW into Forward. {% enddocs %}

{% docs team_name %} The name of the team. {% enddocs %}

{% docs venue_id %} The id of the venue. {% enddocs %}

{% docs tri_code %} The id of the venue. {% enddocs %}

{% docs team_active_status %} Indicates whether team is active or inactive. {% enddocs %}

{% docs venue_city %} The city in which the venue is located. {% enddocs %}

{% docs venue_name %} The name of the venue. {% enddocs %}

{% docs venue_timezone %} The timezone in which the venue is located. {% enddocs %}

{% docs venue_timezone_offset %} The hour offset from UTC time from which the venue is located. {% enddocs %}

{% docs birth_city %} The city in which the player was born. {% enddocs %}

{% docs birth_country %} The country in which the player was born. {% enddocs %}

{% docs birth_state_province %} The state or province in which the player was born. {% enddocs %}

{% docs player_first_name %} The player's first name. {% enddocs %}

{% docs player_last_name %} The player's last name. {% enddocs %}

{% docs height_inches %} The player's height in inches.q {% enddocs %}

{% docs nationality %} The player's nationality. {% enddocs %}

{% docs handedness %} The player's handedness. {% enddocs %}

{% docs weight %} The player's weight. {% enddocs %}