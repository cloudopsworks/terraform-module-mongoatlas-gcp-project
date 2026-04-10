##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

output "project_name" {
  value = module.project.project_name
}

output "project_id" {
  value = module.project.project_id
}

output "project_creation_timestamp" {
  value = module.project.project_creation_timestamp
}

output "project_backup_policy_id" {
  value = module.project.project_backup_policy_id
}

output "project_kms_key_ring_id" {
  value = try(var.settings.encryption_at_rest.enabled, false) ? google_kms_key_ring.atlas[0].id : null
}

output "project_kms_crypto_key_id" {
  value = try(var.settings.encryption_at_rest.enabled, false) ? google_kms_crypto_key.atlas[0].id : null
}

output "project_kms_atlas_service_account" {
  description = "Atlas GCP service account granted access to the KMS key (from cloud provider access setup)"
  value       = module.project.cloud_provider_setup_gcp_service_account
}

output "encryption_at_rest_id" {
  value = module.project.encryption_at_rest_id
}

output "imported_alert_statement" {
  value = module.project.imported_alert_statement
}

output "imported_alert_json" {
  value = module.project.imported_alert_json
}
