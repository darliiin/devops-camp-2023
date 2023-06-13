module "wordpress_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  name        = var.client
  environment = var.environment
  attributes  = [var.project]
}

module "wordpress_instance_labels" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  for_each   = toset(var.wordpress_availability_zones)
  context    = module.wordpress_label.context
  attributes = [var.project, each.value]
}

#   ┌─────────────────────┐
#   │ key                 │
#   └─────────────────────┘

module "wordpress_ssh_keypair" {
  source                = "cloudposse/key-pair/aws"
  version               = "0.18.3"
  stage                 = var.environment
  name                  = var.client
  ssh_public_key_path   = "${path.cwd}/assets/private_keys"
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
}

#   ┌─────────────────────┐
#   │ instances           │
#   └─────────────────────┘

module "wordpress_ec2_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "5.1.0"
  count                  = var.wordpress_instances_count
  name                   = "${local.labels.wordpress_ec2}-${count.index}"
  ami                    = var.wordpress_instances_ami
  instance_type          = var.wordpress_instances_type
  key_name               = module.wordpress_ssh_keypair.key_name
  vpc_security_group_ids = [module.wordpress_sg.security_group_id]
  subnet_id              = data.aws_subnet.wordpress_subnet_a_zone.id
  tags                   = var.tags
  user_data = templatefile("${path.cwd}/terraform/base/userdata.tpl", {
    random_pwd       = random_password.db_password.result
    endpoint_rds     = module.wordpress_rds.db_instance_endpoint
    db_name_rds      = module.wordpress_rds.db_instance_name
    efs_id           = module.efs.id
    auth_key         = random_string.auth_key.result        # authentication unique keys and salts for wordpress
    secure_auth_key  = random_string.secure_auth_key.result
    logged_in_key    = random_string.logged_in_key.result
    nonce_key        = random_string.nonce_key.result
    auth_salt        = random_string.auth_salt.result
    secure_auth_salt = random_string.secure_auth_salt.result
    logged_in_salt   = random_string.logged_in_salt.result
    nonce_salt       = random_string.nonce_salt.result
  })
}

#   ┌──────────────────────────────────────┐
#   │ random string for wp-config.php      │
#   └──────────────────────────────────────┘

resource "random_string" "auth_key" {
  length           = var.wordpress_wpconfig_secrets_length
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}

resource "random_string" "secure_auth_key" {
  length           = var.wordpress_wpconfig_secrets_length
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}

resource "random_string" "logged_in_key" {
  length           = var.wordpress_wpconfig_secrets_length
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}

resource "random_string" "nonce_key" {
  length           = var.wordpress_wpconfig_secrets_length
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}

resource "random_string" "auth_salt" {
  length           = var.wordpress_wpconfig_secrets_length
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}

resource "random_string" "secure_auth_salt" {
  length           = var.wordpress_wpconfig_secrets_length
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}

resource "random_string" "logged_in_salt" {
  length           = var.wordpress_wpconfig_secrets_length
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}

resource "random_string" "nonce_salt" {
  length           = var.wordpress_wpconfig_secrets_length
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}
