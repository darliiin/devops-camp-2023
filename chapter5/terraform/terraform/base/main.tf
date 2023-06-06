module "wordpress_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  name        = var.client
  environment = var.environment
  attributes  = [var.project, var.engine]
}

module "wordpress_instance_labels" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  for_each   = toset(var.availability_zones)
  context    = module.wordpress_label.context
  attributes = [var.project, var.engine, each.value]
}

#   ┌──────────────────────────────────────┐
#   │ random string for wp-config.php      │
#   └──────────────────────────────────────┘

resource "random_string" "random" {
  count            = 8
  length           = 64
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}



