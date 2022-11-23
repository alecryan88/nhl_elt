DROP TABLE IF EXISTS nhl_api_game_events;
CREATE TABLE nhl_api_game_events (
  file_name varchar(200),
  partition_date date,
  game_id varchar(50),
  json_extract variant
);

DROP PIPE nhl_api_game_events ;
create pipe nhl_api_game_events 
auto_ingest = true
as 
copy into nhl_api_game_events 
from (

  Select         
        METADATA$FILENAME as file_name,
        date(split_part(split_part(METADATA$FILENAME, '/', 2),'=',2)) as partition_date,
        split_part(split_part(METADATA$FILENAME, '/', 3), '.',1) as game_id,
        $1 as json_extract

  from @NHL_DB.RAW.NHL_API_GAME_EVENTS
);

-- Backfill any files that were loaded prior to creating snow pipe. Works best for batch jobs.
INSERT INTO nhl_api_game_events (
Select         
        METADATA$FILENAME as file_name,
        date(split_part(split_part(METADATA$FILENAME, '/', 2),'=',2)) as partition_date,
        split_part(split_part(METADATA$FILENAME, '/', 3), '.',1) as game_id,
        $1 as json_extract

  from @NHL_DB.RAW.NHL_API_GAME_EVENTS
  );