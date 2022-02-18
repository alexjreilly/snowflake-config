# Snowflake Config

This directory contains the Infrastructure-as-Code for the Snowflake data platform.

It is split into modules (under `infrastructure/modules`), allowing for modular expansion in the future as more infrastructure may be added to this repo.

## Upgrading the terraform version

Simply update the version in `.terraform-version`. You will then need to use `tfswitch` to change terraform version on your local machine.

**Make sure not to run a later version of Terraform!** You cannot easily revert to using a previous version once the state has migrated to a later version.

## Setting up new environments

TBC

## Module: snowflake.rbac

This module manages Snowflake role-based access control resources which include: warehouses, roles, users, warehouse
grants (i.e. which roles can use each warehouse) and role grants (i.e. which other roles or users can assume each role).

The module follows the [Snowflake recommended role hierarchy for privilege inheritance](https://docs.snowflake.com/en/_images/system-role-hierarchy.png).
More specifically, we are creating a top-level role for every user (with the same name) so that we can control access
on a user-level.

E.g. `ROLE: Public` -> `ROLE: Engineer` -> `ROLE: user_1234` -> `USER: user_1234`

Role grants are determined using a `roles_inherited` attribute present for each configured user or role. The
`grants_on_role[]` resource will check every other role and user to see if they must inherit the role in question
before granting it. Role grants on the 5 pre-defined Snowflake roles are managed as separate resources.

### Importing resources

To import a user or role into this module, run the following (where role name is same as the user's name) and then
define these resources in `users.tf` and `roles.tf`.

```
terraform import 'module.snowflake_rbac[0].snowflake_user.user["MY_USER"]' "MY_USER"

terraform import 'module.snowflake_rbac[0].snowflake_role.role["MY_ROLE"]' "MY_ROLE"
terraform import 'module.snowflake_rbac[0].snowflake_role_grants.grants_on_role["MY_ROLE"]' "MY_ROLE"
```

### User password management

User passwords are only set on creation and any changes the individual makes to this are not tracked by Terraform.
A default value is stored as a GitHub secret `SNOWFLAKE_USER_DEFAULT_PASSWORD`. This must be shared with the user and
on first attempt to log in, they will be prompted to change it.
