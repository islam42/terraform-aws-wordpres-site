# Purpose: This file contains the terraform code to create the network resources like VPC, Subnet, Internet Gateway, Route Table, Route Table Association, Security Group.

# VPC resources

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "=5.17.0"

  cidr = var.vpc_cidr_block[terraform.workspace]

  azs = slice(data.aws_availability_zones.available.names, 0, var.vpc_subnet_count)
  # private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets          = [for subnet in range(var.vpc_subnet_count) : cidrsubnet(var.vpc_cidr_block[terraform.workspace], var.vpc_subnet_mask, subnet)]
  private_subnets         = [for subnet in range(var.vpc_subnet_count, (var.vpc_subnet_count * 2)) : cidrsubnet(var.vpc_cidr_block[terraform.workspace], var.vpc_subnet_mask, subnet)]
  enable_nat_gateway      = false
  enable_vpn_gateway      = false
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

# resource "aws_vpc" "vpc1" {
#   cidr_block           = var.vpc_cidr_block
#   enable_dns_hostnames = var.enable_dns_hostnames

#   tags = merge(local.common_tags, {
#     Name = "${local.name_prefix}-vpc"
#   })
# }

# resource "aws_subnet" "subnets" {
#   count                   = var.vpc_subnet_count
#   vpc_id                  = aws_vpc.vpc1.id
#   cidr_block              = cidrsubnet(var.vpc_cidr_block, var.vpc_subnet_mask, count.index)
#   map_public_ip_on_launch = var.map_public_ip_on_launch
#   availability_zone       = data.aws_availability_zones.available.names[count.index]

#   tags = local.common_tags
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.vpc1.id
# }

# resource "aws_route_table" "rtb" {
#   vpc_id = aws_vpc.vpc1.id

#   tags = local.common_tags

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
# }

# resource "aws_route_table_association" "rta-subnets" {
#   count          = var.vpc_subnet_count
#   subnet_id      = aws_subnet.subnets[count.index].id
#   route_table_id = aws_route_table.rtb.id
# }

resource "aws_security_group" "alb_sg" {
  vpc_id = module.vpc.vpc_id
  name   = "${local.name_prefix}-alb_sg"

  tags = local.common_tags

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "instance_sg" {
  vpc_id = module.vpc.vpc_id
  name   = "${local.name_prefix}-instance_sg"

  tags = local.common_tags

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block[terraform.workspace]]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
