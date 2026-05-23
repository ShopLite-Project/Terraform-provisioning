resource "aws_vpc" "main" {
  cidr_block           = var.config.cidr_block
  enable_dns_support   = var.config.enable_dns_support
  enable_dns_hostnames = var.config.enable_dns_hostnames

  tags = merge(var.tags, {
    Name = "${var.tags["Environment"]}-${var.tags["Project"]}-vpc"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.tags["Environment"]}-${var.tags["Project"]}-igw"
  })
}

resource "aws_subnet" "public" {
  count = length(var.config.availability_zones)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.config.cidr_block, 8, count.index)
  availability_zone       = var.config.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name                                               = "${var.tags["Environment"]}-${var.tags["Project"]}-public-${count.index + 1}"
    "kubernetes.io/role/elb"                           = "1"
    "kubernetes.io/cluster/${var.config.cluster_name}" = "shared"
  })
}

resource "aws_subnet" "private" {
  count = length(var.config.availability_zones)

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.config.cidr_block, 8, count.index + length(var.config.availability_zones))
  availability_zone = var.config.availability_zones[count.index]

  tags = merge(var.tags, {
    Name                                               = "${var.tags["Environment"]}-${var.tags["Project"]}-private-${count.index + 1}"
    "kubernetes.io/role/internal-elb"                  = "1"
    "kubernetes.io/cluster/${var.config.cluster_name}" = "shared"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["Environment"]}-${var.tags["Project"]}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  count = length(var.config.availability_zones)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = length(var.config.availability_zones)
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.tags["Environment"]}-${var.tags["Project"]}-private-rt-${count.index + 1}"
  })
}

resource "aws_route_table_association" "private" {
  count = length(var.config.availability_zones)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_network_acl" "open" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.tags["Environment"]}-${var.tags["Project"]}-nacl"
  })
}

resource "aws_network_acl_rule" "inbound" {
  for_each = {
    for rule in var.config.open_inbound_acl_rules : rule.rule_number => rule
  }

  network_acl_id  = aws_network_acl.open.id
  egress          = false
  rule_number     = each.value.rule_number
  rule_action     = each.value.rule_action
  protocol        = each.value.protocol
  from_port       = try(each.value.from_port, 0)
  to_port         = try(each.value.to_port, 0)
  icmp_code       = try(each.value.icmp_code, null)
  icmp_type       = try(each.value.icmp_type, null)
  cidr_block      = try(each.value.cidr_block, null)
  ipv6_cidr_block = try(each.value.ipv6_cidr_block, null)
}

resource "aws_network_acl_rule" "outbound" {
  for_each = {
    for rule in var.config.open_outbound_acl_rules : rule.rule_number => rule
  }

  network_acl_id  = aws_network_acl.open.id
  egress          = true
  rule_number     = each.value.rule_number
  rule_action     = each.value.rule_action
  protocol        = each.value.protocol
  from_port       = try(each.value.from_port, 0)
  to_port         = try(each.value.to_port, 0)
  icmp_code       = try(each.value.icmp_code, null)
  icmp_type       = try(each.value.icmp_type, null)
  cidr_block      = try(each.value.cidr_block, null)
  ipv6_cidr_block = try(each.value.ipv6_cidr_block, null)
}

resource "aws_network_acl_association" "public" {
  count = length(var.config.availability_zones)

  subnet_id      = aws_subnet.public[count.index].id
  network_acl_id = aws_network_acl.open.id
}

resource "aws_network_acl_association" "private" {
  count = length(var.config.availability_zones)

  subnet_id      = aws_subnet.private[count.index].id
  network_acl_id = aws_network_acl.open.id
}

locals {
  gateway_endpoints = {
    s3       = "com.amazonaws.${var.region}.s3"
    dynamodb = "com.amazonaws.${var.region}.dynamodb"
  }
}

resource "aws_vpc_endpoint" "gateways" {
  for_each = local.gateway_endpoints

  vpc_id            = aws_vpc.main.id
  service_name      = each.value
  vpc_endpoint_type = "Gateway"
  route_table_ids   = concat([aws_route_table.public.id], aws_route_table.private[*].id)

  tags = merge(var.tags, {
    Name = "${var.tags["Environment"]}-${var.tags["Project"]}-${each.key}-endpoint"
  })
}
