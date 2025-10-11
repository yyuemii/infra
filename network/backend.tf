terraform {
  backend "s3" {
    bucket = "infra-terraform"
    key    = "network/terraform.tfstate"

    region = "auto"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true

    endpoints = {
      s3 = "https://68bf54b88195a2a99d6d63920d332015.r2.cloudflarestorage.com"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

provider "cloudflare" {

}
