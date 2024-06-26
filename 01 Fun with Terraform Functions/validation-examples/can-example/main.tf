terraform {
  required_version = ">= 1.0.11"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.5.0" 
    }
  }
}

module "vm_1" {
    source = "./modules/vm"

    name = "test-1"
    env_tag = "staging"
}
