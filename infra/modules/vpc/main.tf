locals {
  vpc_tags = merge(
    var.tags,
    {
      Name      = var.name
      component = "network"
    }
  )

  catch_all_ip = "0.0.0.0/0"

  # Subnet IDs grouped by type from subnet tags
  public_subnet_ids = {
    for k, s in aws_subnet.this : k => s.id
    if s.tags["type"] == "public"
  }

  private_subnet_ids = {
    for k, s in aws_subnet.this : k => s.id
      if s.tags["type"] == "private"
  }
}

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true

  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
  instance_tenancy                     = var.instance_tenancy

  tags = local.vpc_tags
}

resource "aws_subnet" "this" {

  for_each = var.subnet_config

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  # Public subnets auto-assign public IPs; private do not
  map_public_ip_on_launch = each.value.type == "public"

  tags = merge(
    var.tags,
    each.value.tags,
    {
      Name = "${var.name}-${each.key}"
      type = each.value.type
    }
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-igw" })
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = merge(var.tags, { Name = "${var.name}-nat-eip" })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {

  allocation_id = aws_eip.nat.id

  subnet_id     = aws_subnet.this["public_a"].id

  tags = merge(var.tags, { Name = "${var.name}-nat" })
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = local.catch_all_ip
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route_table_association" "public_rt" {
  for_each = local.public_subnet_ids

  route_table_id = aws_route_table.public_rt.id
  subnet_id      = each.value
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = local.catch_all_ip
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = merge(var.tags, { Name = "${var.name}-private-rt" })
}

resource "aws_route_table_association" "private_rt" {

  for_each = local.private_subnet_ids

  route_table_id = aws_route_table.private_rt.id
  subnet_id      = each.value
}