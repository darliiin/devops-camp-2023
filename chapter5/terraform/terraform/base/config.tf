terraform {
  required_version = ">= 1.4.6"

  required_providers {
    aws = "~> 5.1.0"

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
    null = "~> 3.2.1"
  }
}

provider "aws" {
  default_tags {
    tags = {
      Owner      = "daria-nalimova-user"
      Camp       = true
      project    = "wordpress"
      terraform  = true
      git        = "git@github.com:saritasa-nest/saritasa-devops-camp.git"
      branch     = "main"
      created_by = "DariaNalimova"
      created_at = "5/17/2023"
      updated_at = "5/20/2023"
    }
  }
}
