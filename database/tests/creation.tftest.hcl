provider "cloudfoundry" {}

variables {
  # this is the ID of the terraform-cloudgov-tf-tests space
  space = {
    id = "f23cbf69-66a1-4b1d-83d4-e497abdb8dcb"
  }
  rds_plan_name = "micro-psql"
  name          = "terraform-cloudgov-rds-test"
  tags          = ["terraform-cloudgov-managed", "tests"]
  json_params = jsonencode({
    backup_retention_period = 30
  })
}

run "test_db_creation_deprecated" {
  command = plan

  variables {
    cf_space_id = "f23cbf69-66a1-4b1d-83d4-e497abdb8dcb"
    space       = null
  }

  override_resource {
    target = cloudfoundry_service_instance.rds[0]
    values = {
      id = "f6925fad-f9e8-4c93-b69f-132438f6a2f4"
    }
  }

  expect_failures = [
    check.deprecated_cf_space_id
  ]
}

run "test_protected_db_creation_deprecated" {
  command = plan

  variables {
    cf_space_id     = "f23cbf69-66a1-4b1d-83d4-e497abdb8dcb"
    space           = null
    prevent_destroy = true
  }

  override_resource {
    target = cloudfoundry_service_instance.rds_protected[0]
    values = {
      id = "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
    }
  }

  expect_failures = [
    check.deprecated_cf_space_id
  ]
}

run "test_db_creation" {
  variables {
    cf_space_id = ""
  }

  override_resource {
    target = cloudfoundry_service_instance.rds[0]
    values = {
      id = "f6925fad-f9e8-4c93-b69f-132438f6a2f4"
    }
  }

  assert {
    condition     = cloudfoundry_service_instance.rds[0].id == output.instance_id
    error_message = "Instance ID output must match the service instance"
  }

  assert {
    condition     = cloudfoundry_service_instance.rds[0].service_plan == data.cloudfoundry_service_plans.rds.service_plans.0.id
    error_message = "Service Plan should match the rds_plan_name variable"
  }

  assert {
    condition     = cloudfoundry_service_instance.rds[0].name == var.name
    error_message = "Service instance name should match the name variable"
  }

  assert {
    condition     = cloudfoundry_service_instance.rds[0].tags == tolist(var.tags)
    error_message = "Service instance tags should match the tags variable"
  }

  assert {
    condition     = cloudfoundry_service_instance.rds[0].parameters == "{\"backup_retention_period\":30}"
    error_message = "Service instance json_params should be configurable"
  }
}

run "test_protected_db_creation" {
  variables {
    cf_space_id     = ""
    prevent_destroy = true
  }

  override_resource {
    target = cloudfoundry_service_instance.rds_protected[0]
    values = {
      id = "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
    }
  }

  assert {
    condition     = cloudfoundry_service_instance.rds_protected[0].id == output.instance_id
    error_message = "Instance ID output must match the protected service instance"
  }

  assert {
    condition     = cloudfoundry_service_instance.rds_protected[0].service_plan == data.cloudfoundry_service_plans.rds.service_plans.0.id
    error_message = "Service Plan should match the rds_plan_name variable"
  }

  assert {
    condition     = cloudfoundry_service_instance.rds_protected[0].name == var.name
    error_message = "Service instance name should match the name variable"
  }

  assert {
    condition     = cloudfoundry_service_instance.rds_protected[0].tags == tolist(var.tags)
    error_message = "Service instance tags should match the tags variable"
  }

  assert {
    condition     = cloudfoundry_service_instance.rds_protected[0].parameters == "{\"backup_retention_period\":30}"
    error_message = "Service instance json_params should be configurable"
  }
}
