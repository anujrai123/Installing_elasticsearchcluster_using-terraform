module "vpc" {
  source        = "./vpc"
  vpc_cidr      = "10.0.0.0/16"
  public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

}

module "ec2" {
  source         = "./ec2-instance"
  my_public_key  = "/tmp/id_rsa.pub"
  instance_type  = "t2.micro"
  ami_id         = "ami-0d18acc6e813fd2e0"
  security_group = module.vpc.security_group
  subnets1       = module.vpc.public_subnets
  subnets2       = module.vpc.private_subnets
}

module "ami" {
  source      = "./ami_creation"
  instance_id = module.ec2.instance1_id
}
