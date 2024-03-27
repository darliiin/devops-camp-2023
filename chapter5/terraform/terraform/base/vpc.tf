data "aws_vpc" "target" {
  tags = var.wordpress_vpc_tags
}

data "aws_subnets" "wordpress" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.target.id]
  }
}

data "aws_subnet" "wordpress_subnets" {
  for_each = toset(data.aws_subnets.wordpress.ids)
  id       = each.value
}
