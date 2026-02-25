variable "cf_space_id" {
  type        = string
  description = "cloud.gov space id (deprecated; use `space` instead)"
  default     = ""
}

variable "space" {
  type = object({
    id = string
  })
  description = "A cloudfoundry_space resource (or any object with .id). When provided, cf_space_id is not used."
  default     = null
}

variable "name" {
  type        = string
  description = "name for the redis service instance"
}

variable "redis_plan_name" {
  type        = string
  description = "name of the service plan name to create"
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
  # See options at https://cloud.gov/docs/services/aws-elasticache/#setting-optional-parameters
}
