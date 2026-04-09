##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

module "project" {
  source = "../terraform-module-mongoatlas-project"

  is_hub     = var.is_hub
  spoke_def  = var.spoke_def
  org        = var.org
  extra_tags = var.extra_tags

  name_prefix         = ""
  name                = var.name != "" ? var.name : (var.name_prefix != "" ? format("%s-%s", var.name_prefix, local.system_name_plain) : local.system_name_plain)
  organization_name   = var.organization_name
  organization_id     = var.organization_id
  settings            = var.settings
  generate_import     = var.generate_import
  encryption_provider = try(var.settings.encryption_at_rest.enabled, false) ? "GCP" : ""
  encryption_provider_config = {
    key_version_resource_id = try(data.google_kms_crypto_key_version.atlas[0].name, null)
  }
}
