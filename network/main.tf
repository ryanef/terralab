data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "terralab" {
  cidr_block       = "10.10.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames  = true

  tags = {
    Name = "TerraLab"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "tl-public-sn" {
  vpc_id     = aws_vpc.terralab.id
  count = length(var.public_cidrs)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.public_cidrs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "terralab-public-sn-${count.index + 1}"
  }
}

resource "aws_subnet" "tl-private-sn" {
  vpc_id     = aws_vpc.terralab.id

  cidr_block = "10.10.64.0/20"
  map_public_ip_on_launch = true

  tags = {
    Name = "terralab-public-sn"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terralab.id

  tags = {
    Name = "terralab-igw"
  }
}

resource "aws_default_route_table" "tl_default_rt" {
  default_route_table_id = aws_vpc.terralab.default_route_table_id



  tags = {
    Name = "tl-default-rt"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.terralab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }



  tags = {
    Name = "tl-public-rt"
  }
}

resource "aws_route_table_association" "tl-public-subs" {
count = length(var.public_cidrs)
  subnet_id      = aws_subnet.tl-public-sn[count.index].id
  route_table_id = aws_route_table.public_rt.id
}