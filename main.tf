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
