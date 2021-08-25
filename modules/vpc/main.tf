resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public" {
  cidr_block              = cidrsubnet(var.cidr_block, 4, 0)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "default_public" {
  route_table_id         = aws_route_table.rt_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "rta_public" {
  route_table_id = aws_route_table.rt_public.id
  subnet_id      = aws_subnet.public.id
}
