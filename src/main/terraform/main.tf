# Specify the provider and access details
provider "aws" {
  region                = "${var.aws_region}"
  profile               = "${var.aws_profile}"
}

# Sets up the entire network including gateways
module "aws_vpc" {
  source                = "./vpc"
  environment_name      = "${var.environment_name}"
  aws_region            = "${var.aws_region}"
  aws_profile           = "${var.aws_profile}"
  aws_key_name          = "${var.aws_key_name}"
  aws_private_vpc_cidr  = "${var.aws_private_vpc_cidr}"
  aws_public_vpc_cidr   = "${var.aws_public_vpc_cidr}"
  aws_sn_1_cidr         = "${var.aws_sn_1_cidr}"
  aws_sn_2_cidr         = "${var.aws_sn_2_cidr}"
  bastion_network_cidr  = "${var.bastion_network_cidr}"
}

# Bastion host accessible from the public subnet
module "bastion_host" {
  source                = "./bastion"
  environment_name      = "${var.environment_name}"
  aws_region            = "${var.aws_region}"
  aws_profile           = "${var.aws_profile}"
  aws_key_name          = "${var.aws_key_name}"
  aws_security_group_id = "${module.aws_vpc.sg_1_id}"
  aws_subnet_id         = "${module.aws_vpc.sn_1_id}"
  aws_ami               = "${lookup(var.aws_amis, var.aws_region)}"
}

# Application host for testing
module "application_host" {
  source                = "./application"
  environment_name      = "${var.environment_name}"
  aws_region            = "${var.aws_region}"
  aws_profile           = "${var.aws_profile}"
  aws_key_name          = "${var.aws_key_name}"
  aws_security_group_id = "${module.aws_vpc.sg_2_id}"
  aws_subnet_id         = "${module.aws_vpc.sn_2_id}"
  aws_ami               = "${lookup(var.aws_amis, var.aws_region)}"
}
