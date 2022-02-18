/*
    This module creates the role-based access control objects users, roles, warehouses and grants on these
    objects. Note, grants on database/schema/table objects are not configured here.
*/

locals {
  all_users = merge(var.users, var.users_sa)
  roles     = merge(var.custom_roles, local.all_users) # We also create a role for every user
}

# ========== Warehouses ========== #

/*
    TODO: Remove the warehouses from this module to avoid confusion;
    Note, the dependency of roles on warehouses when refactoring
*/
resource "snowflake_warehouse" "warehouse" {
  provider = snowflake.security-admin

  for_each = var.warehouses

  auto_resume       = true
  auto_suspend      = each.value.auto_suspend
  comment           = each.value.comment
  max_cluster_count = each.value.max_cluster_count
  min_cluster_count = each.value.min_cluster_count
  name              = each.key
  scaling_policy    = each.value.scaling_policy
  warehouse_size    = each.value.warehouse_size
}

# ========== Roles ========== #

resource "snowflake_role" "role" {
  provider = snowflake.security-admin

  for_each = local.roles # Create custom roles and one role for every user

  comment = lookup(each.value, "comment", contains(keys(local.all_users), each.key) ? "Role for user ${each.key}" : null)
  name    = each.key
}

# ========== Users ========== #

resource "snowflake_user" "user" {
  provider = snowflake.security-admin

  for_each = local.all_users

  comment           = lookup(each.value, "comment", null)
  default_namespace = lookup(each.value, "default_namespace", null)
  default_role      = lookup(each.value, "default_role", null)
  default_warehouse = lookup(each.value, "default_warehouse", null)
  disabled          = lookup(each.value, "disabled", false)
  display_name      = each.value.display_name
  email             = lookup(each.value, "email", null)
  first_name        = lookup(each.value, "first_name", null)
  last_name         = lookup(each.value, "last_name", null)
  login_name        = lookup(each.value, "login_name", each.key) # if no login_name provided, use key
  name              = each.key
  rsa_public_key    = lookup(each.value, "rsa_public_key", null)
  rsa_public_key_2  = lookup(each.value, "rsa_public_key_2", null)

  # set password for non-service account users on creation only
  password             = contains(keys(var.users), each.key) ? var.user_default_password : null
  must_change_password = contains(keys(var.users), each.key) ? true : null

  lifecycle {
    ignore_changes = [
      password,
      must_change_password
    ]
  }

}

# ========== Grants ========== #

resource "snowflake_warehouse_grant" "warehouse_usage" {
  provider = snowflake.security-admin

  for_each = var.warehouses

  warehouse_name = snowflake_warehouse.warehouse[each.key].name
  privilege      = "USAGE"

  roles = [
    for role_name in each.value.grant_usage_on_roles : snowflake_role.role[role_name].name
  ]
  with_grant_option = false
}

resource "snowflake_role_grants" "grants_on_role" {
  provider = snowflake.security-admin

  for_each = local.roles

  role_name = snowflake_role.role[each.key].name

  # Loop through roles + users and check if current role is in the list of 'roles_inherited' for that role/user
  roles = concat(
    [for k, v in local.roles : snowflake_role.role[k].name if contains(v.roles_inherited, each.key)],
    ["SYSADMIN"] # grant every role to SYSADMIN (exc. pre_defined roles)
  )

  # grant user role to users with the same name
  users = contains(keys(local.all_users), each.key) ? [snowflake_user.user[each.key].name] : []
}

# Grants only on USERADMIN (role itself not defined in terraform)
resource "snowflake_role_grants" "grants_on_role_USERADMIN" {
  provider = snowflake.security-admin

  role_name = "USERADMIN"
  roles = [
    "SECURITYADMIN"
  ]
  users = [for u in var.useradmin_users : snowflake_user.user[u].name]
}

# Grants only on SECURITYADMIN (role itself not defined in terraform)
resource "snowflake_role_grants" "grants_on_role_SECURITYADMIN" {
  provider = snowflake.security-admin

  role_name = "SECURITYADMIN"
  roles = [
    "ACCOUNTADMIN"
  ]
  users = concat(
    [for u in var.securityadmin_users : snowflake_user.user[u].name],
    ["TERRAFORM_SA"], # concat used here as there is no user["TERRAFORM_SA"] (created outside terraform)
  )
}

# Grants only on SYSADMIN (role itself not defined in terraform)
resource "snowflake_role_grants" "grants_on_role_SYSADMIN" {
  provider = snowflake.security-admin

  role_name = "SYSADMIN"
  roles = [
    "ACCOUNTADMIN"
  ]
  users = concat(
    [for u in var.sysadmin_users : snowflake_user.user[u].name],
    ["TERRAFORM_SA"]
  )
}

# Grants only on ACCOUNTADMIN (role itself not defined in terraform)
resource "snowflake_role_grants" "grants_on_role_ACCOUNTADMIN" {
  provider = snowflake.security-admin

  role_name = "ACCOUNTADMIN"
  users     = [for u in var.accountadmin_users : snowflake_user.user[u].name]
}

# Account level grants
resource "snowflake_account_grant" "create_database" {
  provider = snowflake.sys-admin # Account level grants require SYADMIN or ACCOUNTADMIN

  roles = [
    for r in var.create_database_roles : snowflake_role.role[r].name
  ]
  privilege         = "CREATE DATABASE"
  with_grant_option = false
}
