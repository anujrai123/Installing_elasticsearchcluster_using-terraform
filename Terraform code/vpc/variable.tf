variable "vpc_cidr" {

}

variable "public_cidrs" {
  type = list(string)

}

variable "private_cidrs" {
  type = list(string)

}
