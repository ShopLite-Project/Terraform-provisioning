output "vpc_id" {
  description = "Created VPC ID."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = aws_subnet.private[*].id
}

output "public_route_table_id" {
  description = "Public route table ID."
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "Private route table IDs."
  value       = aws_route_table.private[*].id
}

output "internet_gateway_id" {
  description = "Internet gateway ID."
  value       = aws_internet_gateway.igw.id
}

output "network_acl_id" {
  description = "Network ACL ID."
  value       = aws_network_acl.open.id
}

output "gateway_endpoint_ids" {
  description = "Gateway VPC endpoint IDs."
  value       = { for key, endpoint in aws_vpc_endpoint.gateways : key => endpoint.id }
}
