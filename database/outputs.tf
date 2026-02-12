output "instance_id" {
  value = var.prevent_destroy ? cloudfoundry_service_instance.rds_protected[0].id : cloudfoundry_service_instance.rds[0].id
}

output "database_name" {
  value = var.prevent_destroy ? cloudfoundry_service_instance.rds_protected[0].name : cloudfoundry_service_instance.rds[0].name
}
