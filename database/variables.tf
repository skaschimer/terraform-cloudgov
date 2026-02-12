variable "cf_space_id" {
  type        = string
  description = "cloud.gov space GUID"
}

variable "name" {
  type        = string
  description = "Name of the database service instance"
}

variable "rds_plan_name" {
  type        = string
  description = "service plan to use"
  # See options at https://cloud.gov/docs/services/relational-database/#plans
}

variable "tags" {
  description = "A list of tags to add to the resource"
  type        = set(string)
  default     = []
}

variable "json_params" {
  description = "A JSON string of arbitrary parameters"
  type        = string
  default     = null
  # See options at https://cloud.gov/docs/services/relational-database/#setting-optional-parameters-1
}

variable "prevent_destroy" {
  description = <<-EOT
    Prevent accidental destruction of the database instance. Set to true for
    production or other persistent environments.

    IMPORTANT: Enabling this on an existing database requires a manual state
    migration step BEFORE running terraform plan. See UPGRADING.md for details:
    https://github.com/GSA-TTS/terraform-cloudgov/blob/main/UPGRADING.md#database-prevent_destroy-support
  EOT
  type        = bool
  default     = false
}
