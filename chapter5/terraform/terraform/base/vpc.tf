data "aws_vpc" "target" {
  tags = var.vpc_tags
}

data "aws_subnets" "wordpress" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.target.id]
  }
}

data "aws_subnet" "wordpress_subnet_a_zone" {
  vpc_id            = data.aws_vpc.target.id
  availability_zone = "us-east-2a"
}

data "aws_subnet" "wordpress_subnet_b_zone" {
  vpc_id            = data.aws_vpc.target.id
  availability_zone = "us-east-2b"
}

data "aws_subnet" "wordpress_subnet_c_zone" {
  vpc_id            = data.aws_vpc.target.id
  availability_zone = "us-east-2c"
}
