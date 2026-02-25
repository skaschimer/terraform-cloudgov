check "deprecated_space_vars" {
  assert {
    condition     = var.cf_org_name == "" && var.cf_space_name == ""
    error_message = "The cf_org_name and cf_space_name variables are deprecated. Use the `space` variable instead to pass a cloudfoundry_space resource directly."
  }
}

data "cloudfoundry_org" "org" {
  count = var.space == null ? 1 : 0
  name  = var.cf_org_name
}
data "cloudfoundry_space" "space" {
  count = var.space == null ? 1 : 0
  name  = var.cf_space_name
  org   = data.cloudfoundry_org.org[0].id
}

data "cloudfoundry_domain" "domain" {
  name = var.domain
}

locals {
  space_id = var.space != null ? var.space.id : data.cloudfoundry_space.space[0].id
  destinations = (length(var.app_ids) == 0 ? null : [
    for dest in var.app_ids : { app_id = dest }
  ])
}
resource "cloudfoundry_route" "app_route" {
  domain = data.cloudfoundry_domain.domain.id
  space  = local.space_id
  host   = var.hostname
  path   = var.path

  destinations = local.destinations
}
