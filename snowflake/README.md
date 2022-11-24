# Ingesting Data to Snowflake
Data is loaded into an S3 bucket via an AWS Lambda Function. Now that the data has arrived in the bucket, we need a way to transfer it to Snowflake. This project leverages Snowpipes to ingest data from S3 to Snowflake.

 We can trigger this transfer as files are loaded into S3 by firing off an event notification to an AWS SQS queue that our Snowpipe is listening to. This will allow us to auto-ingest data from S3 into our snowflake table in near-real-time.

 ## Setup 
 There are few requirements to configure this portion of the project.
 1. Create an AWS S3 storage integration
 2. Create an AWS IAM role that has the necessary permissions to connect to your S3 bucket. 

## Creating a Snowflake Stage
We first need to create an external stage in snowflake that is connected to our S3 bucket. This simply specifies where files are stored so that said data can be loaded into a table. 

The SQL to create the stage is here: 
``` sh 
#stages/nhl_game_data.sql

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
```
Now that the stage is created, you can simply query from the stage to view the files stored in S3.

## Creating a Snowpipe
Now that we have a stage created, we need to create a Snowpipe that can `auto-ingest` data from the S3 bucket configured in the stage as new files are loaded.

``` sh
#snowpipes/nhl_api_game_events.sql 

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
```

Now that we've created a snowpipe, our table will automatically updated with any new files that arrive in the future. This unfortunately does not backfill any historical data that we may have existing in our S3 Bucket.

## Backfilling Historical Data
In order to backfill historical data, we can simply run an insert statement: 
```sh 
#snowpipes/nhl_api_game_events.sql 

INSERT INTO nhl_api_game_events (
Select         
        METADATA$FILENAME as file_name,
        date(split_part(split_part(METADATA$FILENAME, '/', 2),'=',2)) as partition_date,
        split_part(split_part(METADATA$FILENAME, '/', 3), '.',1) as game_id,
        $1 as json_extract

  from @NHL_DB.RAW.NHL_API_GAME_EVENTS
  );
  ```