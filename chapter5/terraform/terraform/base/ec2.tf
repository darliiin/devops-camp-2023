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

module "ssh_key_pair" {
  source                = "cloudposse/key-pair/aws"
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

  source = "terraform-aws-modules/ec2-instance/aws"
  count  = var.wordpress_instances_count
  name   = "${local.labels.wordpress_ec2}-${count.index}"

  ami                    = var.wordpress_instances_ami
  instance_type          = var.wordpress_instances_type
  key_name               = module.ssh_key_pair.key_name
  vpc_security_group_ids = [module.wordpress_sg.security_group_id]
  subnet_id              = data.aws_subnet.wordpress_subnet_a_zone.id
  tags                   = var.tags

  user_data = templatefile("${path.cwd}/terraform/base/userd.tpl", {
    random_pwd   = random_password.password.result
    endpoint_rds = module.wordpress_rds.db_instance_endpoint
    db_name_rds  = module.wordpress_rds.db_instance_name
    efs_id       = module.efs.id

    # Authentication Unique Keys and Salts for wordpress
    AUTH_KEY         = random_string.AUTH_KEY.result
    SECURE_AUTH_KEY  = random_string.SECURE_AUTH_KEY.result
    LOGGED_IN_KEY    = random_string.LOGGED_IN_KEY.result
    NONCE_KEY        = random_string.NONCE_KEY.result
    AUTH_SALT        = random_string.AUTH_SALT.result
    SECURE_AUTH_SALT = random_string.SECURE_AUTH_SALT.result
    LOGGED_IN_SALT   = random_string.LOGGED_IN_SALT.result
    NONCE_SALT       = random_string.NONCE_SALT.result

  })
}

#   ┌──────────────────────────────────────┐
#   │ random string for wp-config.php      │
#   └──────────────────────────────────────┘

resource "random_string" "AUTH_KEY" {
  length           = var.wordpress_wpconfig_count_characters
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}

resource "random_string" "SECURE_AUTH_KEY" {
  length           = var.wordpress_wpconfig_count_characters
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}

resource "random_string" "LOGGED_IN_KEY" {
  length           = var.wordpress_wpconfig_count_characters
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}

resource "random_string" "NONCE_KEY" {
  length           = var.wordpress_wpconfig_count_characters
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}

resource "random_string" "AUTH_SALT" {
  length           = var.wordpress_wpconfig_count_characters
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}

resource "random_string" "SECURE_AUTH_SALT" {
  length           = var.wordpress_wpconfig_count_characters
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}

resource "random_string" "LOGGED_IN_SALT" {
  length           = var.wordpress_wpconfig_count_characters
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}

resource "random_string" "NONCE_SALT" {
  length           = var.wordpress_wpconfig_count_characters
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}

