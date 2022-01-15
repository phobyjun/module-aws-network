provider "aws" {
  region = var.aws_region
}

locals {
  vpc_name = "${var.env_name} ${var.vpc_name}"
  cluster_name = "${var.cluster_name}-${var.env_name}"
}

## AWS VPC definition
resource "aws_vpc" "main" {
  cidr_block = var.main_vpc_cidr
  tags = {
      "Name" = local.vpc_name,
      "kubernetes.io/cluster/${local.cluster_name}" = "shared",
  }
}

# subnet definition
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public-subnet-a" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
      "Name" = (
          "${local.vpc_name}-public-subnet-a"
      )
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
      "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public-subnet-b" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_b_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
      "Name" = (
          "${local.vpc_name}-public-subnet-b"
      )
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
      "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "private-subnet-a" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
      "Name" = (
          "${local.vpc_name}-private-subnet-a"
      )
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private-subnet-b" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_b_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
      "Name" = (
          "${local.vpc_name}-private-subnet-b"
      )
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb" = "1"
  }
}
