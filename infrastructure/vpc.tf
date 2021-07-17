#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "etopia-mobile" {
  cidr_block = "10.0.0.0/16"

  tags = map(
    "Name", "terraform-eks-etopia-mobile-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_subnet" "etopia-mobile" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.etopia-mobile.id

  tags = map(
    "Name", "terraform-eks-etopia-mobile-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_internet_gateway" "etopia-mobile" {
  vpc_id = aws_vpc.etopia-mobile.id

  tags = {
    Name = "terraform-eks-etopia-mobile"
  }
}

resource "aws_route_table" "etopia-mobile" {
  vpc_id = aws_vpc.etopia-mobile.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.etopia-mobile.id
  }
}

resource "aws_route_table_association" "etopia-mobile" {
  count = 2

  subnet_id      = aws_subnet.etopia-mobile.*.id[count.index]
  route_table_id = aws_route_table.etopia-mobile.id
}
