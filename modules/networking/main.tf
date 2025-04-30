resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

resource "aws_subnet" "public" {
  count = var.create_vpc ? length(var.public_subnets) : 0

  vpc_id                  = aws_vpc.this[0].id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "${var.name}-public-${element(var.azs, count.index)}"
    },
    var.tags
  )
}

resource "aws_subnet" "private" {
  count = var.create_vpc ? length(var.private_subnets) : 0

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = element(var.azs, count.index)

  tags = merge(
    {
      Name = "${var.name}-private-${element(var.azs, count.index)}"
    },
    var.tags
  )
}

resource "aws_internet_gateway" "this" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    {
      Name = "${var.name}-igw"
    },
    var.tags
  )
}

resource "aws_route_table" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    {
      Name = "${var.name}-public-rt"
    },
    var.tags
  )
}

resource "aws_route" "public_internet_gateway" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    {
      Name = "${var.name}-private-rt"
    },
    var.tags
  )
}

resource "aws_route_table_association" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private[0].id
}

resource "aws_security_group" "ec2" {
  name        = "${var.name}-ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = var.create_vpc ? aws_vpc.this[0].id : var.vpc_id

  dynamic "ingress" {
    for_each = var.ec2_sg_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    {
      Name = "${var.name}-ec2-sg"
    },
    var.tags
  )
}