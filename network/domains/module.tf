terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

variable "account_id" {
  type        = string
  description = "Cloudflare account ID"
}
