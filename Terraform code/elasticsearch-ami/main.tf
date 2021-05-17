
provider "aws" {
  region = "ap-south-1"
}

resource "aws_ami_from_instance" "elasticsearch_ami" {
  name               = "elasticsearch-ami"
  source_instance_id = var.instance_id
}
