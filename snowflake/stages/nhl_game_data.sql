CREATE OR REPLACE STORAGE INTEGRATION nhl_analytics_int
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
STORAGE_AWS_ROLE_ARN='arn:aws:iam::647410971427:role/snowflake-access-role'
ENABLED = TRUE
STORAGE_ALLOWED_LOCATIONS = ('s3://nhl-analytics/');

DESC INTEGRATION nhl_analytics_int

create or replace file format json_format
  type = json;
  
create or replace stage NHL_DB.RAW.NHL_API_GAME_EVENTS
file_format = json_format
storage_integration = nhl_analytics_int
url = 's3://nhl-analytics/nhl-game-data';