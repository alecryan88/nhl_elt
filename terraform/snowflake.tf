resource "snowflake_database" "db" {
  provider = snowflake
  name     = "NHL"
  comment  = "Database created for snowflake by terraform."
}

resource "snowflake_schema" "schema" {
  provider = snowflake
  database = snowflake_database.db.name
  name     = "STAGE"
  comment  = "Schema for staging data created by terraform."
}

resource "snowflake_table" "table" {
  for_each = local.loader_names
  database = snowflake_schema.schema.database
  schema   = snowflake_schema.schema.name
  name     = each.value
  comment  = "A table."

  column {
    name     = "FILE_NAME"
    type     = "varchar(100)"
    nullable = false
  }

  column {
    name     = "JSON_EXTRACT"
    type     = "variant"
    nullable = false
  }

  column {
    name     = "LOADED_AT"
    type     = "timestamp"
    nullable = false
  }

}

resource "snowflake_storage_integration" "storage_integration" {
  name    = "${local.project_name}-integration"
  comment = "A storage integration."
  type    = "EXTERNAL_STAGE"

  enabled = true

  storage_allowed_locations = values(tomap({
        for key, val in local.loader_names : key=> "s3://${val}"
    }))
  storage_provider          = "S3"
  storage_aws_role_arn      = "${local.role_arn}_snowflake_acccess_role"
}

resource "snowflake_stage" "stage" {
  for_each = local.loader_names
  name                = "${each.value}-stage"
  database            = snowflake_database.db.name
  schema              = snowflake_schema.schema.name
  storage_integration = snowflake_storage_integration.storage_integration.name

  url         = "s3://${each.value}"
  file_format = "TYPE = 'JSON'"
}

resource "time_sleep" "wait_15_seconds" {
  #Allows enough time for external_id to update in role
  create_duration = "15s"
}

resource "snowflake_pipe" "pipes" {
  for_each = local.loader_names
  database = snowflake_database.db.name
  schema   =  snowflake_schema.schema.name
  name     = "${each.value}-pipe"

  comment = "A pipe."

  copy_statement = <<EOH

        copy into ${snowflake_database.db.name}.${snowflake_schema.schema.name}."${each.value}"
        from (

        Select         
            METADATA$FILENAME as file_name,
            $1 as json_extract,
            current_timestamp() as loaded_at

        from @${snowflake_database.db.name}.${snowflake_schema.schema.name}."${each.value}-stage"
        )
  EOH

  auto_ingest    = true
  depends_on = [
    snowflake_storage_integration.storage_integration,
    time_sleep.wait_15_seconds,
    snowflake_stage.stage
  ]
}