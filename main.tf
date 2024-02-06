provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}
resource "aws_vpc" "main"{
    cidr_block="10.0.0.0/16"
    instance_tenancy="default"

    tags={
        Name="dev-vpc"
    }
}
resource "aws_subnet" "some_public_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
 
  tags = {
    Name = "Some Public Subnet"
  }
}

resource "aws_subnet" "public_subsets" {
  vpc_id     = aws_vpc.main.id
  count=length(var.public_subnet_cidrs)
  cidr_block=element(var.public_subnet_cidrs,count.index)
#cidr_block ="10.0.1.0/24"
  tags = {
    Name = "Public_Subset-${count.index+1}"
  }
}
resource "aws_subnet" "private_subsets" {
  vpc_id     = aws_vpc.main.id
  count=length(var.private_subnet_cidrs)
  cidr_block=element(var.private_subnet_cidrs,count.index)

  tags = {
    Name = "Private_Subset- ${count.index+1}"
  }
} 

resource "aws_security_group" "allow_all" {
    name="allow_all"
    description ="Allow all inbound and outbound traffic"
    vpc_id=aws_vpc.main.id

    tags={
        Name="dev-sg"
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_traffic" {
security_group_id =aws_security_group.allow_all.id
cidr_ipv4 ="0.0.0.0/0"
ip_protocol ="-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
security_group_id =aws_security_group.allow_all.id
cidr_ipv4 ="0.0.0.0/0"
ip_protocol ="-1"
}

resource "aws_instance" "dev_ec2" {
  ami           = data.aws_ami.app_ami.image_id
  #ami           = "ami-0a3c3a20c09d6f377"
  instance_type = "t2.micro"
depends_on     = [aws_vpc.main]

 subnet_id =[aws_subnet.public_subsets[count.index].id]
# vpc_security_group_ids = aws_security_group.allow_all.id 
vpc_security_group_ids      = [aws_security_group.allow_all.id]
  tags = {
    Name = "HelloWorld"
  }
}

data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.3.20240122.0-kernel-6.1-x86_64"]
  }

}

