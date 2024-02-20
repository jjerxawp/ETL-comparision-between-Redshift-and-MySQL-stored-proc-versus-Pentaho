resource "aws_vpc" "asm3_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.asm3_vpc.id
  cidr_block              = var.subnet[0]
  availability_zone       = var.availability_zone[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "public"
  }
}

resource "aws_internet_gateway" "asm3_igw" {
  vpc_id = aws_vpc.asm3_vpc.id
  depends_on = [
    aws_vpc.asm3_vpc
  ]
}

resource "aws_default_route_table" "asm3_public_rt" {
  default_route_table_id = aws_vpc.asm3_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.asm3_igw.id
  }
  tags = {
    Name = "asm3_public_route"
  }
}

resource "aws_route_table_association" "asm3_public_route" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_default_route_table.asm3_public_rt.id
}

resource "aws_security_group" "asm3_5439" {
  name        = "allow_5439"
  description = "Allow traffic from 5439 to Redshift"
  vpc_id      = aws_vpc.asm3_vpc.id

  ingress {
    description = "Rule for traffic from 5439"
    from_port   = 5439
    to_port     = 5439
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

resource "aws_security_group" "asm3_sct" {
  name        = "SchemaConversionTool"
  description = "Allow SSH for ssh host"
  vpc_id      = aws_vpc.asm3_vpc.id

  ingress {
    description = "Rule for SSH traffic from 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Rule for SSH traffic from 3389 - RDP"
    from_port   = 3389
    to_port     = 3389
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



