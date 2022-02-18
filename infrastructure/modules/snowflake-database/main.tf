/*
    This module creates a database and grants privileges required for:
        - USAGE
        - CREATE SCHEMA
*/

resource "snowflake_database" "database" {
  name                        = var.database_name
  comment                     = var.database_comment
  data_retention_time_in_days = (terraform.workspace == "default") ? 30 : 3
  # 30 days retention on default workspace, else 3; non-default workspaces only used during development
}

resource "snowflake_database_grant" "usage_on_database" {
  database_name = snowflake_database.database.name

  privilege         = "USAGE"
  roles             = var.roles_with_usage
  with_grant_option = false
}

resource "snowflake_database_grant" "create_schema_on_database" {
  database_name = snowflake_database.database.name

  privilege         = "CREATE SCHEMA"
  roles             = var.roles_with_create_schema
  with_grant_option = false
}
