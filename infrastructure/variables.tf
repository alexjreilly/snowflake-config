# ========== Snowflake variables ========== #

variable "SNOWFLAKE_account" {
  type = string
}

variable "SNOWFLAKE_region" {
  type = string
}

# Derived from environment variable: TF_VAR_snowflake_tf_user
variable "SNOWFLAKE_tf_user" {
  type    = string
  default = "user"
}

# Derived from environment variable: TF_VAR_snowflake_tf_password
variable "SNOWFLAKE_tf_password" {
  type    = string
  default = "pass"
}

# Feature flag for rbac module, disabled by default and only set to true in master.tfvars
variable "SNOWFLAKE_rbac_enabled" {
  type    = bool
  default = false
}

variable "SNOWFLAKE_rbac_users" {
  type = map(object({
    comment           = string
    default_role      = string
    default_warehouse = string
    disabled          = bool
    display_name      = string
    email             = string
    first_name        = string
    last_name         = string
    login_name        = string
    roles_inherited   = list(string)
  }))
  default = null
}

variable "SNOWFLAKE_rbac_users_sa" {
  type = map(object({
    comment           = string
    default_role      = string
    default_warehouse = string
    disabled          = bool
    display_name      = string
    login_name        = string
    roles_inherited   = list(string)
  }))
  default = null
}

variable "SNOWFLAKE_rbac_custom_roles" {
  type = map(object({
    comment         = string
    roles_inherited = list(string)
  }))
  default = null
}

variable "SNOWFLAKE_rbac_warehouses" {
  type = map(object({
    auto_suspend         = number
    comment              = string
    max_cluster_count    = number
    min_cluster_count    = number
    scaling_policy       = string
    warehouse_size       = string
    grant_usage_on_roles = list(string)
  }))
  default = null
}

variable "SNOWFLAKE_rbac_accountadmin_users" {
  type    = list(string)
  default = []
}

variable "SNOWFLAKE_rbac_sysadmin_users" {
  type    = list(string)
  default = []
}

variable "SNOWFLAKE_rbac_securityadmin_users" {
  type    = list(string)
  default = []
}

variable "SNOWFLAKE_rbac_useradmin_users" {
  type    = list(string)
  default = []
}

variable "SNOWFLAKE_rbac_user_default_password" {
  type    = string
  default = null # default set for running terraform locally
}

variable "SNOWFLAKE_rbac_create_database_roles" {
  type    = list(string)
  default = []
}

variable "SNOWFLAKE_database_raw_base_name" {
  type = string
}

variable "SNOWFLAKE_database_raw_create_schema_roles" {
  type    = list(string)
  default = []
}

variable "SNOWFLAKE_database_raw_usage_on_roles" {
  type    = list(string)
  default = []
}

# Feature flag for deploying all SOURCES databases, disabled by default and only set to true in master.tfvars
variable "SNOWFLAKE_database_sources_enabled" {
  type    = bool
  default = false
}

variable "SNOWFLAKE_database_sources_dev_users" {
  type    = list(string)
  default = []
}

variable "SNOWFLAKE_database_sources_create_schema_roles" {
  type    = list(string)
  default = []
}

variable "SNOWFLAKE_database_sources_usage_roles" {
  type    = list(string)
  default = []
}
