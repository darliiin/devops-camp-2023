module "wordpress_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  name        = var.client
  environment = var.environment
  attributes  = [var.project]
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
  user_data = templatefile("${path.cwd}/terraform/base/userdata.tpl", {
    random_pwd       = random_password.db_password.result
    endpoint_rds     = module.wordpress_rds.db_instance_endpoint
    db_name_rds      = module.wordpress_rds.db_instance_name
    db_name_user     = module.wordpress_rds.db_instance_username
    efs_id           = module.efs.id
    # authentication unique keys and salts for wordpress
    auth_key         = random_string.random_secret_key_generation["auth_key"].result
    secure_auth_key  = random_string.random_secret_key_generation["secure_auth_key"].result
    logged_in_key    = random_string.random_secret_key_generation["logged_in_key"].result
    nonce_key        = random_string.random_secret_key_generation["nonce_key"].result
    auth_salt        = random_string.random_secret_key_generation["auth_salt"].result
    secure_auth_salt = random_string.random_secret_key_generation["secure_auth_salt"].result
    logged_in_salt   = random_string.random_secret_key_generation["logged_in_salt"].result
    nonce_salt       = random_string.random_secret_key_generation["nonce_salt"].result
  })
}

#   ┌──────────────────────────────────────┐
#   │ random string for wp-config.php      │
#   └──────────────────────────────────────┘

resource "random_string" "random_secret_key_generation" {
  for_each         = toset(var.wordpress_random_wpconfig_secrets)
  length           = 64
  special          = true
  override_special = "<>{}()+*=#@;_/|"
}
