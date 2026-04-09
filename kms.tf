##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  kms_location        = try(var.settings.encryption_at_rest.kms_location, data.google_client_config.current.region)
  kms_key_ring_name   = try(var.settings.encryption_at_rest.key_ring_name, format("mongodbatlas-%s-keyring", local.system_name))
  kms_crypto_key_name = try(var.settings.encryption_at_rest.crypto_key_name, format("mongodbatlas-%s-key", local.system_name))
}

resource "google_kms_key_ring" "atlas" {
  count    = try(var.settings.encryption_at_rest.enabled, false) ? 1 : 0
  name     = local.kms_key_ring_name
  location = local.kms_location
}

resource "google_kms_crypto_key" "atlas" {
  count           = try(var.settings.encryption_at_rest.enabled, false) ? 1 : 0
  name            = local.kms_crypto_key_name
  key_ring        = google_kms_key_ring.atlas[count.index].id
  purpose         = "ENCRYPT_DECRYPT"
  rotation_period = try(var.settings.encryption_at_rest.rotation_period, "7776000s")

  lifecycle {
    prevent_destroy = true
  }
}

data "google_kms_crypto_key_version" "atlas" {
  count      = try(var.settings.encryption_at_rest.enabled, false) ? 1 : 0
  crypto_key = google_kms_crypto_key.atlas[count.index].id
}

# Grant Atlas's GCP service account (obtained via cloud provider access setup)
# encrypt/decrypt permissions on the KMS key.
resource "google_kms_crypto_key_iam_member" "atlas" {
  count         = try(var.settings.encryption_at_rest.enabled, false) ? 1 : 0
  crypto_key_id = google_kms_crypto_key.atlas[count.index].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${module.project.cloud_provider_setup_gcp_service_account}"
}
