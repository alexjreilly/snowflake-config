#############################################
##                Snowflake                ##
#############################################

SNOWFLAKE_database_raw_base_name           = "RAW"
SNOWFLAKE_database_raw_usage_on_roles      = ["AIRFLOW", "DEV_TRANSFORMER", "LOADER", "TRANSFORMER"]
SNOWFLAKE_database_raw_create_schema_roles = ["AIRFLOW", "LOADER", "STITCH", "SEGMENT"]
SNOWFLAKE_rbac_enabled                     = true # Enabled on master only

SNOWFLAKE_rbac_users_sa = {
  # Additional 'roles_inherited' list option determines which custom role privileges, the user role will inherit

  # ========== Service account users ========== #

  "AIRFLOW" = {
    comment           = "Airflow service account"
    default_role      = "AIRFLOW"
    default_warehouse = "AIRFLOW"
    disabled          = false
    display_name      = "Airflow"
    login_name        = "AIRFLOW"
    roles_inherited   = ["LOADER"]
  },

  "AIRFLOW_DEV_SA" = {
    comment           = "Airflow service account (dev)"
    default_role      = "AIRFLOW_DEV_SA"
    default_warehouse = "AIRFLOW_DEV_SA"
    disabled          = false
    display_name      = "AIRFLOW_DEV_SA"
    login_name        = "AIRFLOW_DEV_SA"
    roles_inherited   = ["LOADER"]
  },

  "AIRFLOW_STAGING_SA" = {
    comment           = "Airflow service account (staging)"
    default_role      = "AIRFLOW_STAGING_SA"
    default_warehouse = "AIRFLOW_STAGING_SA"
    disabled          = false
    display_name      = "AIRFLOW_STAGING_SA"
    login_name        = "AIRFLOW_STAGING_SA"
    roles_inherited   = ["LOADER"]
  },

  "CI" = {
    comment           = "CI"
    default_role      = "CI"
    default_warehouse = "CI"
    disabled          = false
    display_name      = "CI"
    login_name        = "CI"
    roles_inherited   = ["DBT_ANALYTICS", "DEV_TRANSFORMER"]
  },

  "DBT" = {
    comment           = "DBT"
    default_role      = "DBT"
    default_warehouse = "DBT"
    disabled          = false
    display_name      = "DBT"
    login_name        = "DBT"
    roles_inherited   = ["LOADER", "TRANSFORMER"]
  },

  "DBT_DEV" = {
    comment           = "DBT Dev for CI and Testing builds"
    default_role      = "DEV_TRANSFORMER"
    default_warehouse = "DEV"
    disabled          = false
    display_name      = "DBT_DEV"
    login_name        = "DBT_DEV"
    roles_inherited   = ["LOADER", "DEV_TRANSFORMER"]
  },

  "ETL_DEV" = {
    comment           = "ETL Development"
    default_role      = "DEV_TRANSFORMER"
    default_warehouse = "DEV"
    disabled          = false
    display_name      = "ETL Development"
    login_name        = "ETL_DEV"
    name              = "ETL_DEV"
    roles_inherited   = ["ENGINEER"]
  },

  "FIVETRAN" = {
    comment           = "Fivetran ELT Tool"
    default_namespace = "FIVETRAN"
    default_role      = "FIVETRAN"
    default_warehouse = "FIVETRAN"
    disabled          = false
    display_name      = "FIVETRAN"
    login_name        = "FIVETRAN"
    roles_inherited   = ["LOADER"]
  },

  "LOOKER" = {
    comment           = "Looker BI tool"
    default_role      = "LOOKER"
    default_warehouse = "LOOKER"
    disabled          = false
    display_name      = "Looker"
    login_name        = "LOOKER"
    roles_inherited   = ["DBT_ANALYTICS", "REPORTER"]
  },

  "LOOKER_REPORTING" = {
    comment           = "Looker service account for reporting instance"
    default_role      = "LOOKER_REPORTING"
    default_warehouse = "LOOKER"
    disabled          = false
    display_name      = "LOOKER_REPORTING"
    login_name        = "LOOKER_REPORTING"
    roles_inherited   = ["DBT_ANALYTICS", "REPORTER"]
  },

  "SALESFORCE" = {
    comment           = "Salesforce service account"
    default_role      = "SALESFORCE"
    default_warehouse = "SALESFORCE"
    disabled          = false
    display_name      = "SALESFORCE"
    email             = "salesforceadmin@.co"
    login_name        = "SALESFORCE"
    roles_inherited   = ["REPORTER"]
  },

  "SEGMENT" = {
    comment           = "Segment service account"
    default_role      = "SEGMENT"
    default_warehouse = "SEGMENT"
    disabled          = false
    display_name      = "SEGMENT"
    login_name        = "SEGMENT"
    roles_inherited   = ["LOADER"]
  },

  "STITCH" = {
    comment           = "Stitch ETL/ELT Tool."
    default_role      = "STITCH"
    default_warehouse = "STITCH"
    disabled          = false
    display_name      = "Stitch"
    login_name        = "STITCH"
    name              = "STITCH"
    roles_inherited   = ["LOADER"]
  },

}

SNOWFLAKE_rbac_users = {
  # Additional 'roles_inherited' list option determines which custom role privileges, the user role will inherit

  # ==========  users ========== #

  "ALEXREILLY" = {
    comment           = "Data Engineer"
    default_role      = "ALEXREILLY"
    default_warehouse = "ENGINEER_XS"
    disabled          = false
    display_name      = "Alex Reilly"
    email             = "alex.reilly@xxx.com"
    first_name        = "Alex"
    last_name         = "Reilly"
    login_name        = "ALEXREILLY"
    roles_inherited   = ["ENGINEER"]
  },

  "JOEBLOGSS" = {
    comment           = "Data Scientist"
    default_role      = "JOEBLOGGS"
    default_warehouse = "SCIENTIST_XS"
    disabled          = false
    display_name      = "Joe Bloggs"
    email             = "joe.bloggs@xxx.com"
    first_name        = "Joe"
    last_name         = "Bloggs"
    login_name        = "JOEBLOGSS"
    roles_inherited   = ["SCIENTIST_INSIGHTS"]
  },

  "JILLBLOGGS" = {
    comment           = "Analyst"
    default_role      = "JILLBLOGGS"
    default_warehouse = "ANALYST_XS"
    disabled          = false
    display_name      = "Jill Bloggs"
    email             = "jill.bloggs@xxx.com"
    first_name        = "Jill"
    last_name         = "Bloggs"
    login_name        = "JILLBLOGGS"
    roles_inherited   = ["ANALYST_CORE"]
  }

}

SNOWFLAKE_rbac_custom_roles = {
  # Additional 'roles_inherited' list option determines which pre-defined role privileges, the custom role will inherit

  "ANALYST_BIZOPS" = {
    comment = "Analysts in the Business Operations team"
    roles_inherited = [
      "PUBLIC",
      "DBT_ANALYTICS",
      "REPORTER"
    ]
  },

  "ANALYST_CORE" = {
    comment = "Analysts embedded in the core data team."
    roles_inherited = [
      "PUBLIC",
      "DBT_ANALYTICS",
      "DEV_TRANSFORMER",
      "REPORTER"
    ]
  },

  "DATATONIC_ENGINEER" = {
    comment = "Datatonic Contractors"
    roles_inherited = [
      "PUBLIC",
      "ENGINEER"
    ]
  },

  "DATA_MANAGER" = {
    comment = null
    roles_inherited = [
      "PUBLIC",
      "DBT_ANALYTICS",
      "DEV_TRANSFORMER"
    ]
  },

  "DBT_ANALYTICS" = {
    comment = "Grants access to the core models in the analytics database."
    roles_inherited = [
      "PUBLIC"
    ]
  },

  "DEV_TRANSFORMER" = {
    comment = "[LEGACY] Dev Transformer has access to read from RAW and can own objects in DEV. It used for testing TRANSFORMER workflows by CI and Analysts"
    roles_inherited = [
      "PUBLIC"
    ]
  },

  "ENGINEER" = {
    comment = "Analytics and Data Engineers."
    roles_inherited = [
      "PUBLIC",
      "DBT_ANALYTICS",
      "DEV_TRANSFORMER",
      "LOADER",
      "REPORTER",
      "TRANSFORMER"
    ]
  },

  "INSIGHTS" = {
    comment = "Base privileges for all members of the insights team."
    roles_inherited = [
      "PUBLIC"
    ]
  },

  "LOADER" = {
    comment = "Loader role has base privileges any Loading role will need such as usage on RAW database. It should not own any schemas or tables."
    roles_inherited = [
      "PUBLIC"
    ]
  },

  "REPORTER" = {
    comment = "Base Reporter role has base privileges any Reporter role will need such as usage on ANALYTICS. It is intended to be used as base role for data consumers, such as analysts and BI tools. No reporter user should have permissions to read data from the raw database."
    roles_inherited = [
      "PUBLIC"
    ]
  },

  "SCIENTIST_INSIGHTS" = {
    comment = "Data scientists in the insights team."
    roles_inherited = [
      "PUBLIC",
      "DBT_ANALYTICS",
      "INSIGHTS",
      "REPORTER"
    ]
  },

  "TASMAN_ENGINEER" = {
    comment = "Tasman AI Contractors"
    roles_inherited = [
      "PUBLIC",
      "ENGINEER"
    ]
  },

  "TRANSFORMER" = {
    comment = "Base transformer role has read permissions on all tables in the raw database."
    roles_inherited = [
      "PUBLIC"
    ]
  }
}

SNOWFLAKE_rbac_warehouses = {
  # Additional 'grant_usage_on_roles' list option determines which custom roles to grant usage of the warehouse

  "AIRFLOW" = {
    auto_suspend         = 60
    comment              = "To be used by Internal Airflow Production Tool"
    max_cluster_count    = 4
    min_cluster_count    = 1
    scaling_policy       = "STANDARD"
    warehouse_size       = "X-Small"
    grant_usage_on_roles = ["AIRFLOW"]
  },

  "AIRFLOW_DEV_SA" = {
    auto_suspend         = 60
    comment              = "To be used by Airflow Dev tool"
    max_cluster_count    = 4
    min_cluster_count    = 1
    scaling_policy       = "STANDARD"
    warehouse_size       = "X-Small"
    grant_usage_on_roles = ["AIRFLOW_DEV_SA"]
  },

  "AIRFLOW_STAGING_SA" = {
    auto_suspend         = 60
    comment              = "To be used by Airflow Staging tool"
    max_cluster_count    = 4
    min_cluster_count    = 1
    scaling_policy       = "STANDARD"
    warehouse_size       = "X-Small"
    grant_usage_on_roles = ["AIRFLOW_STAGING_SA"]
  },

  "ANALYST_S" = {
    auto_suspend      = 60
    comment           = null
    max_cluster_count = 4
    min_cluster_count = 1
    scaling_policy    = "ECONOMY"
    warehouse_size    = "Small"
    grant_usage_on_roles = [
      "ANALYST_CORE",
      "DATA_MANAGER"
    ]
  },

  "ANALYST_XS" = {
    auto_suspend      = 60
    comment           = null
    max_cluster_count = 4
    min_cluster_count = 1
    scaling_policy    = "ECONOMY"
    warehouse_size    = "X-Small"
    grant_usage_on_roles = [
      "ANALYST_BIZOPS",
      "ANALYST_CORE",
      "DATA_MANAGER",
      "ENGINEER"
    ]
  },

  "CI" = {
    auto_suspend         = 60
    comment              = null
    max_cluster_count    = 8
    min_cluster_count    = 1
    scaling_policy       = "STANDARD"
    warehouse_size       = "X-Small"
    grant_usage_on_roles = ["CI"]
  },

  "DBT" = {
    auto_suspend         = 60
    comment              = "To be used by DBT."
    max_cluster_count    = 4
    min_cluster_count    = 1
    scaling_policy       = "STANDARD"
    warehouse_size       = "X-Small"
    grant_usage_on_roles = ["DBT"]
  },

  "DEV" = {
    auto_suspend         = 60
    comment              = "To be used for ETL development"
    max_cluster_count    = 6
    min_cluster_count    = 1
    scaling_policy       = "ECONOMY"
    warehouse_size       = "X-Small"
    grant_usage_on_roles = ["DEV_TRANSFORMER"]
  },

  "ENGINEER_L" = {
    auto_suspend         = 60
    comment              = null
    max_cluster_count    = 2
    min_cluster_count    = 1
    scaling_policy       = "ECONOMY"
    warehouse_size       = "Large"
    grant_usage_on_roles = ["ENGINEER"]
  },

  "ENGINEER_M" = {
    auto_suspend         = 60
    comment              = null
    max_cluster_count    = 2
    min_cluster_count    = 1
    scaling_policy       = "ECONOMY"
    warehouse_size       = "Medium"
    grant_usage_on_roles = ["ENGINEER"]
  },

  "ENGINEER_S" = {
    auto_suspend         = 60
    comment              = null
    max_cluster_count    = 2
    min_cluster_count    = 1
    scaling_policy       = "ECONOMY"
    warehouse_size       = "Small"
    grant_usage_on_roles = ["ENGINEER"]
  },

  "ENGINEER_XS" = {
    auto_suspend         = 60
    comment              = null
    max_cluster_count    = 4
    min_cluster_count    = 1
    scaling_policy       = "ECONOMY"
    warehouse_size       = "X-Small"
    grant_usage_on_roles = ["ENGINEER"]
  },

  "FIVETRAN" = {
    auto_suspend         = 60
    comment              = "To be used by Fivetran."
    max_cluster_count    = 8
    min_cluster_count    = 1
    scaling_policy       = "STANDARD"
    warehouse_size       = "X-Small"
    grant_usage_on_roles = ["FIVETRAN"]
  },

  "LOOKER" = {
    auto_suspend         = 120
    comment              = "To be used by Looker."
    max_cluster_count    = 6
    min_cluster_count    = 1
    scaling_policy       = "STANDARD"
    warehouse_size       = "X-Small"
    grant_usage_on_roles = ["LOOKER", "LOOKER_REPORTING"]
  },

  "SALESFORCE" = {
    auto_suspend         = 60
    comment              = "To be used by Salesforce"
    max_cluster_count    = 2
    min_cluster_count    = 1
    scaling_policy       = "STANDARD"
    warehouse_size       = "X-Small"
    grant_usage_on_roles = ["SALESFORCE"]
  },

  "SCIENTIST_XS" = {
    auto_suspend         = 60
    comment              = null
    max_cluster_count    = 2
    min_cluster_count    = 1
    scaling_policy       = "STANDARD"
    warehouse_size       = "X-Small"
    grant_usage_on_roles = ["SCIENTIST_INSIGHTS"]
  },

  "SEGMENT" = {
    auto_suspend         = 60
    comment              = "To be used by the Segment tool"
    max_cluster_count    = 4
    min_cluster_count    = 1
    scaling_policy       = "STANDARD"
    warehouse_size       = "X-Small"
    grant_usage_on_roles = ["SEGMENT"]
  },

  "STITCH" = {
    auto_suspend         = 60
    comment              = "To be used by Stitch ELT Tool"
    max_cluster_count    = 8
    min_cluster_count    = 1
    scaling_policy       = "STANDARD"
    warehouse_size       = "X-Small"
    grant_usage_on_roles = ["STITCH"]
  }

}

SNOWFLAKE_rbac_accountadmin_users = [
  "ALEXREILLY"
]

SNOWFLAKE_rbac_sysadmin_users = [
  "ALEXREILLY"
]

SNOWFLAKE_rbac_securityadmin_users = [
  "ALEXREILLY"
]

SNOWFLAKE_rbac_useradmin_users = [
  "ALEXREILLY"
]

SNOWFLAKE_rbac_create_database_roles = [
  "CI" # Grant create database to role CI (used in dbt workflow)
]

SNOWFLAKE_database_sources_enabled = true # Enabled on master only

SNOWFLAKE_database_sources_dev_users = [
  "ALEXREILLY"
]

SNOWFLAKE_database_sources_create_schema_roles = [
  "SYSADMIN",
  "DBT" # Role for the dbt cloud user
]

SNOWFLAKE_database_sources_usage_roles = [
  "DBT_ANALYTICS", # This role is granted to all dbt users and service account roles
  "DBT_DEV"
]
