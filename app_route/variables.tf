variable "cf_org_name" {
  type        = string
  description = "cloud.gov organization name (deprecated; use `space` instead.)"
  default     = ""
}

variable "cf_space_name" {
  type        = string
  description = "cloud.gov space name (deprecated; use `space` instead.)"
  default     = ""
}

variable "space" {
  type = object({
    id = string
  })
  description = "A cloudfoundry_space resource (or any object with .id). When provided, cf_org_name and cf_space_name are not used."
  default     = null
}

variable "app_ids" {
  type        = set(string)
  description = "The list of app IDs the route should send traffic to"
  default     = []
}

variable "hostname" {
  type        = string
  description = "The hostname to route to"
}

variable "domain" {
  type        = string
  description = "The domain to route to"
  default     = "app.cloud.gov"
}

variable "path" {
  type        = string
  description = "The path to route to"
  default     = null
}
