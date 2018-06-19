#--------------------------------------------------------------
# Provider-Specific
#--------------------------------------------------------------
variable "aws_region" {}

variable "instance_type" {}

variable "ami_ubuntu_version" {
  default = "16.04"
}

#--------------------------------------------------------------
# Keys
#--------------------------------------------------------------
variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "ssh_remote_user" {}
variable "ssh_public_key" {}
variable "ssh_public_key_file_location" {}

variable "ssh_private_key" {}
variable "ssh_private_key_file_location" {}

#--------------------------------------------------------------
# Meta
#--------------------------------------------------------------
variable "name" {}

#--------------------------------------------------------------
# Network
#--------------------------------------------------------------
variable "vpc_cidr" {}

variable "availability_zones" {}
variable "private_subnets" {}

#--------------------------------------------------------------
# VM-Instance
#--------------------------------------------------------------
variable "bootstrap_file_path" {}

#--------------------------------------------------------------
# Provider Configuration
#--------------------------------------------------------------
provider "aws" {
  version = "~> 1.22.0"
  region  = "${var.aws_region}"

  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

module "loraserver-prod" {
  source = "./aws_terraform"

  # Provider and Machine Specific
  name               = "${var.name}"
  instance_type      = "${var.instance_type}"
  ami_ubuntu_version = "${var.ami_ubuntu_version}"
  aws_region         = "${var.aws_region}"

  # Keys
  aws_access_key  = "${var.aws_access_key}"
  aws_secret_key  = "${var.aws_secret_key}"
  ssh_remote_user = "${var.ssh_remote_user}"
  ssh_public_key  = "${var.ssh_public_key == "" ? file(var.ssh_public_key_file_location) : var.ssh_public_key}"
  ssh_private_key = "${var.ssh_private_key == "" ? file(var.ssh_private_key_file_location) : var.ssh_private_key}"

  # Network
  vpc_cidr           = "${var.vpc_cidr}"
  availability_zones = "${var.availability_zones}"
  private_subnets    = "${var.private_subnets}"

  # VM-Instance
  bootstrap_file_path = "${file(var.bootstrap_file_path)}"
}

#--------------------------------------------------------------
# Module Outputs
#--------------------------------------------------------------
output "loraserver_public_ips" {
  value = "${module.loraserver-prod.public_ips}"
}

output "loraserver_private_ips" {
  value = "${module.loraserver-prod.private_ips}"
}
