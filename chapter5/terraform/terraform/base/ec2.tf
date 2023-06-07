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
  subnet_id              = data.aws_subnets.wordpress.ids[2]
  tags                   = var.tags

  user_data = templatefile("${path.cwd}/terraform/base/userd.tpl", {
    random_pwd          = random_password.password.result
    endpoint_rds        = module.wordpress_rds.db_instance_endpoint
    db_name_rds         = module.wordpress_rds.db_instance_name
#    random_string_array = local.random_string_array
    random_string_array = [
      random_string.unique_keys_for_wpconfig[0].id,
      random_string.unique_keys_for_wpconfig[1].id,
      random_string.unique_keys_for_wpconfig[2].id,
      random_string.unique_keys_for_wpconfig[3].id,
      random_string.unique_keys_for_wpconfig[4].id,
      random_string.unique_keys_for_wpconfig[5].id,
      random_string.unique_keys_for_wpconfig[6].id,
      random_string.unique_keys_for_wpconfig[7].id,
    ]

    efs_id              = module.efs.id

    # Authentication Unique Keys and Salts for wordpress

  })
}

