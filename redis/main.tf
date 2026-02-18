check "deprecated_cf_space_id" {
  assert {
    condition     = var.cf_space_id == ""
    error_message = "The cf_space_id variable is deprecated. Use the `space` variable instead to pass a cloudfoundry_space resource directly."
  }
}

locals {
  space_id = var.space != null ? var.space.id : var.cf_space_id
  tags     = setunion(["terraform-cloudgov-managed"], var.tags)
}

data "cloudfoundry_service_plans" "redis" {
  name                  = var.redis_plan_name
  service_offering_name = "aws-elasticache-redis"
}

resource "cloudfoundry_service_instance" "redis" {
  name         = var.name
  space        = local.space_id
  type         = "managed"
  service_plan = data.cloudfoundry_service_plans.redis.service_plans.0.id
  tags         = local.tags
  parameters   = var.json_params
}
