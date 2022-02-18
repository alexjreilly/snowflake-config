terraform {
  required_version = ">= 0.14.6"

  required_providers {
    google = {
      version = "~> 3.31"
    }

    google-beta = {
      version = "~> 3.31"
    }

    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "~> 0.23.2"
    }
  }

  backend "gcs" {
    bucket = "-data-platform-dev-tfstate" # overriden by CI/CD for staging/prod
    prefix = "data-platform/state"
  }
}

# if terraform workspace is "default", then no resource name prefix
locals {
  _dev_prefix           = (terraform.workspace == "default" ? "" : "${terraform.workspace}-")
  _snowflake_dev_suffix = terraform.workspace == "default" ? "" : upper(replace("_${terraform.workspace}", "-", "_"))
}

module "composer" {
  source                                        = "./modules/gcp-composer"
  count                                         = var.COMPOSER_enabled ? 1 : 0
  _dev_prefix                             = local._dev_prefix
  project_id                                    = var.COMPOSER_project_id
  region                                        = var.GCP_region
  zone                                          = var.GCP_zone
  machine_type                                  = var.COMPOSER_machine_type
  scheduler_machine_type                        = var.COMPOSER_scheduler_machine_type
  scheduler_pool_max_nodes                      = var.COMPOSER_scheduler_pool_max_nodes
  node_count                                    = var.COMPOSER_node_count
  composer_sa_roles                             = var.COMPOSER_composer_sa_roles
  additional_node_pool                          = var.COMPOSER_additional_node_pool
  _airflow_debug                          = var.COMPOSER__airflow_debug
  airflow_conf_core-dags_are_paused_at_creation = var.COMPOSER_airflow_conf_core-dags_are_paused_at_creation
  airflow_conf_core-default_timezone            = var.COMPOSER_airflow_conf_core-default_timezone
  airflow_conf_core-load_default_connections    = var.COMPOSER_airflow_conf_core-load_default_connections
  airflow_conf_core-max_active_runs_per_dag     = var.COMPOSER_airflow_conf_core-max_active_runs_per_dag
  airflow_conf_core-secure_mode                 = var.COMPOSER_airflow_conf_core-secure_mode
  airflow_conf_core-dagbag_import_timeout       = var.COMPOSER_airflow_conf_core-dagbag_import_timeout
  airflow_conf_core-dag_file_processor_timeout  = var.COMPOSER_airflow_conf_core-dag_file_processor_timeout
  airflow_conf_core-dag_concurrency             = var.COMPOSER_airflow_conf_core-dag_concurrency
  airflow_conf_core-parallelism                 = var.COMPOSER_airflow_conf_core-parallelism
  airflow_conf_core-non_pooled_task_slot        = var.COMPOSER_airflow_conf_core-non_pooled_task_slot
  airflow_conf_celery-operation_timeout         = var.COMPOSER_airflow_conf_celery-operation_timeout
  airflow_conf_celery-worker_concurrency        = var.COMPOSER_airflow_conf_celery-worker_concurrency
  airflow_conf_celery-worker_autoscale          = var.COMPOSER_airflow_conf_celery-worker_autoscale
  airflow_conf_scheduler-max_threads            = var.COMPOSER_airflow_conf_scheduler-max_threads
  airflow_conf_webserver-dag_default_view       = var.COMPOSER_airflow_conf_webserver-dag_default_view
  airflow_conf_webserver-expose_config          = var.COMPOSER_airflow_conf_webserver-expose_config
  airflow_conf_webserver-navbar_color           = var.COMPOSER_airflow_conf_webserver-navbar_color
  airflow_image_version                         = var.COMPOSER_airflow_image_version
  python_version                                = var.COMPOSER_python_version
  singer_image_tag                              = var.COMPOSER_singer_image_tag
  singer_state_bucket                           = var.COMPOSER_singer_state_bucket
  singer_state_bucket_force_destroy             = var.COMPOSER_singer_state_bucket_force_destroy
  sentry_on                                     = var.COMPOSER_sentry_on
  sentry_dsn                                    = var.COMPOSER_sentry_dsn
  sentry_environment                            = var.COMPOSER_sentry_environment
  snowflake_raw_db_name                         = module.snowflake_database_raw.database_name
}

module "datadog" {
  source = "./modules/datadog"
  count  = var.DATADOG_enabled ? 1 : 0
  # _dev_prefix          = local._dev_prefix # not included because we don't use DataDog in dev envs
  composer_project_id = var.COMPOSER_project_id
  api_key             = var.DATADOG_api_key
}

provider "snowflake" {
  alias    = "rbac"
  username = var.SNOWFLAKE_tf_user
  password = var.SNOWFLAKE_tf_password
  account  = var.SNOWFLAKE_account
  region   = var.SNOWFLAKE_region
  role     = "SECURITYADMIN"
}

# Default Snowflake provider
provider "snowflake" {
  username = var.SNOWFLAKE_tf_user
  password = var.SNOWFLAKE_tf_password
  account  = var.SNOWFLAKE_account
  region   = var.SNOWFLAKE_region
  role     = "SYSADMIN"
}

module "snowflake_rbac" {
  source                = "./modules/snowflake-rbac"
  count                 = var.SNOWFLAKE_rbac_enabled ? 1 : 0 # enabled on master only
  users                 = var.SNOWFLAKE_rbac_users
  users_sa              = var.SNOWFLAKE_rbac_users_sa
  custom_roles          = var.SNOWFLAKE_rbac_custom_roles
  warehouses            = var.SNOWFLAKE_rbac_warehouses
  accountadmin_users    = var.SNOWFLAKE_rbac_accountadmin_users
  securityadmin_users   = var.SNOWFLAKE_rbac_securityadmin_users
  sysadmin_users        = var.SNOWFLAKE_rbac_sysadmin_users
  useradmin_users       = var.SNOWFLAKE_rbac_useradmin_users
  user_default_password = var.SNOWFLAKE_rbac_user_default_password
  create_database_roles = var.SNOWFLAKE_rbac_create_database_roles
  providers = {
    snowflake.security-admin = snowflake.rbac
    snowflake.sys-admin      = snowflake
  }
}

module "snowflake_database_raw" {
  source                   = "./modules/snowflake-database"
  database_name            = "${var.SNOWFLAKE_database_raw_base_name}${local._snowflake_dev_suffix}"
  database_comment         = "All data extracted and loaded from a variety of sources."
  roles_with_usage         = var.SNOWFLAKE_database_raw_usage_on_roles
  roles_with_create_schema = var.SNOWFLAKE_database_raw_create_schema_roles
}

module "snowflake_database_dev_sources" {
  source                   = "./modules/snowflake-database"
  for_each                 = { for user in var.SNOWFLAKE_database_sources_dev_users : user => user } # variable present on master only
  database_name            = "DEV_${upper(each.key)}_SOURCES"
  database_comment         = "A dev database for user ${each.key}"
  roles_with_usage         = [each.key]
  roles_with_create_schema = [each.key]
}

module "snowflake_database_sources" {
  source                   = "./modules/snowflake-database"
  count                    = var.SNOWFLAKE_database_sources_enabled ? 1 : 0 # enabled on master only
  database_name            = "SOURCES"
  database_comment         = "A one-to-one mapping of our raw data, cleansed before it can be modelled."
  roles_with_usage         = var.SNOWFLAKE_database_sources_usage_roles
  roles_with_create_schema = var.SNOWFLAKE_database_sources_create_schema_roles
}
