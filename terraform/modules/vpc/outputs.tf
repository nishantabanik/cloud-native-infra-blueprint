
output "private_subnets" {
  description = "A list of private subnet IDs"
  value       = aws_subnet.private.*.id
}

output "public_subnets" {
  description = "A list of public subnet IDs"
  value       = aws_subnet.public.*.id
}

output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = element(concat(aws_vpc.vpc.*.main_route_table_id, tolist([""])), 0)
}

output "default_route_table_id" {
  description = "The ID of the default route table in the VPC"
  value       = element(concat(aws_vpc.vpc.*.default_route_table_id, tolist([""])), 0)
}

output "public_route_table_ids" {
  description = "The IDs of the route tables used by the public subnet"
  value       = aws_route_table.public.*.id
}

output "private_route_table_ids" {
  description = "The IDs of the route tables used by the private subnet"
  value       = aws_route_table.private.*.id
}

output "default_security_group_id" {
  description = "The default security group created in the VPC"
  value       = aws_vpc.vpc.default_security_group_id
}

output "nat_eips" {
  description = "The allocation ID for the NAT Gateway Elastic IPs "
  value       = aws_eip.nateip.*.id
}

output "nat_eips_public_dns" {
  description = "The public DNS' associated with the NAT Gateways"
  value       = aws_eip.nateip.*.public_dns
}

output "nat_eips_public_ips" {
  description = "The public addresses associated with the NAT Gateways"
  value       = aws_eip.nateip.*.public_ip
}

output "nat_eips_private_ips" {
  description = "The private addresses associated with the NAT Gateways"
  value       = aws_eip.nateip.*.private_ip
}

output "natgw_ids" {
  description = "The IDs of the NAT Gateways created in the VPC"
  value       = aws_nat_gateway.natgw.*.id
}

output "igw_id" {
  description = "The ID of the Internet Gateway in the VPC"
  value       = aws_internet_gateway.vpc.id
}

### IPV6 related

output "vpc_ipv6_cidr_block" {
  description = "The IPV6 CIDR block of the VPC"
  value       = can(regex(".*::/56",aws_vpc.vpc.ipv6_cidr_block)) ? aws_vpc.vpc.ipv6_cidr_block : "IPV6_NOT_ENABLED"
}

output "vpc_ipv6_association_id" {
  description = "The association ID of the IPV6 CIDR block attached to the VPC"
  value       = can(regex("vpc-cidr-assoc-.*", aws_vpc.vpc.ipv6_association_id)) ? aws_vpc.vpc.ipv6_association_id : "IPV6_NOT_ENABLED"
}


