terraform {
  cloud {
    organization = "saritasa-devops-camps"

    workspaces {
      tags = [
        "owner:daria-nalimova-user",
        "lecture:environments",
        "env:dev"
      ]
    }
  }
}
