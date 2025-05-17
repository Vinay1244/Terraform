provider "aws" {
region = "ap-northeast-1"
}

#Creating a VPC with test-vpc
resource "aws_vpc" "my_vpc" {
cidr_block = "10.0.0.0/16"
enable_dns_support = true
enable_dns_hostnames = true
tags = {
Name = "test-vpc"
}
}


#Creating a Public Subnet insdie a VPC
resource "aws_subnet" "public_subnet" { 
vpc_id = aws_vpc.my_vpc.id
cidr_block = "10.0.1.0/24"
map_public_ip_on_launch=true
availability_zone = "ap-northeast-1a"
tags = {
Name = "pub-sub"
}
}

#Creating a Private Subnet insdie a VPC
resource "aws_subnet" "private_subnet" {
vpc_id = aws_vpc.my_vpc.id
cidr_block = "10.0.2.0/24"
availability_zone = "ap-northeast-1a"
tags = {
Name = "pvt-sub"
}
}

#Creating a IGW at VPC level
resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.my_vpc.id
tags = {
Name = "test-igw"
}
}

#Creating a public route table from public subnet to IGW
resource "aws_route_table" "public_route" {
vpc_id = aws_vpc.my_vpc.id
route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.igw.id
}
tags = {
Name = "pub-route"
}
}

#Attaching public route to public subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
}

#Creating an elastic Ip for NAT
resource "aws_eip" "nat_eip" {
vpc = true
}

#Creating a NAT gateway inside a public subnet
resource "aws_nat_gateway" "nat_gw" {
allocation_id = aws_eip.nat_eip.id
subnet_id = aws_subnet.public_subnet.id
tags = {
Name = "test-ngw"
}
}

#Create a Private route table from private subnet to NAT
resource "aws_route_table" "private_route" {
vpc_id = aws_vpc.my_vpc.id
route {
cidr_block = "0.0.0.0/0"
nat_gateway_id = aws_nat_gateway.nat_gw.id
}
tags = {
Name = "pvt-route"
}
}

#Attaching private route to priavte subnet
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route.id
}

#creating Security Group
resource "aws_security_group" "ec2_sg" {
 name        = "ec2-sg"
  description = "Allow SSH and ping"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}

#Creating a key for ssh
resource "aws_key_pair" "vinay_tf_key" {
  key_name   = "vinay-vpc"
  public_key = file("/home/ubuntu/.ssh/vinay-vpc.pub")
}

#Creating an EC2 on public subnet for Internet connectivity
resource "aws_instance" "public_ec2" {
  ami                    = "ami-0f415cc2783de6675"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  key_name               = aws_key_pair.vinay_tf_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "public-ec2"
  }
}


#Creating an EC2 on private subnet for Internet connectivity
resource "aws_instance" "private_ec2" {
  ami = "ami-0f415cc2783de6675"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  associate_public_ip_address = false
  key_name               = aws_key_pair.vinay_tf_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "private-ec2"
  }
}

