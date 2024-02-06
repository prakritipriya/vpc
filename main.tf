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
resource "aws_subnet" public_subsets" {
  vpc_id     = aws_vpc.main.id
  count=length(var.public_subnet_cidrs)
  cidr_block=element(var.public_subnet_cidrs,count.index)

  tags = {
    Name = "Public_Subset- ${count.index+1}"
  }
}
resource "aws_subnet" private_subsets" {
  vpc_id     = aws_vpc.main.id
  count=length(var.private_subnet_cidrs)
  cidr_block=element(var.private_subnet_cidrs,count.index)

  tags = {
    Name = "Private_Subset- ${count.index+1}"
  }
}
