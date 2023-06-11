terraform {
  cloud {
    organization = "saritasa-devops-camps"

    workspaces {
      tags = [
        "owner:daria-nalimova-user",
        "lecture:aws",
        "env:dev"
      ]
    }
  }
}
