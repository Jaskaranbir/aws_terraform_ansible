data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "${format(
        "%s%s%s",
        "ubuntu/images/hvm-ssd/ubuntu-xenial-",
        var.ami_ubuntu_version,
        "-amd64-server-*"
      )}",
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

provider "aws" {
  version = "~> 1.22.0"
  region  = "${var.aws_region}"

  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}
