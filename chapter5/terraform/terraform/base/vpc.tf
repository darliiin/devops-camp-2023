data "aws_vpc" "target" {
  tags = var.vpc_tags
}

data "aws_subnets" "wordpress" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.target.id]
  }
}

data "aws_instance" "ec2_instances" {

  count = var.wordpress_instances_count
  filter {
    name   = "tag:Name"
    values = ["${local.labels.wordpress_ec2}-${count.index}"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [
    module.wordpress_ec2_instance
  ]
}
