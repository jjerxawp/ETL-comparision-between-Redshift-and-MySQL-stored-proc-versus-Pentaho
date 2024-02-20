data "local_file" "credentials" {
  filename = "./credential.txt"
}

locals {
  credential_data = jsondecode(data.local_file.credentials.content)
  sensitive       = true
}

provider "aws" {
  region     = var.provider_region
  access_key = local.credential_data["access_key"]
  secret_key = local.credential_data["secret_key"]
}
