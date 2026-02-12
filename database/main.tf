locals {
  tags = setunion(["terraform-cloudgov-managed"], var.tags)
}

data "cloudfoundry_service_plans" "rds" {
  name                  = var.rds_plan_name
  service_offering_name = "aws-rds"
}

resource "cloudfoundry_service_instance" "rds" {
  count        = var.prevent_destroy ? 0 : 1
  name         = var.name
  space        = var.cf_space_id
  type         = "managed"
  service_plan = data.cloudfoundry_service_plans.rds.service_plans.0.id
  tags         = local.tags
  parameters   = var.json_params
}

resource "cloudfoundry_service_instance" "rds_protected" {
  count        = var.prevent_destroy ? 1 : 0
  name         = var.name
  space        = var.cf_space_id
  type         = "managed"
  service_plan = data.cloudfoundry_service_plans.rds.service_plans.0.id
  tags         = local.tags
  parameters   = var.json_params

  lifecycle {
    prevent_destroy = true
  }
}

# Automatically migrate existing state for the default (prevent_destroy = false)
# upgrade path. Previously the resource had no count; adding count requires moving
# from the unindexed address to [0]. Without this block, Terraform would plan to
# destroy the existing instance and create a new one.
#
# If setting prevent_destroy = true on an existing database, you must manually run
# `terraform state mv` BEFORE planning. See UPGRADING.md for details:
# https://github.com/GSA-TTS/terraform-cloudgov/blob/main/UPGRADING.md#database-prevent_destroy-support
moved {
  from = cloudfoundry_service_instance.rds
  to   = cloudfoundry_service_instance.rds[0]
}
