

######################################################################
# BUILD VPC
######################################################################
resource "aws_vpc" "vpc" {
  cidr_block                       = var.cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  assign_generated_ipv6_cidr_block = var.enable_ipv6
  tags                             = var.tags
}


######################################################################
# IPV6 CIDRs
######################################################################
locals {
  ipv6_cidr = can(regex(".*::/56", aws_vpc.vpc.ipv6_cidr_block)) ? aws_vpc.vpc.ipv6_cidr_block : "IPV6_NOT_ENABLED"
}

######################################################################
# PUBLIC AND PRIVATE SUBNETS
######################################################################
resource "aws_subnet" "private" {
  vpc_id                          = aws_vpc.vpc.id
  cidr_block                      = cidrsubnet(var.cidr, var.private_subnet_newbits, count.index + 1 + length(var.azs))
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(local.ipv6_cidr, 8, count.index) : null
  assign_ipv6_address_on_creation = var.assign_ipv6_address_on_creation
  availability_zone               = element(var.azs, count.index)
  count                           = length(var.azs)
  tags                            = merge(var.tags, var.private_subnet_tags, tomap({ "Name" = format("%sPrivate-%s", var.name, element(var.azs, count.index)) }))
}

resource "aws_subnet" "public" {
  vpc_id                          = aws_vpc.vpc.id
  cidr_block                      = cidrsubnet(var.cidr, var.public_subnet_newbits, count.index + 1)
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(local.ipv6_cidr, 8, count.index + length(var.azs)) : null
  assign_ipv6_address_on_creation = var.assign_ipv6_address_on_creation
  availability_zone               = element(var.azs, count.index)
  count                           = length(var.azs)
  tags                            = merge(var.tags, var.public_subnet_tags, tomap({ "Name" = format("%sPublic-%s", var.name, element(var.azs, count.index)) }))

  map_public_ip_on_launch = var.map_public_ip_on_launch
}

######################################################################
# ELASTIC IP NAT
######################################################################
resource "aws_eip" "nateip" {
  #vpc   = true
  count = length(var.azs) * (var.enable_nat_gateway ? 1 : 0)
  tags  = merge(var.tags, tomap({ "Name" = format("%s-%s-NAT-EIP", var.name, element(var.azs, count.index)) }))

  lifecycle {
    prevent_destroy = true
  }
}

######################################################################
# GATEWAYS
######################################################################
resource "aws_internet_gateway" "vpc" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(var.tags, tomap({ "Name" = format("%s-IGW", var.name) }))
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = element(aws_eip.nateip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  count         = length(var.azs) * (var.enable_nat_gateway ? 1 : 0)
  tags          = var.tags

  depends_on = [aws_internet_gateway.vpc]
}

resource "aws_egress_only_internet_gateway" "ipv6_private_gw" {
  count  = var.enable_ipv6 ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags   = merge(var.tags, tomap({ "Name" = format("%s-EOIGW", var.name) }))
}

######################################################################
# ROUTE TABLES
######################################################################

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc.id
}

resource "aws_route" "ipv6_public_internet_gateway" {
  count                       = var.enable_ipv6 ? 1 : 0
  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.vpc.id
}

resource "aws_route" "private_nat_gateway" {
  count                  = var.enable_nat_gateway ? length(aws_nat_gateway.natgw.*.id) : 0
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.natgw.*.id, count.index)
}

resource "aws_route" "ipv6_private_subnet_default" {
  count                       = var.enable_ipv6 ? length(aws_route_table.private.*.id) : 0
  route_table_id              = element(aws_route_table.private.*.id, count.index)
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.ipv6_private_gw[0].id
}

resource "aws_route_table" "public" {
  vpc_id           = aws_vpc.vpc.id
  propagating_vgws = var.public_propagating_vgws
  tags             = merge(var.tags, { Name = format("%sPublic", var.name) })
}

# for each of the private ranges, create a "private" route table.
resource "aws_route_table" "private" {
  vpc_id           = aws_vpc.vpc.id
  propagating_vgws = var.private_propagating_vgws
  count            = length(var.azs)
  tags             = merge(var.tags, tomap({ "Name" = format("%sPrivate-%s", var.name, element(var.azs, count.index)) }))
}

######################################################################
# ROUTE TABLE ASSOCIATION - ASSIGN SUBNETS TO THE ROUTE TABLE
######################################################################
resource "aws_route_table_association" "private" {
  count          = length(var.azs)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route_table_association" "public" {
  count          = length(var.azs)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

######################################################################
# VPC Endpoint for S3
######################################################################

data "aws_vpc_endpoint_service" "s3" {
  count   = var.enable_s3_endpoint ? 1 : 0
  service = "s3"
  service_type = "Gateway"
}

resource "aws_vpc_endpoint" "s3" {
  count        = var.enable_s3_endpoint ? 1 : 0
  vpc_id       = aws_vpc.vpc.id
  service_name = data.aws_vpc_endpoint_service.s3[0].service_name
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count           = length(aws_subnet.private) * (var.enable_s3_endpoint ? 1 : 0)
  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(aws_route_table.private.*.id, count.index)
}

#TODO check if this is actually being used and remove it
resource "aws_vpc_endpoint_route_table_association" "public_s3" {
  count           = length(var.public_subnets) * (var.enable_s3_endpoint ? 1 : 0)
  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = aws_route_table.public.id
}

