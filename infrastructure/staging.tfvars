#############################################
##                Snowflake                ##
#############################################

SNOWFLAKE_rbac_enabled = false # Enabled on master only

SNOWFLAKE_database_raw_base_name           = "STAGING_RAW"
SNOWFLAKE_database_raw_usage_on_roles      = ["AIRFLOW_STAGING_SA"]
SNOWFLAKE_database_raw_create_schema_roles = ["AIRFLOW_STAGING_SA"]

SNOWFLAKE_database_sources_enabled = false # Enabled on master only
