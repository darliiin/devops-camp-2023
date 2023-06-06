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

  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = module.ssh_key_pair.key_name
  vpc_security_group_ids = [module.wordpress_sg.security_group_id]
  subnet_id              = data.aws_subnets.wordpress.ids[2]

  tags = var.tags

  user_data = templatefile("${path.cwd}/terraform/base/userd.tpl", {
    random_pwd          = local.random_pwd,
    endpoint_rds        = local.endpoint_rds,
    db_name_rds         = local.db_name_rds,
    random_string_array = local.random_string_array
    efs_id              = local.efs_id

  })
}
