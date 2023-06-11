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
      Owner = "daria-nalimova-user"
      Camp  = true
    }
  }
}
