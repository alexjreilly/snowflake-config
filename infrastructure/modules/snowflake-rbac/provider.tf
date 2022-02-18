terraform {
  required_providers {
    snowflake = {
      source                = "chanzuckerberg/snowflake"
      configuration_aliases = [snowflake.security-admin, snowflake.sys-admin]
    }
  }
}
