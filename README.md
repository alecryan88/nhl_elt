# NHL Data Pipeline

An end-to-end data application to ingest NHL game data.

## Overview

The National Hockey League (NHL) provides an open API for requesting game statistics.

In this project, the game data is collected via the NHL Open API and staged in an Amazon S3 bucket. S3 then sends a notification through SQS to a Snowpipe configured in Snowflake. The snowpipe then ingests that new file into the Snowflake table in near-real-time. 

dbt cloud triggers on a cron schedule to transform the NHL game data into dimensional models for analytics.

## Motivation

The motivation for this project is primarily to gain experience using dbt, AWS & Snowflake. A secondary goal is to showcase a very simple way to get up and running with an ELT framework.

## Architecture
...

## Prerequisites
To get up and running with this project, a few things are required: 
1. Create AWS profile and grant necessary permissions to a user / role.
2. Create a Snowflake Account and Resources
3. Create an S3 bucket w/ Event Notifications Enabled
4. Create a Snowflake Storage Integration w/ S3
5. dbt Cloud Account Connected to your Snowflake Warehouse