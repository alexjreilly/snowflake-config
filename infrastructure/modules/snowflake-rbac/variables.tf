variable "users" {
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
}

variable "users_sa" {
  type = map(object({
    comment           = string
    default_role      = string
    default_warehouse = string
    disabled          = bool
    display_name      = string
    login_name        = string
    roles_inherited   = list(string)
  }))
}

variable "custom_roles" {
  type = map(object({
    comment         = string
    roles_inherited = list(string)
  }))
}

variable "warehouses" {
  type = map(object({
    auto_suspend         = number
    comment              = string
    max_cluster_count    = number
    min_cluster_count    = number
    scaling_policy       = string
    warehouse_size       = string
    grant_usage_on_roles = list(string)
  }))
}

variable "accountadmin_users" {
  type    = list(string)
  default = []
}

variable "sysadmin_users" {
  type    = list(string)
  default = []
}

variable "securityadmin_users" {
  type    = list(string)
  default = []
}

variable "useradmin_users" {
  type    = list(string)
  default = []
}

variable "user_default_password" {
  type = string
}

variable "create_database_roles" {
  type    = list(string)
  default = []
}
