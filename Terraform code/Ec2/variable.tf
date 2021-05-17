variable "my_public_key" {}

variable "instance_type" {}

variable "security_group" {}

#public subnet
variable "subnets1" {
  type = list(string)
}

#private subnet
variable "subnets2" {
  type = list(string)
}
