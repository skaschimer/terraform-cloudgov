data "external" "app_zip" {
  program     = ["/bin/sh", "prepare_app.sh"]
  working_dir = path.module
  query = {
    gitref     = var.gitref
    org        = var.github_org_name
    repo       = var.github_repo_name
    src_folder = var.src_code_folder_name
  }
}

check "deprecated_cf_space_name" {
  assert {
    condition     = var.cf_space_name == ""
    error_message = "The cf_space_name variable is deprecated. Use the `space` variable instead to pass a cloudfoundry_space resource directly."
  }
}

locals {
  space_name = var.space != null ? var.space.name : var.cf_space_name
}

resource "cloudfoundry_app" "application" {
  name       = var.name
  space_name = local.space_name
  org_name   = var.cf_org_name

  path             = "${path.module}/${data.external.app_zip.result.path}"
  source_code_hash = filesha256("${path.module}/${data.external.app_zip.result.path}")

  buildpacks = var.buildpacks
  memory     = var.app_memory
  disk_quota = var.disk_space
  instances  = var.instances
  strategy   = "rolling"

  service_bindings = [
    for service_name, params in var.service_bindings : {
      service_instance = service_name
      params           = (params == "" ? "{}" : params) # Empty string -> Minimal JSON
    }
  ]
  environment = merge({
    REQUESTS_CA_BUNDLE = "/etc/ssl/certs/ca-certificates.crt"
  }, var.environment_variables)
}

module "route" {
  source = "../app_route"

  space    = var.space
  domain   = var.domain
  hostname = coalesce(var.hostname, var.name)
  app_ids  = [cloudfoundry_app.application.id]
}
