variable "database_name" {
  type = string
}

variable "database_comment" {
  type    = string
  default = ""
}

variable "roles_with_usage" {
  type = list(string)
}

variable "roles_with_create_schema" {
  type = list(string)
}
