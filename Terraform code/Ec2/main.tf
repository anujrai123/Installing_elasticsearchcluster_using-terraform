provider "aws" {
  region = "ap-south-1"
  #Using static credentials for the creation of resources in AWS
  access_key = ""
  secret_key = ""
}

resource "aws_default_vpc" "elasticsearch_vpc" {
  tags = {
    Name = "elasticsearch-vpc"
  }
}

data "aws_availability_zones" "available" {}
#using aws ami public repository

resource "aws_key_pair" "mytest-key" {
  key_name   = "my-test-terraform-key-new1"
  public_key = file(var.my_public_key)
}

data "template_file" "init" {
  template = file("${path.module}/script.sh")
}

resource "aws_instance" "my-instance" {
  count                   = 2
  ami                     = "var.ami_id"
  instance_type           = var.instance_type
  key_name                = aws_key_pair.mytest-key.id
  vpc_security_group_ids  = ["${var.security_group}"]
  subnet_id               = element(var.subnets1, count.index)
  user_data               = data.template_file.init.rendered
  encrypted               = true
  disable_api_termination = true

  tags = {
    Name = "elasticsearch-${count.index + 1}"
  }
}
