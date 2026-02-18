# -----------------------------------------------------------------------------
# SpiffWorkflow Routes and Network Policies
#
# This file contains all the route and network policy resources for the
# SpiffWorkflow module, including:
# - Connector app routes (internal domain)
# - Frontend app routes (public domain)
# - Backend app routes (public domain with /api path)
# - Network policies between components
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# ROUTES
# -----------------------------------------------------------------------------

module "connector_route" {
  source = "../app_route"

  space       = var.space
  cf_org_name = var.cf_org_name
  domain      = "apps.internal"
  hostname    = "${local.prefix}-connector"
  app_ids     = [cloudfoundry_app.connector.id]
}

module "frontend_route" {
  source = "../app_route"

  space       = var.space
  cf_org_name = var.cf_org_name
  hostname    = local.prefix
  app_ids     = [cloudfoundry_app.frontend.id]
}

module "backend_route" {
  source = "../app_route"

  space       = var.space
  cf_org_name = var.cf_org_name
  hostname    = local.prefix
  path        = "/api"
}

# -----------------------------------------------------------------------------
# NETWORK POLICIES
# -----------------------------------------------------------------------------

# The backend needs to be able to reach the connector app to enable
# custom service tasks
resource "cloudfoundry_network_policy" "connector-network-policy" {
  policies = [
    {
      source_app      = local.backend_app_id
      destination_app = local.connector_app_id
      port            = "61443"
      protocol        = "tcp"
    }
  ]
}
