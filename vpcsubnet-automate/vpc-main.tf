################ VPC #################
resource "aws_vpc" "main" {
  cidr_block       = "${var.main_vpc_cidr}"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

 ################# Subnets #############
# Subnets : public
resource "aws_subnet" "public" {
  count = "${length(var.subnets_cidr)}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${element(var.publicsubnets_cidr,count.index)}"
  availability_zone = "${element(var.azs,count.index)}"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_Subnet-${count.index+1}"
  }
}
#Subnets : private

resource "aws_subnet" "private" {
  count = "${length(var.privatesubnets_cidr)}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${element(var.privatesubnets_cidr,count.index)}"
  availability_zone = "${element(var.azs,count.index)}"
  tags = {
    Name = "private_Subnet-${count.index+1}"
  }
}
######## IGW ###############
resource "aws_internet_gateway" "main-igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "main-igw"
  }
}

########### NAT ##############
resource "aws_eip" "nat" {
}

resource "aws_nat_gateway" "main-natgw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id      = "${element(aws_subnet.public.*.id, 1)}"
  depends_on    = ["aws_internet_gateway.main-igw"]
  tags = {
    Name = "main-nat"
  }
}

# Route table: attach Internet Gateway 
resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main-igw.id}"
  }
  tags = {
    Name = "publicRouteTable"
  }
}

#Public route table association with public subnets

resource "aws_route_table_association" "route" {
  count          = "${length(var.subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.public.*.id,count.index)}"
  route_table_id = "${aws_route_table.public_rt.id}"
}
# Routing table for private subnets
resource "aws_route_table" "rtblPrivate" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.main-natgw.id}"
  }

  tags = {
    Name = "rtblPrivate"
  }
}
#private route table association with private subnets 

resource "aws_route_table_association" "private_route" {
  count          = "${length(var.subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.private.*.id,count.index)}"
  route_table_id = "${aws_route_table.rtblPrivate.id}"
}
