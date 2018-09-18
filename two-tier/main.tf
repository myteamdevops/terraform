# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

module "network" {
  source = "network"
}

module "security" {
  source = "security"
  role = "${var.role}"
  public_key_path = "${var.public_key_path}"
  vpc_id = "${module.network.vpc_id}"
}

module "elb" {
  source = "elb"
  role = "${var.role}"
  subnet_id = "${module.network.subnet_id}"
  elb_sg_id = "${module.security.elb_sg_id}"
}

module "asg" {
  source = "asg"
  role = "${var.role}"
  instance_type = "${var.instance_type}"
  aws_amis = "${var.aws_amis}"
  elb_name = "${module.elb.elb_name}"
  subnet_id = "${module.network.subnet_id}"
  aws_region = "${var.aws_region}"
  public_key_path = "${var.public_key_path}"
  sg_id = "${module.security.ec2_sg_id}"
}

output "elb_address" {
  value = "${module.elb.address}"
}
